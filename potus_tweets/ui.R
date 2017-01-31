#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  # Application title
  titlePanel("POTUS tweet sentiment analysis"),
  
  # Sidebar with a slider for choosing tweet
  sidebarLayout(
    sidebarPanel(
      sliderInput("tweet", "Select tweet", 1, 321, 1)
    ),
    
    # Show tweet and sentiments
    mainPanel(
      h2(textOutput("headline")),
      uiOutput("tweetText"),
      
      h4(textOutput("sentiment")),
      
      plotOutput("histogram"),
      
      plotOutput("mean_plot")
      
    )
  )
))
