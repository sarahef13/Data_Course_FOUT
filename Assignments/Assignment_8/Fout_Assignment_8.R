library(tidyverse)
library(easystats)

mush <- read_csv('mushroom_growth.csv')

#### GRAPHS ####
# These graphs are ugly, but we're not presenting so it's fine.
# Just playing around with different plot styles.

light_boxes <- mush %>% 
  ggplot(aes(x=Light, y=GrowthRate, group=as.factor(Light))) + 
  geom_boxplot() +
  facet_wrap(~Species)

nitrogen_heatdots <- mush %>% 
  ggplot(aes(x=Nitrogen, y=GrowthRate, color=Species)) + 
  geom_bin2d()

humidity_violins <- mush %>% 
  ggplot(aes(x=Humidity, y=GrowthRate, color=Species)) + 
  geom_violin()

temp_jitter <- mush %>% 
  ggplot(aes(x=Temperature, y=GrowthRate, color=Species)) + 
  geom_jitter()


#### MODELS ####

# I initially made mod1 through mod5, then built more detailed models from there,
# eliminating the poorer models as I progressed.
# The non-commented lines show the progression of the models' improvement.

mod1 <- glm(data = mush, formula = GrowthRate ~ Species * Light)
#mod2 <- glm(data = mush, formula = GrowthRate ~ Species + Light)
#mod3 <- glm(data = mush, formula = GrowthRate ~ Species * Nitrogen)
mod4 <- glm(data = mush, formula = GrowthRate ~ Species * Humidity)
#mod5 <- glm(data = mush, formula = GrowthRate ~ Species * Temperature)
#mod6 <- glm(data = mush, formula = GrowthRate ~ poly(Light,2))
#mod7 <- glm(data = mush, formula = GrowthRate ~ Species * (Humidity + Light))
mod8 <- glm(data = mush, formula = GrowthRate ~ Species * (Humidity + Light + Temperature))
#mod9 <- glm(data = mush, formula = GrowthRate ~ Species*(Humidity+Light+Temperature+Nitrogen))
#mod10 <- glm(data = mush, formula = GrowthRate ~ Species*(Humidity+Light+Nitrogen))
#mod11 <- glm(data = mush, formula = GrowthRate ~ Species * Light * Humidity)
mod12 <- glm(data = mush, formula = GrowthRate ~ Species * Light * Humidity * Temperature)
#mod13 <- glm(data = mush, formula = GrowthRate ~ Species*Light*Humidity*Temperature + Nitrogen)


#### MEAN SQUARES ####

mean(mod1$residuals^2)
#mean(mod2$residuals^2)
#mean(mod3$residuals^2)
mean(mod4$residuals^2)
#mean(mod5$residuals^2)
#mean(mod6$residuals^2)
#mean(mod7$residuals^2)
mean(mod8$residuals^2)
#mean(mod9$residuals^2)
#mean(mod10$residuals^2)
#mean(mod11$residuals^2)
mean(mod12$residuals^2)
#mean(mod13$residuals^2)

#plot(compare_performance(mod1, mod2, mod3, mod4, mod5))
plot(compare_performance(mod1, mod4, mod8, mod12))

# The best model here is mod12.


#### PREDICTIONS ####

# Make a copy of the original df:
mush_pred <- mush

# Show the actual data results in the original df:
mush$ResultType = 'Actual Data'
mush$Result = mush$GrowthRate

# Show the predicted results based on actual conditions in the df copy:
mush_pred$ResultType = 'Actual Prediction'
mush_pred$Result = predict(mod12, mush_pred)

# Make a new df of hypothetical conditions:
# (higher light values and more extreme temperatures)
mush_hyp = data.frame(Species = c("P.ostreotus", "P.ostreotus", "P.ostreotus", "P.ostreotus", "P.ostreotus", "P.ostreotus", "P.ostreotus", "P.ostreotus", "P.cornucopiae", "P.cornucopiae", "P.cornucopiae", "P.cornucopiae", "P.cornucopiae", "P.cornucopiae", "P.cornucopiae", "P.cornucopiae"))
mush_hyp$Light <- c(30, 30, 30, 30, 40, 40, 40, 40, 30, 30, 30, 30, 40, 40, 40, 40)
mush_hyp$Humidity <- c('Low', 'Low', 'High', 'High', 'Low', 'Low', 'High', 'High', 'Low', 'Low', 'High', 'High', 'Low', 'Low', 'High', 'High')
mush_hyp$Temperature <- c(15, 35, 15, 35, 15, 35, 15, 35, 15, 35, 15, 35, 15, 35, 15, 35)

# Show the predicted results based on hypothetical conditions in the new df:
mush_hyp$ResultType = 'Hypothetical Prediction'
mush_hyp$Result <- predict(mod12, mush_hyp)

# Put the three dfs together:
mush_all <- full_join(mush, mush_pred)
mush_all <- full_join(mush_all, mush_hyp)

# Plot the result differences:
mush_all %>% 
  ggplot(aes(x=Temperature, y=Result, group=as.factor(Temperature))) +
  geom_boxplot() +
  facet_wrap(~ResultType) +
  ylab('Growth Rate')


#### NON LINEAR RELATIONSHIP MODEL ####  

nonlin <- read_csv('non_linear_relationship.csv')
nonlin_mod <- lm(data = nonlin, formula = response ~ poly(predictor, 3))

nonlin$pred <- predict(nonlin_mod, nonlin)

nonlin_pred_plot <- nonlin %>% 
  ggplot(aes(x=predictor)) +
  geom_point(aes(y=response)) +
  geom_point(aes(y=pred), color='purple')

