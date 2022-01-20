# Population Density
## Population Density per Barangay
Calculations for population density of all Barangays in the Philippines

*We assume that all barangays in a particular region have equal land area. ((E.g. 
Area of Barangay in Region 1 = Area of Region 1/Number of Barangays in Region 1)

For our datasets, we have the ff:

regionarea.csv : A list of all regions and their corresponding Area
population.csv : List of barangay and their corresponding region, province, cityprovince, population, household population, and number of households

Preparing our data
 - In identifying the population density, we first need to know the number of Barangays per Region.

 - After creating the list of Barangay count per region, we merge it to the population.csv

 - We merge as well regionarea.csv with the updated population.csv.

Data Manipulation

1. Solve for the Barangay Area by dividing Region Area with number of Barangays.
    ```sh
      #Creating a new column for the Barangay Area
      population_3$barangay_area <- population_3$Area/population_3$n
    ```
2. After getting the Barangay Area, we can now solve for the density by dividing the Population by Barangay Area
    ```sh  
      #Creating a new column for the Population per Barangay Area
      population_3$density <- population_3$Population/population_3$barangay_area
    ```
3. In identifying the top 5 Barangays with the highest densities, we use the arrange and head functions 
    ```sh
      #Identifying the top 5 Barangays with the highest density
      top_barangay <- head(arrange(barangay_df,desc(density)), n = 5)
    ```
4. In identifying the top 5 Barangays with the highest densities per City, we use the arrange, groupby, and slice functions 
    ```sh
      #Top 5 per City
      per_city <- population_3 %>%
                  arrange(desc(density)) %>% 
                  group_by(CityProvince) %>%
                  slice(1:5)
      per_city
    ```    
5. In identifying the top 5 Barangays with the highest densities per Region, we use the arrange, groupby, and slice 
    ```sh
      #Top 5 per Region
      per_region <- population_3 %>%
                    arrange(desc(density)) %>% 
                    group_by(region) %>%
                    slice(1:5)
      per_region
    ```    
6. We now write the three top 5 tables into a csv file.
    ```sh
      #Writing the 'top_barangay' into a csv format
      write.csv(top_barangay,"top_barangay.csv", row.names = FALSE)
    ```
    ```sh
      #Writing the 'top_per_city' into a csv format
      write.csv(per_city,"top_per_city.csv", row.names = FALSE)
    ```
    ```sh
      #Writing the 'top_per_region' into a csv format
      write.csv(per_region,"top_per_region.csv", row.names = FALSE)
    ```
    
Summary

We are able to identify the top 5 barangays with the highest density overall, per city, and per region by using different functions and libraries in R.


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
