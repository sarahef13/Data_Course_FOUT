library(palmerpenguins)
library(tidyverse)
library(leaflet)
library(mapview)
library(webshot)
#webshot::install_phantomjs()


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
            na.label = 'Mystery Meat',
            title = "Wouldn't you like too know",
            labFormat = labelFormat(prefix = "maybe "),
            opacity = 1)


mapshot(peng_alltime,
        url = paste0(getwd(), "/ugly_peng_map_interactive.html"))

