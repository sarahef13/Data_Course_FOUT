# **I.**
#   **Read the cleaned_covid_data.csv file into an R data frame. (20 pts)**
df <- read.csv('cleaned_covid_data.csv')

str(df)


#   **II.**
#   **Subset the data set to just show states that begin with "A" and save this 
#     as an object called A_states. (20 pts)**

#   + Use the *tidyverse* suite of packages
#   + Selecting rows where the state starts with "A" is tricky 
#     (you can use the grepl() function or just a vector of those states if you prefer)
library(tidyverse)
A_states <- df %>% 
  filter(str_detect(Province_State, "^A"))

str(A_states)


# **III.**
#   **Create a plot _of that subset_ showing Deaths over time, 
#     with a separate facet for each state. (20 pts)**
#   
#   + Create a scatterplot
#   + Add loess curves WITHOUT standard error shading
#   + Keep scales "free" in each facet
library(ggplot2)
A_states %>% 
  ggplot(mapping=aes(x=as_date(Last_Update), y=Deaths)) +
    geom_point() +
    geom_smooth(method='loess', se=FALSE) +
    facet_wrap(~Province_State, scales='free') +
    ggtitle("Covid Deaths per State Over Time") +
    xlab("Apr 2020 - Jan 2022")


# **IV.** (Back to the full dataset)
# **Find the "peak" of Case_Fatality_Ratio for each state and save this as a new 
#   data frame object called state_max_fatality_rate. (20 pts)**
#   
#   I'm looking for a new data frame with 2 columns:
# 
#   + "Province_State"
#   + "Maximum_Fatality_Ratio"
#   + Arrange the new data frame in descending order by Maximum_Fatality_Ratio
#  
# This might take a few steps. Be careful about how you deal with missing values!
state_max_fatality_rate <- df %>% 
  filter(!is.na(Case_Fatality_Ratio)) %>% 
  group_by(Province_State) %>% 
  summarize('Maximum_Fatality_Ratio'=max(Case_Fatality_Ratio)) %>% 
  arrange(desc(Maximum_Fatality_Ratio)) 

str(state_max_fatality_rate)


# **V.**
# **Use that new data frame from task IV to create another plot. (20 pts)**
# 
#   + X-axis is Province_State
#   + Y-axis is Maximum_Fatality_Ratio
#   + bar plot
#   + x-axis arranged in descending order, just like the data frame (make it a factor)
#   + X-axis labels turned to 90 deg to be readable
#  
# Even with this partial data set (not current), you should be able to see that 
# (within these dates), different states had very different fatality ratios.
state_max_fatality_rate %>% 
  ggplot(mapping=aes(x=as_factor(Province_State), y=Maximum_Fatality_Ratio)) +
    geom_bar(stat='identity') +
    ggtitle("Maximum Covid Fatality Ratio per Province/State") +
    theme(axis.text.x = element_text(angle=90, face='bold', hjust=1),
          plot.title = element_text(hjust=.5)) +
    xlab("Province_State")


# **VI.** (BONUS 10 pts)
# **Using the FULL data set, plot cumulative deaths for the entire US over time**
# 
#   + You'll need to read ahead a bit and use the dplyr package functions group_by() 
#     and summarize() to accomplish this.
deaths_per_day <- df %>% 
  group_by(Last_Update) %>% 
  summarize(Cumulative_Deaths = sum(Deaths))

str(deaths_per_day)

deaths_per_day %>% 
  ggplot(mapping=aes(x=as_date(Last_Update), y=Cumulative_Deaths)) +
  geom_point() +
  ggtitle("Cumulative Covid Deaths in the U.S.") +
  xlab("Apr 2020 - Jan 2022")

