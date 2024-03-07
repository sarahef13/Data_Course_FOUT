library(pdftools)
pdftools::pdf_combine()
pdftools::pdf_text()


library(caret)
library(broom)
library(modelr)
library(kableExtra)
library(tidyverse)

mod1 <- mpg %>% 
  glm(data=.,
      formula = cty ~ displ + drv + manufacturer)

summary(mod1)
broom::tidy(mod1) %>%  # makes results programmatically accessible
  kableExtra::kable() %>% 
  kableExtra::kable_classic(lightable_options = 'hover')

modelr::add_predictions(mpg, mod1) %>% 
  ggplot(aes(x=pred, y=cty)) +
  geom_point()

modelr::add_residuals(mpg, mod1) %>% 
  ggplot(aes(x=resid, y=cty)) +
  geom_point()


# Cross-Validation:
# test your model on new data, that it wasn't trained on
# i.e., subset your original data into training & testing groups

train_rownums <- caret::createDataPartition(mpg$cty, p=.8, list=FALSE) 
# ^ trains to predict cty mpg, based on 80% of data, selected to have some of each group
train_group <- mpg[train_rownums,]
test_group <- mpg[-train_rownums,]

# make predictions and test the model:
mod2 <- glm(data = train_group,
            formula = mod1$formula)

add_predictions(test_group, mod2) %>% 
  mutate(error = abs(pred - cty)) %>% 
  pluck("error") %>% 
  summary()
# ^ going to be worse than mod1 training & testing on the same data set, but more realistic
# use mod1 if you're given new data later, because it's been trained on more
# use mod2 just to get error estimate of mod1



library(vegan)
names(iris)
unique(iris$Species)
iris %>% 
  ggplot(aes(x=Sepal.Length, y=Petal.Length, color=Species)) +
  geom_point() +
  stat_ellipse()

mat <- iris %>% 
  select(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) %>% 
  as.matrix()

# permutational ANOVA; tells us if at least one species is different based on those columns
vegan::adonis2(mat ~ iris$Species)

mds <- vegan::metaMDS(mat)
# compresses multidimensional analysis (like perm. ANOVA) into 2D representable format
# default distance is usually good, but if there's environmental variables, use "mahalanobis"

data.frame(species = iris$Species,
           dimension1 = mds$points[,1],
           dimension2 = mds$points[,2]) %>% 
  ggplot(aes(x=dimension1, y=dimension2, color=species)) +
  geom_point() +
  stat_ellipse() # shows cluster overlap

kmeans()
# also check out tidyclust package!  great for combining yes/no, to predict 1 of many options




