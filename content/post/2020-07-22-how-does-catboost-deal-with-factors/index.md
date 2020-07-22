---
title: How Does Catboost Deal with Factors in loading?
author: Roel M. Hogervorst
date: '2020-07-22'
slug: how-does-catboost-deal-with-factors
categories:
  - blog
tags:
  - catboost
  - explainer
  - clarification
  - intermediate
subtitle: 'What are you doing catboost?'
share_img: https://media.giphy.com/media/7Jpnmq5OGeOnb7nP3b/giphy.gif
output:
  html_document:
    keep_md: yes
---


<!-- useful settings for rmarkdown-->


<!-- content -->
Some people at [curso-r](https://github.com/curso-r), are working on an amazing extension of
parsnip and allow you to use tidymodels packages like {parsnip} and {recipes} with
the modern beasts of machine learning: lightgbm and catboost. 
the package is called [treesnip](https://github.com/curso-r/treesnip) and is still
in development. 

Both lightgbm and catboost can work with categorical features but how do you
pass those to the machinery? Both lightgbm and catboost use special data 
structures. 
I  was reading through the catboost documentation and 
it just wasn't very clear to me. So here is a small investigation.

```r 
library(catboost) # follow instructions here:
# https://catboost.ai/docs/installation/r-installation-binary-installation.html#r-installation-binary-installation
```

I took this example from one of the open [issues on github](https://github.com/catboost/catboost/issues/1246).


Create 3 datasets.

```r 
n <- 1000
set.seed(1)
X <- data.frame(
  catvar = sample(LETTERS[1:20], n, TRUE),
  matrix(rnorm(10 * n), ncol = 10), stringsAsFactors = FALSE)

y <- rnorm(n, rowSums(X[, 3:6] - abs(X[, 2] - 5)))

X3 <- X2 <- X
# dataframe with factor
X2$catvar <- factor(X$catvar)
# data frame where we set the factor to integer. (-1 because factors are from 1 up)
X3$catvar <- as.integer(X2$catvar)-1
head(X3[,1:3], 3)
```

```
  catvar      X1       X2
1      3  0.7268 -0.13314
2      6  0.6683 -0.08808
3      0 -2.4243  0.91779
```

CATBOOST only allows numeric and factor variables.
So a dataset with character column is not allowed:
```r 
pool_char <- catboost.load_pool(X, y, cat_features = 0)
```

```
Error in catboost.from_data_frame(data, label, pairs, weight, group_id,  : 
  Unsupported column type: character
```

Create 3 catboost datasets.
```r 
# first column is a factor ... but 0 based.
pool_factor <- catboost.load_pool(X2, y, cat_features = 0)
pool_factor_without_mentioning <- catboost.load_pool(X2, y)
pool_factor_made_int <- catboost.load_pool(X3, y, cat_features = 0)
pool_factor
```

```
catboost.Pool
1000 rows, 11 columns
```

I am unable to inspect the dataframe if there are factors in there.

```r 
head(pool_factor)
```

```
Error in head.catboost.Pool(pool_factor) : 
  catboost/R-package/src/catboostr.cpp:382: Cannot slice non-numeric features data
```
Without factors it DOES work for some reason.
```r 
head(pool_factor_made_int, 3)
```

```
       [,1] [,2] [,3]    [,4]     [,5]    [,6]    [,7]   [,8]    [,9]   [,10]
[1,] -12.16    1    3  0.7268 -0.13314  2.8621  0.8265 1.4400 -0.8859  0.6274
[2,] -18.62    1    6  0.6683 -0.08808  0.7180 -0.8437 0.3548 -0.7556 -0.7099
[3,] -29.12    1    0 -2.4243  0.91779 -0.3293 -2.1667 1.5187  1.6394 -0.2274
      [,11]   [,12]   [,13]
[1,] 2.1434  1.1348 -0.3994
[2,] 1.3830 -0.8258 -2.0756
[3,] 0.5689  1.0429 -0.5823
```


But there is another way to see what happens: train a model and put different
data in the prediction.

```r 
params <- list(iterations = 100, random_seed = 10, logging_level="Silent")
fit_factor <- catboost.train(pool_factor, params = params)
fit_factor_without_mentioning <- catboost.train(pool_factor_without_mentioning, params = params)
fit_factor_made_int <- catboost.train(pool_factor_made_int, params = params)
```


Predict on different data.

```r 
catboost.predict(fit_factor, pool_factor)[1]  # -12.47
catboost.predict(fit_factor, pool_factor_without_mentioning)[1] # -12.47
catboost.predict(fit_factor, pool_factor_made_int)[1] # ERROR
# Error in catboost.predict(fit_factor, pool_factor_made_int) : 
#  catboost/libs/data/model_dataset_compatibility.cpp:51: Feature catvar is Categorical in 
#  model but marked different in the dataset
```

2 first datasets are both working.
So that means the datasets in both cases use the factor column as a factor.
You do not need to provide the column numbers that are factors as long as you
provide the data as factors.

Let's predict with trained model based on second dataset.
You don't need to provide the factor column indices:

```r 
catboost.predict(fit_factor_without_mentioning, pool_factor)[1]  # -12.47
catboost.predict(fit_factor_without_mentioning, pool_factor_without_mentioning)[1] # -12.47
catboost.predict(fit_factor_without_mentioning, pool_factor_made_int)[1] # error
### identical as above
```



So what if we use the model without factors, but the categorical column index is
provided?

```r 
catboost.predict(fit_factor_made_int, pool_factor)[1]  # ERROR
# Error in catboost.predict(fit_factor_made_int, pool_factor) : 
#   catboost/libs/data/model_dataset_compatibility.cpp:51: Feature catvar is Float in model but marked different in the dataset
catboost.predict(fit_factor_made_int, pool_factor_without_mentioning)[1] # ERROR
# like above
catboost.predict(fit_factor_made_int, pool_factor_made_int)[1] # 12.48
```

In other words the data in prediction needs to look the same (numeric and factor
types) as the training data. You do not need to provide the categorical features
if you supply them as factors.

The two models are identical

```
fit_factor$feature_importances == fit_factor_without_mentioning$feature_importances
```
results in identical feature importance.



### References
- Find more explainers by me in [this overview page](https://blog.rmhogervorst.nl//tags/clarification/)

### Reproducibility
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```r 
sessioninfo::session_info()
```

```
─ Session info ───────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 4.0.2 (2020-06-22)
 os       macOS Catalina 10.15.5      
 system   x86_64, darwin17.0          
 ui       X11                         
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       Europe/Amsterdam            
 date     2020-07-22                  

─ Packages ───────────────────────────────────────────────────────────────────
 package     * version date       lib source        
 assertthat    0.2.1   2019-03-21 [1] CRAN (R 4.0.0)
 catboost    * 0.23.2  2020-07-15 [1] url           
 cli           2.0.2   2020-02-28 [1] CRAN (R 4.0.0)
 crayon        1.3.4   2017-09-16 [1] CRAN (R 4.0.0)
 digest        0.6.25  2020-02-23 [1] CRAN (R 4.0.0)
 evaluate      0.14    2019-05-28 [1] CRAN (R 4.0.0)
 fansi         0.4.1   2020-01-08 [1] CRAN (R 4.0.0)
 glue          1.4.1   2020-05-13 [1] CRAN (R 4.0.1)
 htmltools     0.5.0   2020-06-16 [1] CRAN (R 4.0.1)
 jsonlite      1.7.0   2020-06-25 [1] CRAN (R 4.0.1)
 knitr         1.29    2020-06-23 [1] CRAN (R 4.0.1)
 magrittr      1.5     2014-11-22 [1] CRAN (R 4.0.0)
 rlang         0.4.7   2020-07-09 [1] CRAN (R 4.0.2)
 rmarkdown     2.3     2020-06-18 [1] CRAN (R 4.0.1)
 sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 4.0.1)
 stringi       1.4.6   2020-02-17 [1] CRAN (R 4.0.0)
 stringr       1.4.0   2019-02-10 [1] CRAN (R 4.0.0)
 withr         2.2.0   2020-04-20 [1] CRAN (R 4.0.2)
 xfun          0.15    2020-06-21 [1] CRAN (R 4.0.2)
 yaml          2.2.1   2020-02-01 [1] CRAN (R 4.0.0)

[1] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
```

</details>
