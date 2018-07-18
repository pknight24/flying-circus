library(dplyr)
library(markovchain)
library(RSQLite)
library(purrr)
source("episode.r")

db <- dbConnect(SQLite(), dbname="database.sqlite")

q <- dbSendQuery(db, "SELECT * FROM scripts")

data <- dbFetch(q)
data <- mutate(data, speaker = ifelse(is.na(character), "Background", "Character"))

speakers <- data$speaker
character.words <- filter(data, speaker == "Character")$detail %>% paste(collapse=" ") %>% strsplit(" ") %>% map(tolower)
background.words <- filter(data, speaker == "Background")$detail %>% paste(collapse=" ") %>% strsplit(" ") %>% map(tolower)

dbClearResult(q)
dbDisconnect(db)
