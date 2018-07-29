library(dplyr)
library(purrr)

pretty.print <- function (df, s = "1/1")
{
  data <- filter(df, series == s)
  data$type[is.na(data$type)] <- "Direction"
  cat(s)
  cat("\n")
  cat(data$episode_name[1])
  cat("\n=======================\n\n")
  for (i in 1:length(data$episode))
  {
    if (data$type[i] == "Direction")
    {
      cat("*** ")
      cat(data$detail[i])
      cat("\n\n")
    }
    else
    {
      paste(data$character[i], ":\t") %>% cat
      cat(data$detail[i])
      cat("\n\n")
    }
  }

}

unwrap <- function(x) x[[1]]

words.cleaner <- function(x)
{
  x %>% map((function(a) paste("@", a, "+"))) %>% paste(collapse=" ") %>% map(tolower) %>% unwrap %>% strsplit(" ") %>% unwrap
  # NOTE: '@' represents the beginning of strings, '+' represents the end
}
