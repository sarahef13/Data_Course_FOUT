library(tidyverse)
library(readxl)
library(janitor)
dat <- read_xlsx('./Data/messy_bp.xlsx', skip = 3)

# TRANSFORM DATA ALGORITHMICALLY INSTEAD OF BY HAND


bp <- dat %>% 
  select(-starts_with('HR')) 

#names(bp)
num_visits <- bp %>% 
  select(starts_with('BP')) %>% 
  length()
new_names <- paste0('visit_', 1:num_visits)
names_to_change <- which(grepl("^BP", names(bp)))
names(bp)[names_to_change] <- new_names
# combined: names(bp)[which(grepl('^BP', names(bp)))] <- paste0('visit_', 1:num_visits)

bp <- bp %>% 
  pivot_longer(starts_with('visit_'), 
               names_to = 'visit', 
               values_to = 'BP',
               names_prefix = 'visit_',
               names_transform = as.numeric) %>% 
  separate(BP, into=c('systolic', 'diastolic'))


hr <- dat %>% 
  select(-starts_with('BP')) 

num_visits <- hr %>% 
  select(starts_with('HR')) %>% 
  length()
new_names <- paste0('visit_', 1:num_visits)
names_to_change <- which(grepl("^HR", names(hr)))
names(hr)[names_to_change] <- new_names

hr <- hr %>% 
  pivot_longer(starts_with('visit_'), 
               names_to = 'visit', 
               values_to = 'HR',
               names_prefix = 'visit_',
               names_transform = as.numeric)


df <- full_join(bp, hr)

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


'XVII' %>% as.roman() %>% as.numeric()


