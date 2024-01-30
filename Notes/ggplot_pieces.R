library(tidyverse)

# convert this expression into pipe format
# to be more readable
unique(stringr::str_to_title(iris$Species))

iris %>% 
  pluck('Species') %>% 
  stringr::str_to_title() %>% 
  unique()

max(round(iris$Sepal.Length),0)
mean(abs(rnorm(100,0,5)))
median(round(seq(1,100,0.01),1))


# :: is "namespace", listing of functions in that package/environment
library(ggplot2)
ggplot2::aes()

library(palmerpenguins)
names(penguins)

ggplot(penguins, mapping=aes(x=flipper_length_mm,
                             y=body_mass_g,
                             fill=species)) +
  geom_col()
  # added up all penguin masses at each flipper length


ggplot(penguins, mapping=aes(x=flipper_length_mm,
                             y=body_mass_g,
                             fill=species)) +
  geom_col(position='dodge')
# put bars in front of each other instead of summing them


ggplot(penguins, mapping=aes(x=flipper_length_mm,
                             y=body_mass_g,
                             color=species)) +
  geom_line(aes(group=species))
  # first species mention is in global aesthetics
  # second species mention is in local geometry, so the lines get separated


ggplot(penguins, mapping=aes(x=flipper_length_mm,
                             y=body_mass_g,
                             color=species, alpha=bill_depth_mm)) +
  geom_path(aes(group=species)) +
  stat_ellipse() +
  geom_point(aes(color=sex)) +
  geom_polygon() +
  geom_bin_2d() +
  geom_boxplot() +
  geom_hline(yintercept=4500, linewidth=20,      # won't work without y-int
             color='magenta', linetype='1121',
             alpha=.5) +                         # alpha is transparency
  geom_point(color='yellow', aes(alpha=bill_depth_mm)) +
  theme(axis.title = element_text(face = 'italic',
                                  size = 12,
                                  angle = 30),
        legend.background = element_rect(fill = 'hotpink',
                                         color = 'blue',
                                         linewidth = 5))
# overlap geometries to get fugly
# change order to change overlap



