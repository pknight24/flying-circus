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

runMain(speakers, char.words, back.words);
