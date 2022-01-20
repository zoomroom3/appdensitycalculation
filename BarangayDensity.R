#Barangay Density R
#Reading the population & region area file
population <- read.csv("population.csv", stringsAsFactors = TRUE)
head(population)
region_area <- read.csv("regionarea.csv", stringsAsFactors = TRUE)
head(region_area)

#Loading needed libarries for data manipulation
library(tidyverse)
library(reshape2)

#Finding the number of Barangays per Region
region <- count(population, Region)

#Merging the 'region' df with the 'population' df
population_2 <- merge(population,region)

#Merging the 'region_area 'df' with the updated 'population_2' df
population_3 <- merge(population_2,region_area)

#Creating a new column for the Barangay Area
population_3$barangay_area <- population_3$Area/population_3$n

#Creating a new column for the Population per Barangay Area
population_3$density <- population_3$Population/population_3$barangay_area

#Producing a new dataframe with only 'Barangay' and 'density'
barangay_df <- select(.data = population_3,Barangay,density)

#Identifying the top 5 Barangays with the highest density
top_barangay <- head(arrange(barangay_df,desc(density)), n = 5)

#Writing the 'top_barangay' into a csv format
write.csv(top_barangay,"top_barangay.csv", row.names = FALSE)


#Top 5 per City
per_city <- population_3 %>%
  arrange(desc(density)) %>% 
  group_by(CityProvince) %>%
  slice(1:5)
per_city

per_city <- select(.data = per_city,CityProvince,Barangay,density)

write.csv(per_city,"top_per_city.csv", row.names = FALSE)

#Top 5 per Region
per_region <- population_3 %>%
  arrange(desc(density)) %>% 
  group_by(region) %>%
  slice(1:5)
per_region

per_region <- select(.data = per_region,Region,Barangay,density)

write.csv(per_region,"top_per_region.csv", row.names = FALSE)
