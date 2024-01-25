library(tidyverse)
library(palmerpenguins)

# "tibble" = tbl_df = lazy data frame; 
# basically the same but prints better & doesn't like row names

penguins %>% names

x <- penguins %>% 
  filter(bill_length_mm > 40 & sex == 'female')
x$body_mass_g %>% mean

# find mean body mass of long-beaked female penguins
penguins %>% 
  filter(bill_length_mm > 40 & sex == 'female') %>% 
  pluck('body_mass_g') %>% 
  mean

?pluck

# do the same, but separated by species
penguins %>% 
  filter(bill_length_mm > 40 & sex == 'female') %>% 
  group_by(species) %>% 
  summarize(mean_body_mass = mean(body_mass_g),
            min_body_mass = min(body_mass_g),
            max_body_mass = max(body_mass_g),
            N = n()) %>% 
  arrange(desc(mean_body_mass)) %>% 
  write_csv("./Data/penguin_summary.csv")
# we basically made an Excel pivot table
# tidyverse's write_csv is better than built-in write.csv


# add island grouping
penguins %>% 
  filter(bill_length_mm > 40 & sex == 'female') %>% 
  group_by(species, island) %>% 
  summarize(mean_body_mass = mean(body_mass_g),
            min_body_mass = min(body_mass_g),
            max_body_mass = max(body_mass_g),
            N = n()) %>% 
  arrange(desc(mean_body_mass))


# find the fatty penguins (body_mass > 5000)
# count how many are male vs female
# return the max body mass for each
# bonus: add new column to penguins saying if they're fatty
penguins %>% 
  filter(body_mass_g > 5000) %>% 
  group_by(sex) %>% 
  summarize(N = n(),
            max_mass = max(body_mass_g))

# penguins <- penguins$body_mass_g > 5000

# put just true/false in fatty column
penguins %>% 
  mutate(fatty = body_mass_g > 5000)

# put special words in column
chub <- penguins %>% 
  mutate(fatstat = case_when(body_mass_g > 5000 ~ "fattie",
                             body_mass_g <= 5000 ~ "skinny"))
view(chub)

# ...and show them on a point/dot plot!
chub %>% 
  ggplot(mapping = aes(x = body_mass_g, 
                       y = bill_length_mm,
                       color = fatstat,
                       shape = fatstat)) +
  geom_point() +
  geom_smooth() +
  scale_color_manual(values = c('gold', 'turquoise')) # set specific colors
  #scale_color_viridis_d(option = 'plasma', end = .8) # viridis for colorblind



