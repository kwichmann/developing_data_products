# Load shiny and ggplot2 libraries
library(shiny)
library(ggplot2)

# Load processed tweets
tweets <- read.csv("processed_tweets.csv", fileEncoding="UTF-8")

# Load monthly means
means <- read.csv("monthly_means.csv")

# Server function
shinyServer(function(input, output) {
  
  output$headline <- reactive({
    paste("Tweeted on ", as.character(tweets$timestamp[input$tweet]), sep = " ")
  })
  
  output$tweetText <- renderUI({
      HTML(as.character(tweets$html[input$tweet]))
  })
  
  output$sentiment <- reactive({
    paste("Sentiment score", as.character(tweets$sentiment[input$tweet]), sep = " ")
  })
  
  output$histogram <- renderPlot({
    p <- ggplot(data = tweets, aes(x = sentiment)) +
      geom_histogram(binwidth = 1) +
      geom_vline(xintercept = tweets$sentiment[input$tweet]) +
      theme(aspect.ratio=1/3)
    print(p)
  })
  
  output$mean_plot <- renderPlot({
    p <- ggplot(data = means, aes(x = as.Date(month), y = mean, group = 1)) +
      geom_smooth(se = FALSE, method = 'loess') +
      scale_x_date(date_breaks = "1 month", date_labels = "%b") +
      geom_vline(xintercept = as.numeric(as.Date(tweets$timestamp[input$tweet]))) +
      labs(x = "month", y = "average sentiment") +
      theme(aspect.ratio=1/3)
    print(p)
  })

})
