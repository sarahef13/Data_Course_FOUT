library(tidyverse)
library(skimr)
library(janitor)

in_file <- read_csv('./Data/Bird_Measurements.csv')

in_file <- clean_names(in_file)
skim(in_file)

rename_func <- function(in_name) {
  out_name <- str_remove(in_name, '^m_')
  out_name <- str_remove(out_name, '^f_')
  out_name <- str_remove(out_name, '^unsexed_')
  return (out_name)
}


females <- in_file %>% 
  select(-starts_with('m_'), -starts_with('un'), -ends_with('_n')) %>% 
  mutate(sex = 'female') %>% 
  rename_with(rename_func)

males <- in_file %>% 
  select(-starts_with('f_'), -starts_with('un'), -ends_with('_n')) %>% 
  mutate(sex = 'male') %>% 
  rename_with(rename_func)

unsex <- in_file %>% 
  select(-starts_with('m_'), -starts_with('f_'), -ends_with('_n')) %>% 
  mutate(sex = 'unsexed') %>% 
  rename_with(rename_func)


cleaned <- full_join(females, males)
cleaned <- full_join(cleaned, unsex)

cleaned <- cleaned %>% 
  arrange(species_name)

