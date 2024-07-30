---
title: Just enough kubernetes to be dangerous
description: "Know just enough kubernetes so you can participate and debug your own stuff."
subtitle: ""
date: 2024-07-30
preview: ""
tags:
    - data_science
    - kubernetes
    - MLOps
    - production
categories:
    - blog
difficulty:
    - intermediate
post-type:
    - thoughts
share_img: ""
image: "/img/k8smemes/swiftsec_explain.jpg"
type: default
---

As a data scientist that wants to achieve production results, one of the best options is to make your work available in kubernetes. Because kubernetes runs on all clouds and because many organizations use kubernetes. Make your prediction API available in kubernetes and your organization can 'just' plug it into their systems. Many data scientists don't know anything about docker, not to mention kubernetes and its main tool helm.

![](/img/k8smemes/shipmachine.png)

I think you should learn and practice just enough helm to be dangerous[^1]. What do I mean with dangerous? When something is completely new, you are afraid to touch it. But new topics are vast, there are thousands of videos, blogposts and even certified courses to master kubernetes and helm. I think for most data scientists you should be somewhere further then afraid but stay away from complete mastery though, that is way too much.

![](/img/k8smemes/1nfs7jo7e4k71.jpg)
![](/img/k8smemes/k8sshanty.jpg0)
![](/img/k8smemes/swiftsec_explain.jpg)

You can experiment with kubernetes on your laptop with docker[^2], k3s or minicube. Create a prediction API, put it into a container and experiment with deployments (replicasets), statefulsets and jobs. One of the ways I keep my fears in check is by making sure I can unfuck my mistakes. Your options in helm are `helm template` that just prints the filled in things to stdout, `helm upgrade --install --dry-run` that checks if your installation is even possible and finally after deployment for real you can check kubernetes events  `kubectl get events -n <namespace>`  and the logs[^3] of the container you just pushed `kubectl logs deployment/<name of deployment> -n <namespace>`. 
Finally if you did bork up, you can delete a helm deployment, or roll back. 


[^1]: Just enough to be dangerous is a psychological thing where people get overconfident when they are no longer novices, that leads them to make massive mistakes that are dangerous. I don't think you should be THAT dangerous. But you can achieve way more than you initially think. 
[^2]: docker has changed its licence model so don't do this on your organization laptop, in fact stay away from docker if you can, I hear podman is quite nice. Docker has lawyers, the scary kind.
[^3]: you did add logs right?
[^4]: we also create an alias `k` for `kubectl`, so make of that what you will.

![](/img/k8smemes/evergreen.webp)

## notes

I spiced up this post with some dank k8s _(that is how cool people spell kubernetes[^4])_ memes, found at the following places:

- <https://programmerhumor.io/wp-content/uploads/2021/09/programmerhumor-io-cloud-memes-programming-memes-d52e7b28ab2f410-608x469.jpg>
- <https://pholder.com/kubernetes>
- <https://imgur.com/DbqFymX>
- <https://miro.medium.com/v2/resize:fit:1104/1*3wrB0iUmQfYR9OayrVxECw.jpeg>