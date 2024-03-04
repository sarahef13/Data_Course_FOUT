library(tidyverse)
library(easystats)

#### 1. ####
# Read in the UNICEF data (10 points) 
data <- read_csv('unicef-u5mr.csv')


#### 2. ####
# Get it into tidy format (10 points) 
tidydat <- data %>% 
  pivot_longer(starts_with('U5MR.'), 
               names_to = 'Year', 
               values_to = 'U5MR',
               names_prefix = 'U5MR.',
               names_transform = as.numeric)


#### 3. ####
# Plot each country’s U5MR over time (20 points)
# Create a line plot (not a smooth trend line) for each country
# Facet by continent
u5mrByYear <- tidydat %>% 
  ggplot(aes(x=Year, y=U5MR)) +
  geom_path() + 
  facet_wrap(~Continent) +
  theme_bw()


#### 4. ####
# Save this plot as LASTNAME_Plot_1.png (5 points)
ggsave('./FOUT_Plot_1.png', 
       u5mrByYear,
       scale = 1.6)


#### 5. ####
# Create another plot that shows the mean U5MR for all the countries 
# within a given continent at each year (20 points)
# Another line plot (not smooth trend line)
# Colored by continent
u5mrByContinent <- tidydat %>% 
  group_by(Year, Continent) %>% 
  summarize(Mean_U5MR = mean(U5MR, na.rm = TRUE)) %>% 
  ggplot(aes(x=Year, y=Mean_U5MR, color=Continent)) +
  geom_path(size=2) +
  theme_bw()


#### 6. ####
# Save that plot as LASTNAME_Plot_2.png (5 points) 
ggsave('./FOUT_Plot_2.png', 
       u5mrByContinent,
       scale = 1.6)


#### 7. ####
# Create three models of U5MR (20 points)
# mod1 should account for only Year
# mod2 should account for Year and Continent
# mod3 should account for Year, Continent, and their interaction term
mod1 <- glm(data = tidydat, formula = U5MR ~ Year)
mod2 <- glm(data = tidydat, formula = U5MR ~ Year + Continent)
mod3 <- glm(data = tidydat, formula = U5MR ~ Year * Continent)


#### 8. ####
# Compare the three models with respect to their performance
# Your code should do the comparing
# Include a comment line explaining which of these three models you think is best

compare_performance(mod1, mod2, mod3) %>% plot
# Based on the above comparison table & plot, mod3 looks the best, because
# mod3 has the best return on investment when it comes to predictive ability vs complexity.
# It has the highest R2 & lowest RMSE, yet its complexity (AIC & BIC) is still simple.


#### 9. ####
# Plot the 3 models’ predictions (10 points)
tidydat$mod1 <- predict(mod1, tidydat)
tidydat$mod2 <- predict(mod2, tidydat)
tidydat$mod3 <- predict(mod3, tidydat)
tidydat <- tidydat %>% 
  pivot_longer(starts_with('mod'), 
               names_to = 'Model', 
               values_to = 'Prediction')

tidydat %>% 
  group_by(Year, Continent, Model) %>% 
  summarize(Mean_U5MR = mean(Prediction, na.rm = TRUE)) %>% 
  ggplot(aes(x=Year, y=Mean_U5MR, color=Continent)) +
  geom_path(size=1.5) +
  facet_wrap(~Model) +
  theme_bw() +
  ggtitle('Model predictions') +
  labs(y='Predicted U5MR')


#### 10. BONUS ####
# Using your preferred model, predict what the U5MR would be for Ecuador
# in the year 2020. The real value for Ecuador for 2020 was 13 under-5 deaths per 1000 
# live births. How far off was your model prediction???
# Your code should predict the value using the model and calculate the difference 
# between the model prediction and the real value (13).
ecuador <- tidydat[which(tidydat$CountryName == 'Ecuador' & tidydat$Model == 'mod3')[1],]
ecuador$Year = 2020
ecuador$U5MR = 13
ecuador$Prediction = predict(mod3, ecuador)
ecuador <- ecuador %>% 
  mutate(HowFarOff = Prediction - U5MR)

print(ecuador)


# Source: https://data.unicef.org/country/ecu/
# Create any model of your choosing that improves upon this “Ecuadorian measure of 
# model correctness.” By transforming the data, I was able to find a model that 
# predicted Ecuador would have a U5MR of 16.61… not too far off from reality
mod4 <- glm(data = tidydat, formula = U5MR ~ Year + Region)
mod5 <- glm(data = tidydat, formula = U5MR ~ Continent * poly(Year, 2))
compare_performance(mod1, mod2, mod3, mod4, mod5) %>% plot

ecuador <- rbind(ecuador, ecuador[rep(1, 2), ])
ecuador$Model[2] = 'mod4'
ecuador$Prediction[2] = predict(mod4, ecuador)
ecuador$Model[3] = 'mod5'
ecuador$Prediction[3] = predict(mod5, ecuador)

ecuador <- ecuador %>% 
  mutate(HowFarOff = Prediction - U5MR)
print(ecuador)
