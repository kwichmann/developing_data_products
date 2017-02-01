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
    return(0)
  }
  afinn[lookup,]$score[1]
}

# Replace word with sentiment span
insert_sentiment_span <- function(string, lower_word, sentiment) {
  capture <- paste0("(", lower_word, ")")
  replacement <- paste0('<span class="sentiment', as.character(sentiment), '">\\1</span>')
  gsub(capture, replacement, string, ignore.case = TRUE)
}

# Similar analysis for an entire tweet
sent_analyze <- function(tweet) {
  
  # Remove punctuation, split into lower case words and calculate sentiments
  text <- gsub('[\".,!?:;()]','', tweet)
  words <- strsplit(text, ' ')[[1]]
  lower_words <- sapply(words, tolower)
  scores <- sapply(words, sentiment)
  
  # Start with original tweet and insert spans of appropriate sentiments
  html <- as.character(tweet)
  for (i in 1:length(lower_words)) {
    sentiment <- scores[i]
    if (sentiment != 0) {
      html <- insert_sentiment_span(html, lower_words[i], sentiment)
    }
  }
  
  list(score = sum(scores), html = html)
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