# Load shiny library
library(shiny)

# Load tweets
tweets <- read.csv("potus_tweets.csv", fileEncoding="UTF-8")

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

# Server function
shinyServer(function(input, output) {
  
  output$headline <- reactive({
    paste("Tweet number", as.character(input$tweet), sep = " ")
  })
  output$tweetText <- reactive({
    sent_analyze(tweets$text[input$tweet])$html
  })

})
