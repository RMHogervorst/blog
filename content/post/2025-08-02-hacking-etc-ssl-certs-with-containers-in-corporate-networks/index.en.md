---
title: Hacking `/etc/ssl/certs/` with Containers in Corporate Networks
author: Roel M. Hogervorst
date: '2025-08-02'
publishDate: '2026-01-03'
lastmod: '2026-01-03'
slug: hacking-etc-ssl-certs-with-containers-in-corporate-networks
categories:
  - blog
tags:
  - kubernetes
subtitle: ''
image: /blog/2025/08/02/hacking-etc-ssl-certs-with-containers-in-corporate-networks/liam-truong-htpU_wGEcW0-unsplash.jpg
difficulty:
  - advanced
post-type:
  - lessons-learned
---

<!-- content  -->

As a consultant I come into different organizations, usually of the larger size.  
Making my custom applications work in those orgs, often revolves around TLS certificates.

_This post explains how you can add custom certificates, but also how you can skip that part by injecting certificates into a pod._


## Self-signed certificates in large orgs

If you work in open environments you never have to think about this, but companies
of a certain size start to build a large (internal) intRAnet with custom pages and custom domains.
They use self-signed certificates for those website and services. They also terminate 
TLS connections at the border of their internet and re-encrypt traffic with their own certificate
(this allows for more efficient caching and allow inspection of traffic). _(If you work at a large org and want to see if your org does tls termination, go to any website out of your org (bbc.com for example) and check the certificate details to see if it is signed by GlobalSign NV or your org, fun![^3])_

![A hogwarts wizardry school acceptance letter, which is sort of like a certificate?](liam-truong-htpU_wGEcW0-unsplash.jpg)

## TLS on the internet

Almost all the websites in the world use TLS[^2] (transport layer security). It works with certificates. A certificate is a cryptographically signed document that tells the browser (or your app) that the website they are visiting is in fact that website. How does your browser determine that that is true? The browser checks the certificate; if that certificate is in the root store of the device or root store of the browser the certificate checks out and the connection is allowed. That never happens. There are currently 148 certificates in my root store on this ubuntu machine.

If the certificate is not in the store, a chain of certificates is followed until a certificate is found that matches one in the root store. Because every certificate is signed by another certificate.  That certificate is signed by another and so on. In practice a certificate authority has one root cert that is kept very private, that certificate is used to sign intermediate certificates, those are then used to sign others and finally one of those certificates is used to sign certificates of websites[^1]. So my browser sees a certificate that signs the blog.rmhogervorst.nl website, that certificate comes from letsencrypt and is signed by an E6 certificate (which is also from letsencrypt) and that one is signed by ISRG Root X1. which is in my root store

[^1]: I know, I know, signing a certificate with a certificate is not correct. There are keys involved and PEMs and restrictions on what a key can sign and what not, and there are specific periods when keys/certs are valid. But I won't really explain all of that just because I found a cool trick. Certs signing certs are lies we tell children, until they are ready to learn more.
[^2]: It was called SSL before, I am not just saying that to sound smart and senior, but to help you find this website if you searched for SSL certificate, in stead of TLS certificate.
[^3]: I'm fun at parties

## Dealing with self-signed certificates

In general there are two ways to deal with custom certificates that do not live in your trust store.
**One: ignore mismatches**, just allow any certificate and don't care if it is valid or not. This is not smart, nor secure.
**Two: add the custom certificate to the trust store of the device.** Large corporations routinely do this on their laptops and servers.

But I create services based on plain linux containers (or python or whatever, but ultimately they are based on ubuntu or alpine). _As always, when you run linux you are on your own._
Luckily there is a well known process to add new certificates to the trust store of ubuntu. 
You place a new certificate in `/usr/local/share/ca-certificates` and run `sudo update-ca-certificates` and voila, your container validates and trust the internal certificate.

If you build a container you can do this as one of the first steps in the Dockerfile.
If you have a python process that does the calls you can skip the update-ca-certificate step and just use
env-vars to the let the process know where to find the certificate.

However if you use a premade container and don't want to build on top of that container you can tweak the deployment to make it work.

### What does update-ca-certificates do?

the `update-ca-certificates` command is actually a shell script (in /usr/sbin/update-ca-certificates) that does a lot of things. 
- it takes the new certificate that ends in `.crt` and creates a symlink in /etc/ssl/certs/ with filename.pem
- it appends the certificate to the file `/etc/ssl/certs/ca-certificates`
- it creates a hash of the certificate  with `OPENSSL x509 -hash -fingerprint` and creates a symlink in /etc/ssl/certs with the name `[hash].0` unless there already is a file with that hash, than it increments the number.  (These files are used by curl to quickly compare certs based on hash, quite cool actually)

### Make your life in corporate kubernetes world easier by hacking ubuntu and pods

Here is what I realized: you only need to trust **one** certificate, all the others are not relevant _(because all internal traffic is signed with certificates that ultimately end up in the same root key)_.
So you only need THAT certificate in the store. In kubernetes you can replace a directory with a configMap. What if we did the `update-ca-certificates` work ourselves on only the certificate that we need, but without all the other certificates. 

So we add the certificate twice, once under the name `ca-certificates` and once under the name `[hash].0` _(to make curl happy)_.

Here is the configMap:

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: certs
data:
	# this is an example, your certificate looks different and will have a different hash
    ca-certificates: |
	    -----BEGIN CERTIFICATE-----
		MIIDazCCAlOgAwIBAgIUKSwhLqUWcb/9OWLDSa8AYrqLIoswDQYJKoZIhvcNAQEL
		BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
		[...]
		fcbORe+ZcVJSfH9XD9gs
		-----END CERTIFICATE-----
	9da13359.0: |
		-----BEGIN CERTIFICATE-----
		MIIDazCCAlOgAwIBAgIUKSwhLqUWcb/9OWLDSa8AYrqLIoswDQYJKoZIhvcNAQEL
		BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM
		[...]
		fcbORe+ZcVJSfH9XD9gs
		-----END CERTIFICATE-----
```

And you can mount this configMap as files like so:

```yaml
[...]
    spec:
      containers:
	    [...]
		volumeMounts:
        - name: certificates
          mountPath: /etc/ssl/certs
      volumes:
      - name: certificates 
        configMap:
          name: certs
[...]
```

When the pod starts up it will replace the /etc/ssl/certs directory with 2 files (`ca-certificates` and `9da13359.0`). And the system will trust your corporate certificate! 

Is this better than other ways? I don't know, I thought it was elegant and hacky at the same time.

I got the inspiration from a stackoverflow post that I cannot find back.

### Alternatives

- If you use curl, you can also add the cert somewhere in the container (mounting that configMap to a place of your choice) and use an env-var CURL_CA_BUNDLE to point curl to the right place.
- If you use python (requests) you can do the same thing but use the env var REQUESTS_CA_BUNDLE.
- If you build the container from scratch, it is relatively little effort to add certificates in one of the first build steps.

#### more resources

- https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
- https://documentation.ubuntu.com/server/how-to/security/install-a-root-ca-certificate-in-the-trust-store/
