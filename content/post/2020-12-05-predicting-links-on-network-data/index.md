---
title: "Predicting links for network data"
author: Roel M. Hogervorst
date: '2020-11-27'
categories:
  - blog
  - R
tags:
  - data:fb-pages-food
  - intermediate
  - networkdata
  - tidymodels
  - dplyr
  - recipes
  - interactions
  - glmnet
  - ranger
  - tune
  - parsnip
  - ggplot2
  - themis
  - vip
subtitle: ""
share_img: 'https://media1.tenor.com/images/cb27704982766b4f02691ea975d9a259/tenor.gif?itemid=11365139'
output: 
  html_document:
    keep_md: true
---

<!-- useful settings for rmarkdown-->



<!-- content --> 

NETWORKS, PREDICT EDGES
> Can we predict if two nodes in the graph are connected or not?

But let's make it very practical:

Let's say you work in a social media company and your boss asks you to create
a model to predict who will be friends, so you can feed those recommendations 
back to the website and serve those to users. 

You are tasked to create a model that predicts, once a day for all users, who is likely to connect to whom. 


PART 2 [my previous post about rectangling network data](https://blog.rmhogervorst.nl/blog/2020/11/25/rectangling-social-network-data/)

BUILD MODEL WITH TIDYMODELS



# Loading packages and data
Using [{tidymodels}](https://cran.r-project.org/package=tidymodels) (a meta package that also loads {broom}, {recipes}, {dials}, {rsample}, {dplyr}, {tibble}, {ggplot2}, {tidyr}, {infer}, {tune}, {workflows}, {modeldata}, {parsnip}, {yardstick}, and {purrr})

also using [{themis}](https://CRAN.R-project.org/package=themis), [{vip}](https://CRAN.R-project.org/package=vip) [{readr}](https://CRAN.R-project.org/package=readr), [{dplyr}](https://CRAN.R-project.org/package=dplyr), [{ggplot2}](https://CRAN.R-project.org/package=ggplot2), for models
using [{glmnet}](https://CRAN.R-project.org/package=glmnet), [{ranger}](https://CRAN.R-project.org/package=ranger)


```r 
library(tidymodels)
```

```
── Attaching packages ───────────────────────────────────── tidymodels 0.1.2 ──
```

```
✓ broom     0.7.2      ✓ recipes   0.1.15
✓ dials     0.0.9      ✓ rsample   0.0.8 
✓ dplyr     1.0.2      ✓ tibble    3.0.4 
✓ ggplot2   3.3.2      ✓ tidyr     1.1.2 
✓ infer     0.5.3      ✓ tune      0.1.2 
✓ modeldata 0.1.0      ✓ workflows 0.2.1 
✓ parsnip   0.1.4      ✓ yardstick 0.0.7 
✓ purrr     0.3.4      
```

```
── Conflicts ──────────────────────────────────────── tidymodels_conflicts() ──
x purrr::discard() masks scales::discard()
x dplyr::filter()  masks stats::filter()
x dplyr::lag()     masks stats::lag()
x recipes::step()  masks stats::step()
```

Load data 
CONTAINS ALSO FROM ADVANCED THINGY

```r 
enriched_trainingset <- 
  readr::read_rds(file="data/enriched_trainingset2.Rds") %>% 
  mutate(target=as.factor(target))
names(enriched_trainingset)
```

```
 [1] "from"              "to"                "target"           
 [4] "degree"            "betweenness"       "pg_rank"          
 [7] "eigen"             "closeness"         "br_score"         
[10] "coreness"          "degree_to"         "betweenness_to"   
[13] "pg_rank_to"        "eigen_to"          "closeness_to"     
[16] "br_score_to"       "coreness_to"       "commonneighbors_1"
[19] "commonneighbors_2" "unique_neighbors" 
```

# Feature information
IS THERE ENOUGH INFORMATION IN THE DATASET TO PREDICT 






MANY MORE NEGATIVE THAN POSITIVE EXAMPLES.
```r 
enriched_trainingset %>% 
  count(target)
```

```
# A tibble: 2 x 2
  target     n
  <fct>  <int>
1 0      34306
2 1       1606
```

MAKE SUBSET TO VISUALISE 


```r 
smpl_trainingset <- 
  enriched_trainingset %>% 
  group_by(target) %>% 
  sample_n(1000) %>% 
  mutate(label = ifelse(target ==1,"link","no-link")) %>% 
  ungroup()
smpl_trainingset %>% count(label)
```

```
# A tibble: 2 x 2
  label       n
  <chr>   <int>
1 link     1000
2 no-link  1000
```


OVERVIERW OF ALL VARIABLES
THIS IS NOT A BEST PRACTICE, AND I'M NOT EVEN SURE IF THE INFORMATION
I'M SHOWING HERE IS TELLING US SOMETHING. 

`(NODE)-[EDGE]-(NODE)` 
BOTH SIDES OF EDGE HAVE PROPERTIES. WE DON'T CARE ABOUT DIRECTION AND SO
IS MORE OR LESS EQUIVALIENT. MAYBE THE COMBIANTOIN OF THE TWO IS MORE IMPORTANT?


```r 
smpl_trainingset %>% 
  mutate(
    degree2 = degree*degree_to,
    eigen2 = eigen* eigen_to,
    pg_rank2 = pg_rank* pg_rank_to,
    betweenness2 = betweenness* betweenness_to,
    br_score2 = br_score* br_score_to,
    coreness2 = coreness * coreness_to,
    closeness2 = closeness * closeness_to
    ) %>% 
  select(label, degree2:closeness2) %>% 
  group_by(label) %>% 
  summarise(across(.fns = c(mean=mean,sd=sd))) %>% 
  pivot_longer(-label) %>% 
  tidyr::separate(name, into = c("metric","summary"),sep="2_") %>% 
  pivot_wider(names_from = summary, values_from = value) %>% 
  ggplot(aes(label, color=label))+
  geom_point(aes(label, y=mean),shape=22, fill="grey50")+
  geom_point(aes(label, y=mean+sd), shape=2)+
  geom_point(aes(label, y=mean-sd), shape=6)+
  geom_linerange(aes(label, ymin=mean-sd, ymax=mean+sd))+
  facet_wrap(~metric, scales="free")+
  labs(
    title="Small differences in features for link vs no-link", 
    subtitle="mean (+/-) 1 sd",
    x=NULL, y="feature"
  )
```

```
`summarise()` ungrouping output (override with `.groups` argument)
```

{{<figure src="unnamed-chunk-5-1.png" >}}


VISUALIZE 

BETWEENNESS

```r 
smpl_trainingset %>% 
  select(betweenness, betweenness_to, label) %>% 
  pivot_longer(-label) %>% 
  ggplot(aes(value,color = label))+
  geom_density() + 
  facet_wrap(~name)+
  scale_x_continuous(trans=scales::log1p_trans())
```
{{<figure src="unnamed-chunk-6-1.png" >}}

DEGREE

```r 
smpl_trainingset %>% 
  ggplot(aes(degree, degree_to, color = label))+
  geom_point()+
  scale_x_continuous(trans=scales::log1p_trans())+
  scale_y_continuous(trans=scales::log1p_trans())
```
{{<figure src="unnamed-chunk-7-1.png" >}}

PAGE RANK

```r 
smpl_trainingset %>% 
  ggplot(aes(pg_rank, pg_rank_to, color = label))+
  geom_point(alpha = 1/2)
```
{{<figure src="unnamed-chunk-8-1.png" >}}

EIGEN DOESN'T REALLY SEEM TO BE DIFFERENT

```r 
smpl_trainingset %>% 
  ggplot(aes(eigen, eigen_to, color = label))+
  geom_point(alpha = 1/2)
```
{{<figure src="unnamed-chunk-9-1.png" >}}

ETCETEA

ADVANCED 
```r 
smpl_trainingset %>% 
  ggplot(aes(commonneighbors_1, commonneighbors_2, color=label))+
  geom_point(alpha=1/2)+
  labs(
    title="Neighbors in common between two nodes",
    x="Neighbors at distance 1",
    y= "Neighbors at distance 2"
  )
```
{{<figure src="unnamed-chunk-10-1.png" >}}

SO YEAH THERE IS SOME INFOMRATION IN THERE, IS SEE SOME CLUSTERING BUT THE BOUNDARIES
ARE QUITE VAGUE. 

# Actual feature engineering (recipe)
I decided to create some interactions
between page rank of two nodes, and the degree of the nodes, drop the identifiers
to and from and make the target a factor. Furthermore I drop correlated features
and normalize and center all features (there are no nominal variables in this
dataset).

_This recipe is only a plan of action, nothing has happened yet._

```r 
# make it very simple first.
ntwrk_recipe <-
  recipe(enriched_trainingset,formula = target~.) %>% 
  recipes::update_role(to, new_role = "other") %>% 
  recipes::update_role(from, new_role = "other") %>% 
  step_interact(terms = ~ pg_rank:pg_rank_to) %>% 
  step_interact(terms = ~ degree:degree_to) %>% 
  step_interact(terms = ~ eigen:eigen_to) %>% 
  step_interact(terms = ~ betweenness:betweenness_to) %>% 
  step_interact(terms = ~ closeness:closeness_to) %>% 
  step_interact(terms = ~ coreness:coreness_to) %>% 
  step_interact(terms = ~ br_score:br_score_to) %>% 
  step_corr(all_numeric()) %>% 
  step_nzv(all_predictors()) %>% 
  step_normalize(all_predictors(), -all_nominal()) %>% 
  step_mutate(target = as.factor(target))
```


## Model
simple model to start with generalized linear model

So what are we going to do with the model? I'm using a logistic regression 
from [{glmnet}](https://cran.r-project.org/package=glmnet) and capture the steps
of data preparation and modeling into 1 workflow-object.

```r 
ntwrk_spec <- 
  logistic_reg(penalty = tune(), mixture = 1) %>% # pure lasso
  set_engine("glmnet")

ntwrk_workflow <- 
  workflow() %>% 
  add_recipe(ntwrk_recipe) %>% 
  add_model(ntwrk_spec) 
```

## Train and test sets

I split the data into a test and train set, but making sure the proportion
of targets is the same in test and train data.
```r 
### split into training and test set
set.seed(2345)
tr_te_split <- initial_split(enriched_trainingset,strata = target)
val_set <- validation_split(training(tr_te_split),strata = target, prop = .8)
```

## Model tuning
I don't know what the best penalty is for this model and data, so we have
to test different versions and choose the best one.

```r 
## Setting up tune grid manually, because it is just one column
lr_reg_grid <- tibble(penalty = 10^seq(-5, -1, length.out = 30))
```


```r 
ntwrk_res <-
  ntwrk_workflow %>% 
  tune_grid(val_set,
            grid = lr_reg_grid,
            control = control_grid(save_pred = TRUE),
            metrics = metric_set(roc_auc))
```

```

Attaching package: 'rlang'
```

```
The following objects are masked from 'package:purrr':

    %@%, as_function, flatten, flatten_chr, flatten_dbl, flatten_int,
    flatten_lgl, flatten_raw, invoke, list_along, modify, prepend,
    splice
```

```

Attaching package: 'vctrs'
```

```
The following object is masked from 'package:tibble':

    data_frame
```

```
The following object is masked from 'package:dplyr':

    data_frame
```

```
Loading required package: Matrix
```

```

Attaching package: 'Matrix'
```

```
The following objects are masked from 'package:tidyr':

    expand, pack, unpack
```

```
Loaded glmnet 4.0-2
```

Visualise results 
(I DID SOME DEEPER DIVE ANY SMALL PENALTY LESS THAN 10E-05 LEADS TO THE SAME
VALUES ~ 0.0000240 as pentlay is boundary)

```r 
ntwrk_res %>% 
  collect_metrics() %>% 
  ggplot(aes(x = penalty, y = mean)) + 
  geom_point() + 
  geom_line() + 
  labs(
    subtitle="Ideal penalty is larger then 1.610e-05, but certainly less than 0.04",
    title = "Penalty values",
    y= "Area under the ROC Curve",
    x="Penalty values for this GLM"
    ) +
  scale_x_log10(labels = scales::label_number())+
  geom_vline(xintercept = 0.0386, color="tomato3")+
  geom_vline(xintercept=1.610e-05, color='tomato3')+
  theme_minimal()
```
{{<figure src="unnamed-chunk-16-1.png" >}}

What are the best models?

```r 
## show best models
top_models <-
  ntwrk_res %>% 
  show_best("roc_auc", n = 5) %>% 
  arrange(penalty)
lr_best <- 
  ntwrk_res %>% 
  collect_metrics() %>% 
  arrange(penalty) %>% 
  slice(5)

pred_auc <- 
  ntwrk_res %>% 
  collect_predictions(parameters = lr_best) %>% 
  roc_curve(target, .pred_0) %>% 
  mutate(model = "Logistic Regression")

autoplot(pred_auc)+ 
  ggtitle("ROC curve of GLM")
```
{{<figure src="unnamed-chunk-17-1.png" >}}

Let's use the best performing model and modify the current workflow,
by replacing the penalty value in the model with one of the best values.

(this model is still untrained, we used the crossvalidation to find the best parameter values)

```r 
best_penalty <- top_models %>% pull(penalty) %>% .[[3]]
ntwrk_spec_1 <- 
  logistic_reg(penalty = best_penalty, mixture = 1) %>% 
  set_engine("glmnet")

## change model
updated_workflow <- 
  ntwrk_workflow %>% 
  update_model(ntwrk_spec_1)
```

Last fit is a special function from tune that fits data on the training set
and predicts on the testset.

```r 
ntwrk_fit <- 
  updated_workflow %>% 
  last_fit(tr_te_split)

ntwrk_fit %>% pull(.metrics) 
```

```
[[1]]
# A tibble: 2 x 4
  .metric  .estimator .estimate .config             
  <chr>    <chr>          <dbl> <chr>               
1 accuracy binary         0.957 Preprocessor1_Model1
2 roc_auc  binary         0.821 Preprocessor1_Model1
```

Performs really well! 

Unpacking predictions. We never predicted a link when there was one!
So the score looks good, but the results are not that useful.

```r 
ntwrk_fit$.predictions[[1]] %>% 
  group_by(target, .pred_class) %>% 
  summarize(
    count = n(),
    avg_prob1 = mean(.pred_1)
  )
```

```
`summarise()` regrouping output by 'target' (override with `.groups` argument)
```

```
# A tibble: 3 x 4
# Groups:   target [2]
  target .pred_class count avg_prob1
  <fct>  <fct>       <int>     <dbl>
1 0      0            8591    0.0417
2 0      1               4    0.690 
3 1      0             383    0.129 
```

```r 
library(vip)
```

```

Attaching package: 'vip'
```

```
The following object is masked from 'package:utils':

    vi
```

```r 
prediction_model_glm <- fit(
  ntwrk_fit$.workflow[[1]], 
  enriched_trainingset
  )
prediction_model_glm %>% 
  pull_workflow_fit() %>% 
  vip(geom="point")+
  ggtitle("Variable importance of Generalized Linear Model", subtitle = "Top 10")
```
{{<figure src="variable importance glm-1.png" >}}


## Undersampling for better performance.
PROBABLY SHOULD GIVE SOME REASON FOR THIS. GLM DOESN'T REALLY CARE



### using undersampling.

using only mixture doesn't really help
using undersampling doesn't really help either.

```r 
ntwrk_recipe_undersample <- 
  ntwrk_recipe %>%  
  themis::step_downsample(target,under_ratio = 1.5)
```

```
Registered S3 methods overwritten by 'themis':
  method                  from   
  bake.step_downsample    recipes
  bake.step_upsample      recipes
  prep.step_downsample    recipes
  prep.step_upsample      recipes
  tidy.step_downsample    recipes
  tidy.step_upsample      recipes
  tunable.step_downsample recipes
  tunable.step_upsample   recipes
```

```r 
# ntwrk_spec2 <- 
#   logistic_reg(penalty = tune(), mixture = tune()) %>% 
#   set_engine("glmnet")

ntwrk_workflow2 <- 
  ntwrk_workflow %>% 
  update_recipe(ntwrk_recipe_undersample)

crossvalidation_sets <- vfold_cv(training(tr_te_split),v = 3, strata = target)
all_cores <- parallel::detectCores(logical = TRUE)-1

library(doParallel)
```

```
Loading required package: foreach
```

```

Attaching package: 'foreach'
```

```
The following objects are masked from 'package:purrr':

    accumulate, when
```

```
Loading required package: iterators
```

```
Loading required package: parallel
```

```r 
cl <- makePSOCKcluster(all_cores)
registerDoParallel(cl)
```


HEAVIY COMPUTATION HERE

```r 
ntwrk_res2 <-
  ntwrk_workflow2 %>% 
  tune_grid(crossvalidation_sets,
            grid = lr_reg_grid,
            control = control_grid(save_pred = TRUE, allow_par = TRUE),
            metrics = metric_set(roc_auc))
```


```r 
ntwrk_res2 %>% 
  collect_metrics() %>%
  select(mean, penalty) %>%
  pivot_longer(penalty,
               values_to = "value",
               names_to = "parameter"
  ) %>%
  ggplot(aes(value, mean, color = parameter)) +
  geom_point(alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~parameter, scales = "free_x") +
  geom_hline(yintercept = 0.8206, color="tomato3")+
  labs(x = NULL, y = "AUC")
```
{{<figure src="unnamed-chunk-22-1.png" >}}

Performance equivalent to earlier. (logically, because glm takes care of it?)

OVERLAY ON PREVIOUS DATA?


# Let's try with random forest.

```r 
rf_recipe <- ntwrk_recipe 

rf_spec <- 
  rand_forest(mtry = tune(), min_n = tune(), trees = 1000) %>% 
  set_mode("classification") %>% 
  set_engine("ranger",importance="impurity") 

rf_workflow <- 
  workflow() %>% 
  add_recipe(rf_recipe) %>% 
  add_model(rf_spec)
```


```r 
set.seed(88708)
rf_grid <- 
  grid_max_entropy(
    mtry(range = c(3,15)),
    min_n(),
    size = 15)

rf_tune <-
  tune_grid(rf_workflow, 
            resamples = crossvalidation_sets, 
            grid = rf_grid,
            control = control_grid(save_pred = TRUE,allow_par = TRUE),
            metrics = metric_set(roc_auc))
```


So what is the best parameter set?


```r 
rf_tune %>% 
  collect_metrics() %>%
  select(mean, mtry:min_n) %>%
  pivot_longer(mtry:min_n,
               values_to = "value",
               names_to = "parameter"
  ) %>%
  ggplot(aes(value, mean, color = parameter)) +
  geom_point(alpha = 0.8, show.legend = FALSE) +
  geom_hline(yintercept = 0.8206, color="tomato3")+
  facet_wrap(~parameter, scales = "free_x") +
  labs(
    x = NULL, y = "AUC",
    title="Random Forest approach is way better",
    subtitle="Quite some variation, but always better than glm (red line)"
       )
```
{{<figure src="unnamed-chunk-24-1.png" >}}



```r 
top_models_rf <-
  rf_tune %>% 
  show_best("roc_auc", n = 5)
rf_best <- 
  rf_tune %>% 
  collect_metrics() %>% 
  arrange(mtry) %>% 
  slice(5)

pred_auc_rf <- 
  rf_tune %>% 
  collect_predictions(parameters = rf_best) %>% 
  roc_curve(target, .pred_0) %>% 
  mutate(model = "Random Forest")
```

overlay both models

```r 
bind_rows(
  pred_auc_rf,
  pred_auc
) %>% 
  ggplot(
    aes(
    x = 1 - specificity, 
    y = sensitivity, 
    color = model)
    )+
  geom_line()+
  geom_abline(
    lty = 2, alpha = 0.5,
    color = "gray50",
    size = 1.2
  )+
  theme_minimal()+
  labs(title="Overall better performance in the Random Forest model")
```
{{<figure src="unnamed-chunk-26-1.png" >}}
Use the best model to make a final prediction

```r 
best_auc_rf <- select_best(rf_tune, "roc_auc")
final_workflow_rf <- finalize_workflow(
    rf_workflow,
    best_auc_rf
)
final_res_rf <- last_fit(final_workflow_rf, tr_te_split)
collect_metrics(final_res_rf)
```

```
# A tibble: 2 x 4
  .metric  .estimator .estimate .config             
  <chr>    <chr>          <dbl> <chr>               
1 accuracy binary         0.969 Preprocessor1_Model1
2 roc_auc  binary         0.926 Preprocessor1_Model1
```
Compare this area under the ROC curve (0.91) with the previous value 0.8206.


Investigate feature importance.

```r 
library(vip)
prediction_model2 <- fit(
  final_res_rf$.workflow[[1]], 
  enriched_trainingset
  )
prediction_model2 %>% 
  pull_workflow_fit() %>% 
  vip(geom="point")+
  ggtitle("Variable importance of Random Forest model", subtitle = "Top 10")
```
{{<figure src="variable importance rf model-1.png" >}}

# Conclusion

So the random forest model was better in predicting links than a GLM model. 
But you should always wonder, what good enough is. Maybe a score of over .80 is
enough? In that case why bother using a more complicated model that takes
longer to run? GLM's are usually easier explained and run faster. Provided 
that we are predicting both classes. 

I started this project with the question:

> Can we predict if two nodes in the graph are connected or not?

And the practical task  was actually:

your boss asks you to create
a model to predict who will be friends, so you can feed those recommendations 
back to the website and serve those to users. 

You are tasked to create a model that predicts, once a day for all users, who is likely to connect to whom. 

The stakes in this case are not that high. False positives (I predict a link
but there is none) is preferable to false negatives (predict no link , but there 
is).


### Bringing it to production

* use renv to capture the dependencies
* set up pipeline of data from system to dataset
* see if you can minimize the number of features necessary
* checks on data quality and features
* predict all no connections and check if flow from model to website works
* predict actual data
* keep track of metrics
* retrain when problematic


### State of the machine
<details>
<summary> At the moment of creation (when I knitted this document ) this was the state of my machine: **click here to expand** </summary>

```r 
sessioninfo::session_info()
```

```
─ Session info ──────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 4.0.2 (2020-06-22)
 os       macOS Catalina 10.15.7      
 system   x86_64, darwin17.0          
 ui       RStudio                     
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       Europe/Amsterdam            
 date     2020-11-25                  

─ Packages ──────────────────────────────────────────────────────────────────
 package      * version    date       lib source        
 assertthat     0.2.1      2019-03-21 [1] CRAN (R 4.0.2)
 backports      1.2.0      2020-11-02 [1] CRAN (R 4.0.2)
 BBmisc         1.11       2017-03-10 [1] CRAN (R 4.0.2)
 blogdown       0.21       2020-10-11 [1] CRAN (R 4.0.2)
 bookdown       0.21       2020-10-13 [1] CRAN (R 4.0.2)
 broom        * 0.7.2      2020-10-20 [1] CRAN (R 4.0.2)
 checkmate      2.0.0      2020-02-06 [1] CRAN (R 4.0.2)
 class          7.3-17     2020-04-26 [1] CRAN (R 4.0.2)
 cli            2.2.0      2020-11-20 [1] CRAN (R 4.0.2)
 codetools      0.2-18     2020-11-04 [1] CRAN (R 4.0.2)
 colorspace     2.0-0      2020-11-11 [1] CRAN (R 4.0.2)
 crayon         1.3.4      2017-09-16 [1] CRAN (R 4.0.2)
 data.table     1.13.2     2020-10-19 [1] CRAN (R 4.0.2)
 dials        * 0.0.9      2020-09-16 [1] CRAN (R 4.0.2)
 DiceDesign     1.8-1      2019-07-31 [1] CRAN (R 4.0.2)
 digest         0.6.27     2020-10-24 [1] CRAN (R 4.0.2)
 doParallel   * 1.0.16     2020-10-16 [1] CRAN (R 4.0.2)
 dplyr        * 1.0.2      2020-08-18 [1] CRAN (R 4.0.2)
 ellipsis       0.3.1      2020-05-15 [1] CRAN (R 4.0.2)
 evaluate       0.14       2019-05-28 [1] CRAN (R 4.0.1)
 fansi          0.4.1      2020-01-08 [1] CRAN (R 4.0.2)
 farver         2.0.3      2020-01-16 [1] CRAN (R 4.0.2)
 fastmatch      1.1-0      2017-01-28 [1] CRAN (R 4.0.2)
 FNN            1.1.3      2019-02-15 [1] CRAN (R 4.0.2)
 foreach      * 1.5.1      2020-10-15 [1] CRAN (R 4.0.2)
 furrr          0.2.1      2020-10-21 [1] CRAN (R 4.0.2)
 future         1.20.1     2020-11-03 [1] CRAN (R 4.0.2)
 generics       0.1.0      2020-10-31 [1] CRAN (R 4.0.2)
 ggplot2      * 3.3.2      2020-06-19 [1] CRAN (R 4.0.2)
 glmnet       * 4.0-2      2020-06-16 [1] CRAN (R 4.0.2)
 globals        0.14.0     2020-11-22 [1] CRAN (R 4.0.2)
 glue           1.4.2      2020-08-27 [1] CRAN (R 4.0.2)
 gower          0.2.2      2020-06-23 [1] CRAN (R 4.0.2)
 GPfit          1.0-8      2019-02-08 [1] CRAN (R 4.0.2)
 gridExtra      2.3        2017-09-09 [1] CRAN (R 4.0.2)
 gtable         0.3.0      2019-03-25 [1] CRAN (R 4.0.2)
 hardhat        0.1.5      2020-11-09 [1] CRAN (R 4.0.2)
 hms            0.5.3      2020-01-08 [1] CRAN (R 4.0.2)
 htmltools      0.5.0      2020-06-16 [1] CRAN (R 4.0.2)
 httpuv         1.5.4      2020-06-06 [1] CRAN (R 4.0.2)
 infer        * 0.5.3      2020-07-14 [1] CRAN (R 4.0.2)
 ipred          0.9-9      2019-04-28 [1] CRAN (R 4.0.2)
 iterators    * 1.0.13     2020-10-15 [1] CRAN (R 4.0.2)
 jsonlite       1.7.1      2020-09-07 [1] CRAN (R 4.0.2)
 knitr          1.30       2020-09-22 [1] CRAN (R 4.0.2)
 labeling       0.4.2      2020-10-20 [1] CRAN (R 4.0.2)
 later          1.1.0.1    2020-06-05 [1] CRAN (R 4.0.2)
 lattice        0.20-41    2020-04-02 [1] CRAN (R 4.0.2)
 lava           1.6.8.1    2020-11-04 [1] CRAN (R 4.0.2)
 lhs            1.1.1      2020-10-05 [1] CRAN (R 4.0.2)
 lifecycle      0.2.0      2020-03-06 [1] CRAN (R 4.0.2)
 listenv        0.8.0      2019-12-05 [1] CRAN (R 4.0.2)
 lubridate      1.7.9.2    2020-11-13 [1] CRAN (R 4.0.2)
 magrittr       2.0.1      2020-11-17 [1] CRAN (R 4.0.2)
 MASS           7.3-53     2020-09-09 [1] CRAN (R 4.0.2)
 Matrix       * 1.2-18     2019-11-27 [1] CRAN (R 4.0.2)
 mlr            2.18.0     2020-10-05 [1] CRAN (R 4.0.2)
 modeldata    * 0.1.0      2020-10-22 [1] CRAN (R 4.0.2)
 munsell        0.5.0      2018-06-12 [1] CRAN (R 4.0.2)
 nnet           7.3-14     2020-04-26 [1] CRAN (R 4.0.2)
 parallelly     1.21.0     2020-10-27 [1] CRAN (R 4.0.2)
 parallelMap    1.5.0      2020-03-26 [1] CRAN (R 4.0.2)
 ParamHelpers   1.14       2020-03-24 [1] CRAN (R 4.0.2)
 parsnip      * 0.1.4      2020-10-27 [1] CRAN (R 4.0.2)
 pillar         1.4.7      2020-11-20 [1] CRAN (R 4.0.2)
 pkgconfig      2.0.3      2019-09-22 [1] CRAN (R 4.0.2)
 plyr           1.8.6      2020-03-03 [1] CRAN (R 4.0.2)
 pROC           1.16.2     2020-03-19 [1] CRAN (R 4.0.2)
 processx       3.4.4      2020-09-03 [1] CRAN (R 4.0.2)
 prodlim        2019.11.13 2019-11-17 [1] CRAN (R 4.0.2)
 promises       1.1.1      2020-06-09 [1] CRAN (R 4.0.2)
 ps             1.4.0      2020-10-07 [1] CRAN (R 4.0.2)
 purrr        * 0.3.4      2020-04-17 [1] CRAN (R 4.0.2)
 R6             2.5.0      2020-10-28 [1] CRAN (R 4.0.2)
 ranger         0.12.1     2020-01-10 [1] CRAN (R 4.0.2)
 RANN           2.6.1      2019-01-08 [1] CRAN (R 4.0.2)
 Rcpp           1.0.5      2020-07-06 [1] CRAN (R 4.0.2)
 readr          1.4.0      2020-10-05 [1] CRAN (R 4.0.2)
 recipes      * 0.1.15     2020-11-11 [1] CRAN (R 4.0.2)
 rlang        * 0.4.8      2020-10-08 [1] CRAN (R 4.0.2)
 rmarkdown      2.5        2020-10-21 [1] CRAN (R 4.0.2)
 ROSE           0.0-3      2014-07-15 [1] CRAN (R 4.0.2)
 rpart          4.1-15     2019-04-12 [1] CRAN (R 4.0.2)
 rsample      * 0.0.8      2020-09-23 [1] CRAN (R 4.0.2)
 rstudioapi     0.13       2020-11-12 [1] CRAN (R 4.0.2)
 scales       * 1.1.1      2020-05-11 [1] CRAN (R 4.0.2)
 servr          0.20       2020-10-19 [1] CRAN (R 4.0.2)
 sessioninfo    1.1.1      2018-11-05 [1] CRAN (R 4.0.2)
 shape          1.4.5      2020-09-13 [1] CRAN (R 4.0.2)
 stringi        1.5.3      2020-09-09 [1] CRAN (R 4.0.2)
 stringr        1.4.0      2019-02-10 [1] CRAN (R 4.0.2)
 survival       3.2-7      2020-09-28 [1] CRAN (R 4.0.2)
 themis         0.1.3      2020-11-12 [1] CRAN (R 4.0.2)
 tibble       * 3.0.4      2020-10-12 [1] CRAN (R 4.0.2)
 tidymodels   * 0.1.2      2020-11-22 [1] CRAN (R 4.0.2)
 tidyr        * 1.1.2      2020-08-27 [1] CRAN (R 4.0.2)
 tidyselect     1.1.0      2020-05-11 [1] CRAN (R 4.0.2)
 timeDate       3043.102   2018-02-21 [1] CRAN (R 4.0.2)
 tune         * 0.1.2      2020-11-17 [1] CRAN (R 4.0.2)
 unbalanced     2.0        2015-06-26 [1] CRAN (R 4.0.2)
 utf8           1.1.4      2018-05-24 [1] CRAN (R 4.0.2)
 vctrs        * 0.3.5      2020-11-17 [1] CRAN (R 4.0.2)
 vip          * 0.2.2      2020-04-06 [1] CRAN (R 4.0.2)
 withr          2.3.0      2020-09-22 [1] CRAN (R 4.0.2)
 workflows    * 0.2.1      2020-10-08 [1] CRAN (R 4.0.2)
 xfun           0.19       2020-10-30 [1] CRAN (R 4.0.2)
 yaml           2.2.1      2020-02-01 [1] CRAN (R 4.0.2)
 yardstick    * 0.0.7      2020-07-13 [1] CRAN (R 4.0.2)

[1] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
```

</details>


### Notes
* used this example from Julia Silge as template <https://juliasilge.com/blog/xgboost-tune-volleyball/>
