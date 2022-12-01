library(RSQLite)
library(plotly)
library(dplyr)
Sys.setenv('MAPBOX_TOKEN' = 'pk.eyJ1Ijoid29lc3RtYW5uIiwiYSI6ImNsYTVuYTdiNjFkbzAzbm9qdzd3MWFia2MifQ.6-6AftgPW8gUGnAKwaoyig')

# Load Stations
stations<-read.table('bicikle_scraper_output/ljubljana_station_data_static.csv',sep=',',header=T)

# Load Journeys
conn <- dbConnect(RSQLite::SQLite(), "bicikle_scraper_output/20221015_journeys.db")
journeys<-dbGetQuery(conn, "SELECT * FROM Journeys")

journeys_grouped_by_start_station<-dbGetQuery(conn, "SELECT stationStart AS Number, COUNT(*) AS count FROM Journeys GROUP BY stationStart")

stations_with_count<-merge(stations,journeys_grouped_by_start_station,by='Number')

stations_sized_by_startStation<-plot_mapbox(stations_with_count) %>%
  add_segments(x = -100, xend = -50, y = 50, yend = 75) %>%
  layout(
    mapbox = list(
      style="dark",
      zoom=11,
      center= list(lon=14.5,lat=46.05)))  %>%
  add_markers(
    x = ~Longitude, 
    y = ~Latitude, 
    size = ~count, 
    #color = ~country.etc,
    colors = "Accent",
    text = ~Name,
    hoverinfo = "text"
  )


journeys_grouped <- journeys %>% group_by(stationStart,stationEnd) %>% 
  summarise(total_count=n(),.groups = 'rowwise') %>%
  as.data.frame()
# Repopulate with Lon and Lat
grouped_journeys_with_additional_info_start<-merge(journeys_grouped,stations[c('Number','Latitude','Longitude')],by.x='stationStart',by.y='Number',suffixes = c('.start','.y'))
colnames(grouped_journeys_with_additional_info_start)<-c("stationStart", "stationEnd" ,  "total_count" , "start_lat" , "start_lon" )
grouped_journeys_with_additional_info_start<-merge(grouped_journeys_with_additional_info_start,stations[c('Number','Latitude','Longitude')],by.x='stationEnd',by.y='Number')
colnames(grouped_journeys_with_additional_info_start)<-c("stationEnd" , "stationStart", "total_count" , "start_lat"  ,  "start_lon"   , "end_lat"  ,   "end_lon"   )

grouped_journeys_with_additional_info_start<-grouped_journeys_with_additional_info_start[grouped_journeys_with_additional_info_start$total_count>15,]
journey_map<-plot_mapbox(stations) %>%
  layout(
    mapbox = list(
      style="dark",
      zoom=11,
      center= list(lon=14.5,lat=46.05)))  %>%
  add_markers(
    x = ~Longitude, 
    y = ~Latitude, 
    #size = ~count, 
    colors = "Accent",
    text = ~Name,
    hoverinfo = "text"
  ) %>% add_segments(
    data = grouped_journeys_with_additional_info_start,
    x = ~start_lon, xend = ~end_lon,
    y = ~start_lat, yend = ~end_lat,
    alpha = 0.3, 
    size = ~total_count, 
    hoverinfo = "text"
  )


journey_map