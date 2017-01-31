# Load tweets
tweets <- read.csv("potus_tweets.csv", fileEncoding="UTF-8")

# Sort by date
tweets <- tweets[order(tweets$timestamp),]

# Convert timestamps to months
tweets$timestamp <- as.Date(tweets$timestamp)
tweets$month <- as.Date(cut(tweets$timestamp, breaks = "month"))

# Load AFINN data set
afinn <- read.csv("AFINN-111.txt", sep = "\t", header = FALSE)
colnames(afinn) <- c("word", "score")

# Get sentiment score and corresponding html element for a word
sentiment <- function(word) {
  lookup <- grep(paste0("^", word, "$"), afinn$word)
  if (length(lookup) == 0) {
    return (list(score = 0, html = word))
  }
  score <- afinn[lookup,]$score[1]
  list(score = score, html = span(word, class = paste0("sentiment", score)))
}

# Similar analysis for an entire tweet
sent_analyze <- function(tweet) {
  text <- gsub('[\".,!?:;()]','', tweet)
  text <- tolower(text)
  words <- strsplit(text, ' ')[[1]]
  scores <- sapply(words, function(w) sentiment(w)$score)
  htmls <- sapply(words, function(w) as.character(sentiment(w)$html))
  list(score = sum(scores), html = paste(htmls, collapse = " "))
}

# Generate tweet matrix - takes some time :/
tweet_matrix <- sapply(tweets$text, sent_analyze)

# Insert into data frame
tweets$sentiment <- as.numeric(tweet_matrix[1,])
tweets$html <- as.character(tweet_matrix[2,])

# Write tweet csv
write.csv(tweets[, c(4, 11, 12, 13)], "processed_tweets.csv", fileEncoding="UTF-8")

# Calculate monthly averages
months <- unique(tweets$month)
mean_sentiments <- sapply(months, function(month) {
  mean(tweets[tweets$month == month, 12])
})

# Write mean sentiments csv
monthly_means <- data.frame(month = months, mean = mean_sentiments)
write.csv(monthly_means, "monthly_means.csv")