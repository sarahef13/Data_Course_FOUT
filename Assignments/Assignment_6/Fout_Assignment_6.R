library(tidyverse)
library(janitor)
library(gganimate)
#library(transformr)

dat <- read_csv("../../Data/BioLog_Plate_Data.csv")

#skimr::skim(dat)
#str(dat)

#unique(dat$sample_id)
#unique(dat$rep)
#unique(dat$well)
#unique(dat$dilution)
#unique(dat$substrate)
#unique(clean_dat$source)
#skimr::skim(clean_dat)
#str(clean_dat)


clean_dat <- 
  dat %>% 
  clean_names() %>% 
  mutate(source = case_when(sample_id=='Clear_Creek' ~ 'Water',
                            sample_id=='Waste_Water' ~ 'Water',
                            sample_id=='Soil_1' ~ 'Soil',
                            sample_id=='Soil_2' ~ 'Soil')) %>% 
  pivot_longer(starts_with('hr_'), 
               names_to = 'hour', 
               values_to = 'absorbance',
               names_prefix = 'hr_',
               names_transform = as.numeric)


big_plot <- clean_dat %>% 
  filter(dilution == 0.1) %>% 
  ggplot(aes(x=hour, y=absorbance, color=source)) +
  geom_smooth(se=FALSE) + 
  facet_wrap(~substrate) +
  ggtitle('Just dilution 0.1') +
  labs(x='Time', y='Absorbance', color='Type') #+
  #theme(plot.background = element_rect(fill = 'lightgray'))
  # what freaking color is the reference plot's background ??
  # I've tried so many themes/colors... None match

ggsave('./just_dilution_01.png',
     big_plot,
     width = 3600,
     height = 1800,
     units = 'px')


anim_plot <- clean_dat %>% 
  filter(substrate == 'Itaconic Acid') %>% 
  group_by(sample_id, dilution, hour) %>% 
  summarize(mean_absorbance = mean(absorbance)) %>% 
  ggplot(aes(x=hour, y=mean_absorbance, color=sample_id)) +
  geom_line() + 
  facet_wrap(~dilution) +
  labs(x='Time', y='Mean_absorbance', color='Sample ID') +
  theme_minimal() +
  transition_reveal(hour)

animate(anim_plot, 
        height = 480, 
        width = 480,
        units = 'px')
anim_save('./itaconic_acid.gif')


