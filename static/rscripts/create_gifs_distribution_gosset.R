#### generate t- distribution
# Generate data for distribution with different degrees of freedom: v's
# 
library(tidyverse)
library(gganimate)
v_values <- c(1,2,3,4,5,6,7, 8, 16, 32, 64, 128)
n_datapoints <- 4000
get_random_t <- function(df){
  rt(n=1, df=df)
}
set.seed(23567)
distributions <- 
  tibble(group = rep(v_values, n_datapoints)) %>% 
  mutate(
    values = purrr::map_dbl(group, get_random_t),
    label = as_factor(group)
    )

ggplot(distributions, aes(x= values, color = label))+
  geom_density()+
  scale_x_continuous(limits = c(-10,10))+
  transition_states(label)+
  shadow_mark(colour = "grey")+
  labs(title = "t-distribution with df={closest_state}")+
  NULL


ggplot(distributions, aes(x= values, color = label))+
  geom_density()+
  scale_x_continuous(limits = c(-1,5))+
  transition_states(label)+
  shadow_mark(colour = "grey")+
  labs(title = "t-distribution with df={closest_state}", caption = "Look at those tails!")+
  NULL
