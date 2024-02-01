library(tidyverse)
library(palmerpenguins)

# make an interesting penguin plot
names(penguins)

ggplot(penguins, mapping = aes(x=species, y=flipper_length_mm)) + 
  geom_boxplot() +
  geom_jitter(height=0, width=.3, alpha=.2)
# don't hide your actual data! Boxplot summarizes too much on its own


penguins %>% 
  ggplot(aes(x=factor(year), y=body_mass_g)) +
  geom_boxplot()


penguins %>% 
  ggplot(aes(x=body_mass_g, fill=species)) +
  geom_density(alpha=.25)
  # histogram would show similar but not quite same stats
# check the distribution of your data, to see what stats you can use on it



df <- read_delim("./Data/DatasaurusDozen.tsv")
head(df)

df %>% 
  group_by(dataset) %>% 
  summarize(meanx = mean(x), sdx=sd(x), minx=min(x), maxx=max(x))

df %>% 
  ggplot(aes(x=x, fill=dataset)) +
  geom_density(alpha=.2)

# mean & sd indicate the datasets are ~same, but distribution shows not!

df %>% 
  ggplot(aes(x=x, y=y)) +
  geom_point() +
  facet_wrap(~dataset)

# the data is WILD -- always plot it before you summarize it



library(GGally)
GGally::  # see what it's got
ggpairs(penguins)

# ^ found an interesting relation between bill depth & body mass
penguins %>% 
  ggplot(aes(x=bill_depth_mm, y=body_mass_g, color=species)) +
  geom_point()

penguins %>% 
  filter(!is.na(sex)) %>% 
  ggplot(aes(x=bill_depth_mm, y=body_mass_g, 
             color=species)) +
  geom_point(aes(shape=sex), size=2.5) +
  labs(x='Bill Depth (mm)', y='Body Mass (g)')




# for next class:
library(gapminder)


# show & tell!
library(leaflet)
# make a clickable map with data on it
