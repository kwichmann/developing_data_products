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
  
  # Application title
  titlePanel("POTUS tweet sentiment analysis"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("choice", "Display",
                   c("Single tweets" = 1,
                     "Distribution" = 2,
                     "Time development" = 3)),
      sliderInput("tweet", "Select tweet (single tweet mode only)", 1, 100, 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       # plotOutput("distPlot")
    )
  )
))
