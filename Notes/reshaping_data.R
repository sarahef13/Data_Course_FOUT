library(tidyverse)

df <- read_csv('./Data/wide_income_rent.csv')
str(df)

# (DONT DO THIS)
df_tall <- t(df) %>% as.data.frame()
df_tall <- df_tall[-1,] # "everything except row 1"
df_tall$State <- row.names(df_tall)
names(df_tall) <- c('income', 'rent', 'State')
str(df_tall)
# that was a lot of work for not a great data frame.

# much better way:
df %>% 
  pivot_longer(-variable, names_to = 'state', values_to = 'amount') %>% 
  ggplot(aes(x=state, y=amount, color=variable)) +
  geom_point(size=3)
# hasn't got income & rent in separate columns

df_good <- df %>% 
  pivot_longer(-variable, names_to = 'state', values_to = 'amount') %>% 
  pivot_wider(names_from = variable, values_from = amount)
# yay, that's what we want!

# if 1 variable is across multiple columns, use pivot longer
# if multiple variables are in a single column, use pivot wider

df_good %>% 
  ggplot(aes(x=state, y=rent)) +
  geom_col() +
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5, size=6))



head(table1)
# ^ this is actually tidy data, even though it looks weird

head(table2)
# ^ this is ugly and we want it to look like table1
table2 %>% pivot_wider(names_from = type, values_from = count)

head(table3)
table3 %>% separate(rate, c('cases', 'population'), sep='/')
# split 1 column into 2 if there's a delimiter

head(table4a)
head(table4b)
# here, cases & population are in separate tables
case_df <- table4a %>% pivot_longer(-country, names_to = 'year', values_to = 'cases')
pop_df <- table4b %>% pivot_longer(-country, names_to = 'year', values_to = 'population')
full_join(case_df, pop_df)
# can join tables once they're formatted tidy & structured similarly

head(table5)
# need to combine some and separate others, then make them math-able
table5 %>% 
  separate(rate, c('cases', 'population'), convert = TRUE) %>% 
  mutate(year = paste0(century, year) %>% as.numeric()) %>% 
  select(-century)



library(readxl)
dat <- read_xlsx('./Data/messy_bp.xlsx', skip = 3)

# start with just blood pressure across visits
bp <- dat %>% 
  select(-starts_with('HR')) %>% 
  pivot_longer(starts_with('BP'), names_to = 'visit', values_to = 'BP') %>% 
  mutate(visit = case_when(visit=='BP...8' ~ 1,
                           visit=='BP...10' ~ 2,
                           visit=='BP...12' ~ 3)) %>% 
  separate(BP, into=c('systolic', 'diastolic'))

hr <- dat %>% 
  select(-starts_with('BP')) %>% 
  pivot_longer(starts_with('HR'), names_to = 'visit', values_to = 'HR') %>% 
  mutate(visit = case_when(visit=='HR...9' ~ 1,
                           visit=='HR...11' ~ 2,
                           visit=='HR...13' ~ 3))

df <- full_join(bp, hr)

library(janitor)
df <- df %>% 
  clean_names() # make column names sensible

df$race %>% unique # find entries to consolidate
df$hispanic %>% unique 
df$sex %>% unique 

df <- df %>% 
  mutate(race = case_when(race == 'Caucasian' | race == 'WHITE' ~ 'White',
                          TRUE ~ race)) %>% # change weird whites & leave all else as-is
  mutate(birthdate = paste(year_birth, month_of_birth, day_birth, sep = '-') %>% 
           as.POSIXct()) %>% 
  mutate(systolic = systolic %>% as.numeric(),
         diastolic = diastolic %>% as.numeric()) %>% 
  mutate(hispanic = case_when(hispanic == 'Not Hispanic' ~ FALSE,
                              TRUE ~ TRUE)) %>% 
  select(-pat_id, -month_of_birth, -day_birth, -year_birth)

str(df)

df %>% 
  ggplot(aes(x=visit, y=hr, color=sex)) +
  geom_path() +  # use path, NOT line
  facet_wrap(~race)

df %>% 
  ggplot(aes(x=visit, color=sex)) +
  geom_path(aes(y=systolic)) +
  geom_path(aes(y=diastolic)) +
  facet_wrap(~race)
# but this doesn't show which bp type is which!
df <- df %>% 
  pivot_longer(cols = c('systolic', 'diastolic'), 
               names_to = 'bp_type', values_to = 'bp')

df %>% 
  ggplot(aes(x=visit, y= bp, color=bp_type)) +
  geom_path() +
  facet_wrap(~race)
# now we can color by systolic vs diastolic






# show and tell
library(ggmagnify)
