# Task 4: find CSV files and save as object
csv_files <- list.files(path = "Data/", pattern = ".csv", recursive = TRUE)


# Task 5: how many files were found
num_files <- length(csv_files)


# Task 6: open file & store contents
df <- read.csv(list.files(pattern = "wingspan_vs_mass.csv", recursive = TRUE))


# Task 7: list first 5 lines
head(df, n=5L)


# Task 8: find files starting with "b"
list.files(path = "Data/", pattern = "^b", recursive = TRUE)


# Task 9: show first line of each result
b_files <- list.files(path = "Data/", pattern = "^b", recursive = TRUE, full.names = TRUE)
readLines(b_files[1], n=1)

for (i in b_files)
{
  print(readLines(i, n=1))
}


# Task 10: show first line of all csv files
all_csv <- list.files(pattern = ".csv", recursive = TRUE)
for (i in all_csv)
{
  print(readLines(i, n=1))
}

