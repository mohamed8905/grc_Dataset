library("readr")
library("dplyr")
library("factoextra")
library("arules")
library("shiny")
library("shinythemes")
library("DT")

#importing dataset
grc <- read.csv("grc.csv")

ui <- navbarPage(
  theme = shinytheme("cerulean"),
  "Grocery Store",
  tabPanel("Data-frame",
           mainPanel(
             DTOutput("Data")
           )
  ),
  tabPanel("Dashboard",
           mainPanel(
             plotOutput(outputId = "pie"),
             plotOutput(outputId = "plot1"),
             plotOutput(outputId = "plot2"),
             plotOutput(outputId = "distribution")
           )
  ),
  tabPanel("Clustering", 
           sidebarPanel(
             sliderInput("slide", "Select the number of clusters", min = 2, max = 4, value = 2)
           ),
           mainPanel(
             plotOutput(outputId = "fviz_cluster"),
             DTOutput("table")
           )
  ),
  tabPanel("Apriori",
           sidebarPanel(
             numericInput("sup", "Enter value for Support", min = 0, max = 1, value = 0.15, step = 0.01),
             sliderInput("sup", "Select the support", min = 0, max = 1, value = 0.15, step = 0.05),
             verbatimTextOutput("supp"),
             
             numericInput("con", "Enter value for Confidence", min = 0, max = 1, value = 0.15, step = 0.01),
             sliderInput("con", "Select the Confidence", min = 0, max = 1, value = 0.15, step = 0.05),
             verbatimTextOutput("conf")
           ),
           mainPanel(
             DTOutput("apriori")
           )
  )
)
# to run the app
source("Server.R")
shinyApp(ui = ui, server = server)

