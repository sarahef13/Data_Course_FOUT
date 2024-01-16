# Notes from start of class
getwd()
list.files()
list.files(path = "Assignments/", recursive = TRUE)
?list.files()

list.files(pattern = ".csv", recursive = TRUE)
readLines("Data/wide_income_rent.csv")
read.csv("Data/wide_income_rent.csv")

x <- list.files(pattern = ".csv", recursive = TRUE)
x
x[159]
read.csv(x[159])

dat <- read.csv(x[159])
# use (ALT) + (-) to make (<-)

?length()    # find how many items in obj
?head()    # list first n lines of obj

#Regular Expressions
"^a"    # starts with "a"

# For Loop Syntax
x <- c("Cool", "Boring", "So Fat")
for (i in x)
{
  print(paste0("Your mom is ", i))
}



