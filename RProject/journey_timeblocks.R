library(RSQLite)
library(plotly)
library(dplyr)
library(lubridate)

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

library(shiny)
ui <- fluidPage(
  sidebarPanel(sliderInput("hour", label="Hour", value = 1, min = 1, max = length(journey_timechunks)),
               p('Number of Journeys started in this period:'),
               textOutput('numberJourneys'),
               fluidRow(column(6,p('Name of chunk:')),
                        column(6,textOutput('nameOfChunk'))
                        )),
  mainPanel(tableOutput('head'))
)

server <- function(input, output, session) {
  output$head<-renderTable({journey_timechunks[input$hour]})
  output$numberJourneys<-renderText({nrow(journey_timechunks[[input$hour]])})
  output$nameOfChunk<-renderText({names(journey_timechunks)[input$hour]})
}

shinyApp(ui, server)

