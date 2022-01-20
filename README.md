## Population Density per City
In CityDensity.R we computed the Population Density per CityProvince. We also exported the top 5 cities with the highest population density into a csv file.

First, we import the dataset csv files:
```sh
population = read.csv("population.csv")
region_area = read.csv("regionarea.csv")
```

Next, we get the total population per city by adding all population of all the barangays in that city
```sh
# total population per city = barangay 1 in city + barangay 2 in city + ...
population_CityProvince = aggregate(population$Population, by=list(CityProvince=population$CityProvince), FUN=sum)
```


