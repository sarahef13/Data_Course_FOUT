library(tidyverse)
library(easystats)
library(palmerpenguins)

names(penguins)

weightBySpecies <- glm(data = penguins, formula = body_mass_g ~ species)
summary(weightBySpecies)
# ^ compares Adele to Chinstrap & Gentoo
# we can see there is a difference based on species

# predict whether a penguin is Gentoo based on body dimensions
mod <- penguins %>% 
  mutate(gentoo = case_when(species == 'Gentoo' ~ TRUE,
                            TRUE ~ FALSE)) %>% 
  glm(data=. , 
      formula = gentoo ~ bill_depth_mm + bill_length_mm + body_mass_g + flipper_length_mm,
      family = 'binomial') # binomial handles either/or cases well; "logistic regression"

check_model(mod)
summary(mod)
predict(mod, penguins) # these are not true/false. it's predicting spots on the S curve
predict(mod, penguins, type = 'response') # these are 0-1, false-true

penguins$pred <- predict(mod, penguins, type = 'response')

penguins %>% 
  ggplot(aes(x=body_mass_g, y=pred, color=species)) +
  geom_point()
# yay! all the trues are indeed Gentoo

# determine how far off our predictions were
predictions <- penguins %>% 
  mutate(gentoo = case_when(species == 'Gentoo' ~ TRUE,
                            TRUE ~ FALSE)) %>% 
  mutate(outcome = case_when(pred < 0.01 ~ FALSE,
                             pred > 0.75 ~ TRUE)) %>% 
  select(species, gentoo, outcome) %>% 
  mutate(correct = case_when(gentoo == outcome ~ TRUE,
                             TRUE ~ FALSE))

predictions %>% 
  pluck('correct') %>% 
  sum() / nrow(predictions)
# 99.42% accuracy!



dat <- read_csv('./Data/GradSchool_Admissions.csv')
str(dat)
unique(dat$admit)

schoolMod <- glm(data = dat, 
                 formula = as.logical(admit) ~ (gre + gpa) * rank,
                 family = 'binomial')
dat$pred <- predict(schoolMod, dat, type = 'response')

dat %>% 
  ggplot(aes(x=gpa, y=pred, color=factor(rank))) + 
  geom_point(alpha = .25) + 
  geom_smooth()

dat %>% 
  ggplot(aes(x=factor(rank), y=pred, color=factor(rank))) + 
  geom_boxplot() +
  geom_jitter(alpha = .25)



