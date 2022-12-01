library(RSQLite)
conn <- dbConnect(RSQLite::SQLite(), "/Users/felix/Downloads/bike_observations.db")
observations<-dbGetQuery(conn, "SELECT Timestamp, Count(*) as count FROM BikeObservations GROUP BY Timestamp")

