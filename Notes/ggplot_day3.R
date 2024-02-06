# geomgrob lets you import(?) other graphs onto your plot

# awesome_ggplot2 is a big list of fun/useful packages to download

library(tidyverse)
library(ggimage)
library(gganimate)
library(patchwork)
library(gapminder)

# gapminder plot
glimpse(gapminder)
# life expectancy over time & country, by population & gdp

p <- gapminder %>% 
      ggplot(aes(x=year, y=lifeExp, color=continent)) +
      geom_point(aes(size=pop)) +
      facet_wrap(~continent)

p.dark <- p + theme_dark()
# you can modify graph vectors

p + p.dark
p / p.dark
(p + p.dark) / p.dark + plot_annotation('MAIN TITLE') +
  plot_layout(guides='collect')
# orders the plots by direction thanks to patchwork package

g <- gapminder %>% 
  ggplot(aes(x=year, y=lifeExp, color=continent)) +
  geom_point(aes(size=pop))

g2 <- g + facet_wrap(~continent)

g3 <- g / g2 +
        plot_layout(guides='collect') +
        plot_annotation(title='Comparing with and without facets')

# using animation to show change over time
my_countries <- c("Venezuela", "Rwanda", "Nepal", "Iraq", "Afghanistan", "United States")

df <- gapminder %>% 
  mutate(country_names = case_when(country %in% my_countries ~ country))

f <- ggplot(df,
            aes(x=gdpPercap, y=lifeExp, color=continent)) +
  geom_point()

f2 <- f +
  transition_time(time=year) +
  labs(title='Year: {frame_time}')

f3 <- f2 +
  geom_text(aes(label=country_names))


# how to save -- might need to open files in Firefox to view
anim_save("./Notes/gapminder_anim.gif") # will save most recent animation
ggsave("./Notes/gapminder_plot.png", plot=g3, device='png')


