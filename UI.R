library("readr")
library("dplyr")
library("factoextra")
library("arules")
library("shiny")
library("shinythemes")
library("DT")

ui <- fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage(
    "Grocery Store",
    tabPanel("Data-frame",
             mainPanel(
               DTOutput("Data"),
               width = 12
             )
    ),
    tabPanel("Dashboard",
             mainPanel(
               plotOutput(outputId = "pie", height = "400px"),
               plotOutput(outputId = "plot1", height = "400px"),
               plotOutput(outputId = "plot2", height = "400px"),
               width = 12
             )
    ),
    tabPanel("Clustering", 
             sidebarLayout(
               sidebarPanel(
                 sliderInput("slide", "Select the number of clusters", min = 2, max = 4, value = 2)
               ),
               mainPanel(
                 plotOutput(outputId = "fviz_cluster", height = "500px"),
                 DTOutput("table"),
                 width = 10
               )
             )
    ),
    tabPanel("Apriori",
             sidebarLayout(
               sidebarPanel(
                 numericInput("sup", "Enter value for Support", min = 0, max = 1, value = 0.15, step = 0.01),
                 sliderInput("sup", "Select the support", min = 0, max = 1, value = 0.15, step = 0.05),
                 verbatimTextOutput("supp"),
                 
                 numericInput("con", "Enter value for Confidence", min = 0, max = 1, value = 0.15, step = 0.01),
                 sliderInput("con", "Select the Confidence", min = 0, max = 1, value = 0.15, step = 0.05),
                 verbatimTextOutput("conf")
               ),
               mainPanel(
                 DTOutput("apriori"),
                 width = 10
               )
             )
    )
  )
)
