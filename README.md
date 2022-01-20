# Population Density

## Population Density per City
In CityDensity.R we computed the Population Density per CityProvince. We also exported the top 5 cities with the highest population density into a csv file.

First, we import the dataset csv files
```sh
population = read.csv("population.csv")
region_area = read.csv("regionarea.csv")
```

Next, we get the total population per city by adding all population of all the barangays in that city
```sh
# total population per city = barangay 1 in city + barangay 2 in city + ...
population_CityProvince = aggregate(population$Population, by=list(CityProvince=population$CityProvince), FUN=sum)
```

After that, we have to reformat the population dataframe to get CityProvince and Region columns only with no duplicates
```sh
# dataframe with only Region and CityProvince columns
population_byCity <- select(.data = population, Region, CityProvince)
# remove duplicates
population_byCity_nodup = population_byCity[!duplicated(population_byCity), ]
```

Use R to count the CityProvince per Region
```sh
# count the CityProvince per Region, n
region_CityProvince = count(population_byCity_nodup, Region)
```

Then, use left join to merge merge Region, CityProvince, city count per region (n), total population per CityProvince (x) into one dataframe
```sh
population_byCity_count = merge(x=population_byCity_nodup,y=region_CityProvince,by =c("Region"),all.x = TRUE)
population_byCity_count_popu = merge(x=population_byCity_count,y=population_CityProvince,by =c("CityProvince"),all.x = TRUE)
# merge dataframe with region_area
population_City_area = merge(x=population_byCity_count_popu,y=region_area,by =c("Region"),all.x = TRUE)
```

To compute for the density, we first compute the city area
```sh
# City Area = Area of Region/ Number of cities per region (n)
population_City_area$City_Area = population_City_area$Area / population_City_area$n

```
Now we are able to compute the population density per city
```sh
# Population Density per City = Total population per city (x)/ Area of City per Region (City_Area)
population_City_area$Population_Density = population_City_area$x / population_City_area$City_Area
```

We took the top 5 city with the highest density and exported it into a CSV file
```sh
# dataframe with only CityProvince and population density columns
City_df <- select(.data = population_City_area, CityProvince, Population_Density)
# get the top 5 city with highest density
top_city <- head(arrange(City_df,desc(Population_Density)), n = 5)

# export top_city to csv
write.csv(top_city,"top_city.csv", row.names = FALSE)
```
