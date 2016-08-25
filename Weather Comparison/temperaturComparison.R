library(weatherData)
library(ggplot2)
city1 <- "RIX"
city2 <- "MSQ"
df1 <- getWeatherForYear(city1, 2015)
df2 <- getWeatherForYear(city2, 2015)

getDailyDifferences <- function(df1, df2){
    Delta_Means <- df1$Mean_TemperatureC - df2$Mean_TemperatureC
    Delta_Max <- df1$Max_TemperatureC - df2$Max_TemperatureC
    Delta_Min <- df1$Min_TemperatureC - df2$Min_TemperatureC
    
    diff_df <- data.frame(Date=df1$Date, Delta_Means, Delta_Max, Delta_Min)
    return(diff_df)
}

plotDifferences <- function (differences, city1, city2) {
    library(reshape2)
    m.diff <- melt(differences, id.vars=c("Date"))
    p <- ggplot(m.diff, aes(x=Date, y=value)) + geom_point(aes(color=variable)) +  
        facet_grid(variable ~ .) +geom_hline(yintercept=0)
    p <- p + labs(title=paste0("Daily Temperature Differences: ", city1, " minus ",city2))
    print(p)
}

differences<- getDailyDifferences(df1, df2)
plotDifferences(differences, city1, city2)
