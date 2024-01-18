# Pop Quiz
x <- c(1,2,3,4,5)

for (i in x)
{
  print(1+i)
}


x + 1
x^3
# because R is so cool like that -- "Vectorized"
# vector = one-dimensional object, like a list/string
# c() makes a vector by concatenating
1:5
seq(1,5)
seq(1,10, by=2)


class(x)    #numeric
length(x)
length(length(x))
class(class(x))    #character


"a" + 2    #error
"a" + "2"    #error
y <- c("a", "2")    #vectroizes, NOT Python concat
c("a", 2)    #becomes all character class
length(c())


# A vector is 1D, has a class, is all the same class, and can be empty

1:5 + 1:5    #matrix math


a <- 1:10
b <- 2:11
c <- letters(1:10)    #error
c <- letters[1:10]
head(letters,n=10)
c <- letters[1,3,5]    #error
c <- letters[c(1,3,5)]

cbind(a,b,c)

z <- data.frame(a,b,c)    #only works if all pieces are same length
class(z)
length(z)
nrow(z)    #number of rows
dim(z)    #dimensions

d <- rep(TRUE, 10)
z <- data.frame(a,b,c,d)


# Logical class (TRUE/FALSE) vectors can be queried
1 > 0
0 >= 0
3 < 1
1 == 1
1 != 1
5 > a

a[5 > a]    #acts like a "where" query; shows only TRUE results

z[5>a]    #just gives everything
z[5>a , ]    #gives only rows where a < 5
# use comma to separate row vs column queries
# [row, column]
z[1,3]
z[1,]
z[,1]
z[c=="b",]


iris    #built-in data set
iris[iris$Sepal.Length > 6,]    #access column by name using $
nrow(iris[iris$Sepal.Length > 5,])
dim(iris[iris$Sepal.Length > 5,])[1]


big_iris <- iris[iris$Sepal.Length > 5,]
big_iris$Sepal.Area <- big_iris$Sepal.Length * big_iris$Sepal.Width

big_setosa <- big_iris[big_iris$Species == "setosa",]

mean(big_setosa$Sepal.Area)
sd(big_setosa$Sepal.Area)
sum(big_setosa$Sepal.Area)
min(big_setosa$Sepal.Area)
max(big_setosa$Sepal.Area)
summary(big_setosa$Sepal.Area)
cumsum(big_setosa$Sepal.Area)
cumprod(big_setosa$Sepal.Area)

plot(big_setosa$Sepal.Length, big_setosa$Sepal.Width)


# rows of iris where species is virginica or setosa
spec <- iris[iris$Species=='virginica'|iris$Species=='setosa',]
nrow(spec)

# rows of iris where species is virginica and sepal width > 3
wide_vir <- iris[iris$Sepal.Width>3 & iris$Species=='virginica',]    # NOT &&

# rows of iris where sepal width > 3, but only show species
wide_spec <- iris[iris$Sepal.Width>3, "Species"]
iris[,"Sepal.Length"]




# R Package of the week!
install.packages("qrcode")
library(qrcode)
url <- 'https://github.com/sarahef13/Data_Course_FOUT/'
qr <- qrcode::qr_code(url)
plot(qr)


