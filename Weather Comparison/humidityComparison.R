library(weatherData)
library(plyr)
#getStationCode("RIGA")
cities_to_compare <- c("RIX", "MSQ")


getHumidity <- function (city_code, date_string, end_date_string) {
    hdf <- getWeatherForDate(city_code, date_string, end_date_string, 
                             opt_detailed=TRUE,
                             opt_custom_columns=T, custom_columns=4)
    #add one column that helps identify the city.
    # This is needed so that city name is retained 
    # when we stack data frames vertically
    hdf$Station <- city_code
    return(hdf)
}


humidity_df <- ldply(cities_to_compare, getHumidity, "2016-08-20", "2016-08-25")
dim(humidity_df)

ggplot(humidity_df, aes(x=Time, y=Humidity)) + 
    geom_line(aes(color=Station)) +
    labs(title="Humidity Values")
