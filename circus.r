library(dplyr)
library(markovchain)
library(RSQLite)
source("episode.r")

db <- dbConnect(SQLite(), dbname="database.sqlite")

q <- dbSendQuery(db, "SELECT * FROM scripts")

data <- dbFetch(q)
pretty.print(data, s = "1/1")

dbClearResult(q)
dbDisconnect(db)
