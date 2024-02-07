# I don't have fly miRNA data ready yet, so I'm trying out the predictive software on penguins
# caTools & rpart code obtained from https://reintech.io/blog/comprehensive-tutorial-on-ai-with-r 

#install.packages('caTools')
#install.packages('rpart')
library(palmerpenguins)
library(tidyverse)
library(caTools)
library(rpart)

data("penguins")
str(penguins)


# Using rpart to predict an Adelie penguin's sex based on ONLY its bill length:

clean_adelie <- penguins %>% 
  filter(species == 'Adelie' & !is.na(bill_length_mm) & !is.na(sex)) %>% 
  subset(select = c('bill_length_mm', 'sex')) %>% 
  transform(sex = as.factor(sex))

str(clean_adelie)

set.seed(777)
split = sample.split(clean_adelie$sex, SplitRatio = 0.8)
training_set = subset(clean_adelie, split == TRUE)
test_set = subset(clean_adelie, split == FALSE)

classifier = rpart(formula = sex ~ ., data = training_set)

y_pred = predict(classifier, newdata = test_set[-2], type = 'class')

confusion_matrix = table(test_set[,2], y_pred)
head(confusion_matrix)
# Looks like it got ~3/4 of the penguin sex predictions right.


# Now, using rpart to predict an Adelie's sex based on its bill length AND depth:

clean_adelie <- penguins %>% 
  filter(species == 'Adelie' & !is.na(bill_length_mm) & !is.na(sex)) %>% 
  subset(select = c('bill_length_mm', 'bill_depth_mm','sex')) %>% 
  transform(sex = as.factor(sex))

str(clean_adelie)

set.seed(777)
split = sample.split(clean_adelie$sex, SplitRatio = 0.8)
training_set = subset(clean_adelie, split == TRUE)
test_set = subset(clean_adelie, split == FALSE)

classifier = rpart(formula = sex ~ ., data = training_set)

y_pred = predict(classifier, newdata = test_set[-3], type = 'class')

confusion_matrix = table(test_set[,3], y_pred)
head(confusion_matrix)
# It got more of the penguin sex predictions right this time (~6/7).


# I played around with some more tests, and it seems adding body mass
# or flipper length doesn't really improve the sex prediction.
