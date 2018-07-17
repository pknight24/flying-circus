library(dplyr)
library(markovchain)
library(RSQLite)

db <- dbConnect(SQLite(), dbname="database.sqlite")

q <- dbSendQuery(db, "SELECT * FROM scripts")

data <- dbFetch(q)

dbClearResult(q)
