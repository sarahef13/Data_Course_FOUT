# Morning warmup ####
mtcars
four_cyl <- mtcars[mtcars$cyl > 4,]
summary(four_cyl$mpg)


# ctrl + shift + o to see the notes outline


# Accessing vectors ####
# 1D vector
letters[3]
# 2D vector
mtcars[1,1]


# Object Types ####
## logical ####
c(TRUE, FALSE, NA)
## numeric ####
1:10
## character ####
letters[3]
## integer ####
c(1L, 2L, 3L)

## data.frame ####
mtcars
    str(mtcars) # structure NOT string
    names(mtcars)
    as.character(mtcars) # doesn't work right
    # convert all data columns to char type
    for (col in names(mtcars))
    {
      mtcars[,col] <- as.character(mtcars[,col])
    }
data(mtcars) # puts the built-in data back
### shortcut "apply" ####
    apply(mtcars,2, as.character) 
        # 2 applies function to columns; 1 would be rows
    lapply(list, function)
    sapply(list, function)
    vapply(list, function, FUN.VALUE = type, ..)


## factor ####
as.factor(letters) # "Levels:" indicates factor
    # stores items as numbers, for easy categorizing/comparing
    haircolors <- c('brown', 'blonde', 'black', 'red', 'red', 'black')
    factored_hair <- as.factor(haircolors)
    c(factored_hair, 'purple') # shows originals as numbers
    as.character(factored_hair, 'purple') # leaves out purple
    factored_hair[5]
    factored_hair[7] <- 'purple' # doesn't work b/c not existing level
    factored_hair[7] <- 'brown' # does work


# Type Conversions ####
1:5
as.character(1:5)
as.numeric(letters)
as.numeric(c(1, "b", "33")) # will do its best
as.logical(c("true", "1", 1, 0, "False", "", "t", "F"))
x <- as.logical(c('true', 't', 'F', 'False', 'T'))

## Logical math ####
sum(x)
sum(TRUE)
TRUE + TRUE
FALSE + 0
NA + 2
sum(x, na.rm = TRUE)


# Messing with Files ####
path <- "./Data/cleaned_bird_data.csv"
df <- read.csv(path)
str(df)
    # convert to character
    for (col in names(df))
    {
      df[,col] <- as.character(df[,col])
    }
write.csv(df, file = "./Data/cleaned_bird_data_char.csv")

## NEVER edit the original file ####


# tidyverse ####

library(tidyverse)
# how to specify which function you wanna use
stats::filter()
dplyr::filter()
?filter

## "pipe" ####
mtcars %>% 
  # ctrl + shift + m gets that symbol
  # object on left becomes first argument to thing on right
  filter(mpg > 19) # tidyverse filter selects rows

mtcars %>% 
  filter(mpg > 19 & vs == 1)

# these two code chunks are the same:
    abs(mean(mtcars$mpg))
    
    mtcars$mpg %>% 
      mean %>% 
      abs

