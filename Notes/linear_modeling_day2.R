library(tidyverse)
library(easystats)
library(MASS)

names(mpg)

mod1 <- glm(data = mpg, formula = cty ~ displ)
class(mod1)
mod1$coefficients
mod1$formula # weird class, doesn't convert to character well


mod2a <- glm(data = mpg, formula = cty ~ displ + cyl)
mod2b <- glm(data = mpg, formula = cty ~ displ * cyl)

mpg %>% 
  ggplot(aes(x=displ, y=cty)) +
  geom_smooth(method = 'glm')

mpg %>% 
  ggplot(aes(x=displ, y=cty, color=factor(cyl))) +
  geom_smooth(method = 'glm')
# ^ this shows mod2b; displ * cyl can interact with each other
# the differences in the second x var can affect the slope differently


compare_models(mod1, mod2a, mod2b)
compare_performance(mod1, mod2a, mod2b)
# want higher R2 and lower RMSE
# AIC & BIC show how complex the model is; simpler (lower) is better

compare_performance(mod1, mod2a, mod2b) %>% plot
# mod2b wins every category by far

predict(mod1, mpg)
predict(mod1, data.frame(displ=1:100))
# absolutely ridiculous results
mpg$displ %>% range
# model doesn't know how to predict outside data range

mpg$pred <- predict(mod1, mpg)
mpg$pred2a <- predict(mod2a, mpg)
mpg$pred2b <- predict(mod2b, mpg)

mpg %>% 
  ggplot(aes(x=cty, y=pred)) +
  geom_point()

mpg %>% 
  pivot_longer(starts_with('pred')) %>% 
  ggplot(aes(x=displ, y=cty, color=factor(cyl))) +
  geom_point() +
  geom_point(aes(y=value), color='black') +
  facet_wrap(~name)
# displ + cyl allows for separate lines
# displ * cyl also allows for different slopes


mpg$trans %>% table
# too few of each transmission type to build a good model
mpg <- mpg %>% 
  mutate(auto = grepl('auto', mpg$trans))
# ^ adds true/false column to detect automatic transmission

mod3 <- glm(data = mpg, formula = cty ~ displ * cyl * auto)
compare_performance(mod1, mod2a, mod2b, mod3) %>% plot
compare_models(mod1, mod2a, mod2b, mod3)
# BIC suggests mod3 has unnecessary complexity
summary(mod3)
# cyl * auto interaction isn't helpful, just adds complexity
# we could manually alter the equation to get rid of unhelpful interactions...
# ... but:
step <- stepAIC(mod3)
formula(step)
# it couldn't improve mod3

modTrash <- glm(data=mpg, formula = cty ~ displ * year * cyl * trans * drv * class)
stepTrash <- stepAIC(modTrash)

modBest <- glm(data=mpg, formula = formula(stepTrash))
compare_models(mod1, mod2a, mod2b, mod3, modBest)
compare_performance(mod1, mod2a, mod2b, mod3, modBest) %>% plot

mpg$pred_best <- predict(modBest, mpg)

mpg %>% 
  pivot_longer(starts_with('pred')) %>% 
  ggplot(aes(x=displ, y=cty, color=factor(cyl))) +
  geom_point() +
  geom_point(aes(y=value), color='black') +
  facet_wrap(~name)
# pred_best does align with the data better, BUT it's really hard to interpret



mod5 <- glm(data = mpg, formula = cty ~ poly(displ,2)) # predict as x^2 line, not linear
mpg$pred5 <- predict(mod5, mpg)
compare_performance(mod1, mod2a, mod2b, mod3, modBest, mod5) %>% plot
# now it fits the data well AND is super simple & easy to interpret

check_model(mod5)

