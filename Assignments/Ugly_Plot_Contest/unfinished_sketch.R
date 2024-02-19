library(palmerpenguins)
library(tidyverse)
library(leaflet)
library(mapview)
library(webshot)
#webshot::install_phantomjs()


str(penguins)
unique(penguins$island)
unique(penguins$sex)
unique(penguins$year)
?addLegend

penguins[is.na(penguins$body_mass_g),]

peng_places <- 
  penguins %>% 
    mutate(latitude = case_when(island == 'Torgersen' ~ -64.7667,
                                island == 'Biscoe' ~ -64.7999968,
                                island == 'Dream' ~ -64.7333304)) %>% 
    mutate(longitude = case_when(island == 'Torgersen' ~ -64.0833,
                                 island == 'Biscoe' ~ -63.83333,
                                 island == 'Dream' ~ -64.2333324)) %>%
    mutate(sex = as.character(sex)) %>% 
    mutate(sex = ifelse(!is.na(sex), sex, 'unsexed'))


peng_icons <- icons(iconUrl = ifelse(peng_places$sex == 'female', 'pink-penguin.png',
                                     ifelse(peng_places$sex == 'male', 'green-penguin.png',
                                            'yellow-penguin.png')),
                    iconWidth = (peng_places$flipper_length_mm ^2) / 300,
                    iconHeight = (peng_places$body_mass_g ^2) / 200000)

pallette <- colorNumeric(c('magenta', 'chartreuse', 'yellow'), domain = peng_places$bill_depth_mm)

peng_alltime <- 
  leaflet(data = peng_places) %>% 
  addTiles() %>% 
  addMarkers(icon = peng_icons,
             label = paste0(peng_places$year, peng_places$species),
             labelOptions = labelOptions(noHide = TRUE, textOnly = TRUE,
                                         style = list('color' = 'magenta', 
                                                      'font-style' = 'italic',
                                                      'font-size' = '16px')),
             clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = FALSE)) %>% 
  addLegend(pal = pallette, values = ~bill_depth_mm,
            position = 'bottomleft',
            na.label = 'mystery meat',
            title = "Wouldn't you like too know",
            labFormat = labelFormat(prefix = "maybe "),
            opacity = 1)

mapshot(peng_alltime,
        url = paste0(getwd(), "/ugly_peng_map.html"))


peng_2007 <- 
  leaflet(data = peng_places[peng_places$year == 2007,]) %>% 
  addTiles() %>% 
  addMarkers(icon = peng_icons,
             clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = FALSE))

mapshot(peng_2007,
        url = paste0(getwd(), "/peng_2007_map.html"))

webshot('peng_2007_map.html', paste0(getwd(), "/peng_2007_map.png"), 
        delay = 0.2 , cliprect = c(440, 0, 1000, 10))


peng_2008 <- 
  leaflet(data = peng_places[peng_places$year == 2008,]) %>% 
  addTiles() %>% 
  addMarkers(icon = peng_icons,
             clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = FALSE))

mapshot(peng_2008,
        url = paste0(getwd(), "/peng_2008_map.html"))


peng_2009 <- 
  leaflet(data = peng_places[peng_places$year == 2009,]) %>% 
  addTiles() %>% 
  addMarkers(icon = peng_icons,
             clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = FALSE))

mapshot(peng_2009,
        url = paste0(getwd(), "/peng_2009_map.html"))



?markerClusterOptions
?icons


