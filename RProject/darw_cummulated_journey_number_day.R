library(RSQLite)
library(plotly)
library(dplyr)
library(lubridate)
library(glue)
# Load Stations
stations<-read.table('bicikle_scraper_output/ljubljana_station_data_static.csv',sep=',',header=T)

# Load Journeys
conn <- dbConnect(RSQLite::SQLite(), "bicikle_scraper_output/20221015_journeys.db")
journeys<-dbGetQuery(conn, "SELECT * FROM Journeys")


journeys$timestampStart=ymd_hms(journeys$timestampStart)
journeys$timestampEnd=ymd_hms(journeys$timestampEnd)

from=round(min(journeys$timestampStart),"hour")-hours(1)
to=round(max(journeys$timestampStart),"hour")+hours(1)
breaks=seq(from, to, by="30 min")
journey_timechunks<-split(journeys,cut(journeys$timestampStart, breaks))
rows<-lapply(journey_timechunks, nrow)
names(rows)<-lapply(names(rows),function(element) { glue('{mday(element)}.{month(element)}.{year(element)} {hour(element)}:{minute(element)}') })

library(shiny)

ui <- fluidPage(
  sidebarPanel(sliderInput("hour", label="Hour", min = 1, max = length(rows),value = c(1, 2))),
  mainPanel(plotOutput('plot'))
)

server <- function(input, output, session) {
  output$plot<-renderPlot({
    rangeFrom<-input$hour[1]
    rangeTo<-input$hour[2]
    subList<-rows[rangeFrom:rangeTo]
    barplot(unlist(subList))
    })
}

shinyApp(ui, server)

