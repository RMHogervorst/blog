# Blog

[![Netlify Status](https://api.netlify.com/api/v1/badges/97d2a0b6-d630-46a1-9872-3384b20eb834/deploy-status)](https://app.netlify.com/sites/cranky-swirles-fd46ad/deploys)

This is the new repo for my blog. to be found at blog.rmhogervorst.nl and nicely deployed with netlify

build with hugo using the beautifulhugo theme, which I have modified somewhat.


Write all installed R packages to a file so we can ignore them from spelling.
```r
pkg<-as.vector(installed.packages()[,c(1)])
writeLines(pkg, ".github/actions/spelling/allow/rpkgs.txt")
```