library(weatherData)
library(ggplot2)
library(reshape2)

showAvailableColumns("RIX", "2016-08-25", opt_detailed=T)
rix<-getWeatherForDate("RIX", start_date="2016-01-01", end_date = Sys.Date(), opt_detailed=T, opt_custom_columns=T, custom_columns=c(8))
msq<-getWeatherForDate("MSQ", start_date="2016-01-01", end_date = Sys.Date(), opt_detailed=T, opt_custom_columns=T, custom_columns=c(8))


rix<-as.data.table(rix)
rix[,Wind_SpeedKm_h:=as.numeric(Wind_SpeedKm_h)]
grix<-rix[,.(Wind_SpeedKm_h_daily_mean = mean(Wind_SpeedKm_h, na.rm = T)), by=.(date=as.Date(Time))]

msq<-as.data.table(msq)
msq[,Wind_SpeedKm_h:=as.numeric(Wind_SpeedKm_h)]
gmsq<-msq[,.(Wind_SpeedKm_h_daily_mean = mean(Wind_SpeedKm_h, na.rm = T)), by=.(date=as.Date(Time))]

data<-merge(grix, gmsq, by="date", suffixes=c(".rix", ".msq"))
diff<-data[,.(date, diff=Wind_SpeedKm_h_daily_mean.rix - Wind_SpeedKm_h_daily_mean.msq)]
diff <- melt(diff, id.vars=c("date"))
ggplot(diff, aes(x=date, y=value)) + geom_line()
