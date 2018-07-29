library(Rcpp)
library(RSQLite)
source("helpers.r")
sourceCpp("src/markov.cpp")

###########################################################################################

db <- dbConnect(SQLite(), dbname="database.sqlite")

q <- dbSendQuery(db, "SELECT character, detail FROM scripts")

data <- dbFetch(q)
dbClearResult(q)
dbDisconnect(db)

data <- mutate(data, speaker = ifelse(is.na(character), "Background", "Character"))
speakers <- data$speaker
char.words <- filter(data, speaker == "Character")$detail %>% words.cleaner
back.words <- filter(data, speaker == "Background")$detail %>% words.cleaner

lines.seq <- function(n) predictMC(speakers, "Background", n)

char.line <- function() predictMC(char.words, "@", 100)
back.line <- function() predictMC(back.words, "@", 100)
