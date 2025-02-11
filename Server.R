server <- function(input, output) {
  
  grc <- read.csv("grc.csv") %>% distinct(.keep_all = TRUE)
  pie_values <- round(c(sum(grc$paymentType == "Cash") * 100 / 9833, sum(grc$paymentType == "Credit") * 100 / 9833), digits = 2)
  labels <- c("Cash", "Credit")
  df_total_byAge <- grc %>% group_by(age) %>% summarise(total_spend = sum(total))
  df_total_byCity <- grc %>% group_by(city) %>% summarise(total_spend = sum(total))
  df_total_byCity = df_total_byCity %>% arrange(desc(total_spend))
  df_byname = grc %>% group_by(customer) %>% summarise(total_spend = sum(total), age = unique(age))
  df = data.frame(df_byname$age,df_byname$total_spend)
  df_scaled = scale(df)

  output$Data <- renderDataTable({grc})
  
  output$pie <- renderPlot({
    pie(pie_values, labels = paste(pie_values, "%"), col = c("red", "blue"),
        main = "Compare by Payment Type")
    
    legend("right", labels, fill = c("red", "blue"), pch = 16, cex = 2)
  })
  
  output$plot1 <- renderPlot({
    barplot(
      height = df_total_byAge$total_spend,
      name = df_total_byAge$age, 
      ylim = range(pretty(c(0,df_total_byAge$total_spend))), 
      col  = c("lightblue", "blue", "red", "orange", "green", "purple", "cyan", "gold", "pink", "brown", "yellow", "gray"),
      main = "Age and total spending plot",
      xlab = "Age",
      ylab = "Total spending"
    )
    
    legend("top", legend = paste(df_total_byAge$total_spend),
           fill = c("lightblue", "blue", "red", "orange", "green", "purple", "cyan", "gold", "pink", "brown", "yellow", "gray"),
           pch = 16, cex = 0.85, title = "Total spending", horiz = TRUE)
  })
  
  output$plot2 <- renderPlot({
    barplot(
      height = df_total_byCity$total_spend,
      name = df_total_byCity$city, 
      ylim = range(pretty(c(0,df_total_byCity$total_spend))), 
      col  = c("purple", "lightblue", "cyan", "red", "orange", "green", "blue", "gray", "gold", "pink", "brown", "yellow"),
      main = "City and total spending plot",
      xlab = "City",
      ylab = "Total spending"
    )
    
    legend("top", legend = paste(df_total_byCity$total_spend),
           fill = c("purple", "lightblue", "cyan", "red", "orange", "green", "blue", "gray", "gold", "pink", "brown", "yellow"),
           pch = 16, cex = 0.85, title = "Total spending", horiz = TRUE)
  })
  
  output$distribution <- renderPlot({
    boxplot(grc$total)
  })
  
  output$fviz_cluster <- renderPlot({
    km = kmeans(df_scaled, input$slide)
    
    km_clusters <- km$cluster
    
    rownames(df_scaled) <- paste(df_byname$customer)
    
    fviz_cluster(list(data = df_scaled, cluster = km_clusters))
  })
  
  output$table <- renderDataTable({
    df_byname = grc %>% group_by(customer) %>% summarise(total_spend = sum(total), age = unique(age))
    km = kmeans(df_scaled, input$slide)
    km_clusters <- km$cluster
    df_last = df_byname 
    df_last$cluster = km_clusters
    df_last
  })
  
  output$supp <- renderPrint({input$sup})
  output$conf <- renderPrint({input$con})
  
  output$apriori <- renderDT({
    rules <- apriori(grc, parameter = list(supp = input$sup, conf = input$con, minlen = 2))
    inspect(rules)
  })
}
