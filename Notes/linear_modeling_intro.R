# SETUP ####
library(tidyverse)
library(readxl)
library(measurements)
library(easystats)

# DATA ####
path <- "./Notes/human_heights.xlsx"
dat <- read_xlsx(path)

# CLEAN ####
dat <- 
dat %>% 
  pivot_longer(everything(),
               names_to = "sex",
               values_to = "height") %>% 
  separate(height, into = c("feet","inches"),convert = TRUE) %>% 
  mutate(inches = (feet*12) + inches) %>% 
  mutate(cm=conv_unit(inches, from='in',to='cm'))

dat %>% 
  ggplot(aes(x=cm,fill=sex)) +
  geom_density(alpha=.5)


# find out if 2 means are different from each other: 
?t.test
t.test(dat$cm ~ factor(dat$sex))
# p-value is inverse measurement of how shocked you'd be to see these values 
# if the null hypothesis were true


mod <- glm(data = dat, formula = cm ~ sex)
summary(mod)
# generalized linear model
# y = 7.466x + 168.256
# average person w/out sex is 168.256 cm
# average male is 168.256 + 7.466 cm
# P male = 0.000129
mod$residuals
# analysis saves other data, beyond what's in the summary
report(mod)
performance(mod)
# god bless easystats for data interpretation
# R^2 says 20.6% of variation is explained by sex
# RMSE says points are on average 7.325 cm away from line
performance::check_model(mod)


mpg
glm(data=mpg, formula= cty ~ displ) %>% 
  summary()

mpg %>% 
  ggplot(aes(x=displ, y=cty)) +
  geom_point() +
  geom_smooth(method='glm')


# generate random numbers that fit a normal distribution
data.frame(A = rnorm(15, mean=0, sd=1), 
           B = rnorm(15, mean=5, sd=1)) %>% 
  pivot_longer(everything()) %>% 
  ggplot(aes(x=value, fill=name)) +
  geom_density()
# increasing sample size better approaches actual distribution





