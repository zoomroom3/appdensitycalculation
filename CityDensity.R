## Data Science Toolbox Discussion Exercise
#install.packages("reshape2")
#install.packages("tidyverse")
#install.packages("broom")
## import libraries
# for merging of dataframes
library(reshape2)
# for count and select
library(tidyverse)

# import data csv files
population = read.csv("population.csv")
region_area = read.csv("regionarea.csv")

# aggregate to get the total population per city, x
population_CityProvince = aggregate(population$Population, by=list(CityProvince=population$CityProvince), FUN=sum)

## reformat the population dataframe to get CityProvince and Region columns only with no duplicates
# dataframe with only Region and CityProvince columns
population_byCity <- select(.data = population, Region, CityProvince)
# remove duplicates
population_byCity_nodup = population_byCity[!duplicated(population_byCity), ]

# count the CityProvince per Region, n
region_CityProvince = count(population_byCity_nodup, Region)

# merge Region, CityProvince, city count per region (n), total population per CityProvince (x)
population_byCity_count = merge(x=population_byCity_nodup,y=region_CityProvince,by =c("Region"),all.x = TRUE)
population_byCity_count_popu = merge(x=population_byCity_count,y=population_CityProvince,by =c("CityProvince"),all.x = TRUE)
# merge dataframe with region_area
population_City_area = merge(x=population_byCity_count_popu,y=region_area,by =c("Region"),all.x = TRUE)

## Density computation
# compute city area
population_City_area$City_Area = population_City_area$Area / population_City_area$n
# compute population density
population_City_area$Population_Density = population_City_area$x / population_City_area$City_Area
# dataframe with only CityProvince and population density columns
City_df <- select(.data = population_City_area, CityProvince, Population_Density)
# get the top 5 city with highest density
top_city <- head(arrange(City_df,desc(Population_Density)), n = 5)

# export top_city to csv
write.csv(top_city,"top_city.csv", row.names = FALSE)


