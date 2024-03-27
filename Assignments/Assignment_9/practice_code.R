library(tidyverse)
library(easystats)

dat <- read_csv('GradSchool_Admissions.csv')
str(dat)
unique(dat$admit)
unique(dat$rank)
?glm

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

