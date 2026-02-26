# Встановіть пакети, якщо ще не встановлені
# install.packages(c("shiny", "shinydashboard", "ggplot2", "dplyr"))
# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("ggplot2")
# install.packages("dplyr")

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)


dnz_data <- read.csv('cities.txt', sep = ';', header = TRUE)
cities <- read.csv("cities.txt", sep = ";", stringsAsFactors = FALSE)
View(cities)


ui <- dashboardPage(
  dashboardHeader(title = "Дашборд Міст України"),
  
  dashboardSidebar(
    sliderInput("pop_slider", "Мінімальна кількість населення (тис):",
                min = min(cities$Населення_тис),
                max = max(cities$Населення_тис),
                value = min(cities$Населення_тис),
                step = 50),
    
    sliderInput("school_slider", "Мінімальна кількість шкіл:",
                min = min(cities$Кількість_Шкіл),
                max = max(cities$Кількість_Шкіл),
                value = min(cities$Кількість_Шкіл),
                step = 5),
    
    radioButtons("plot_type", "Виберіть графік:",
                 choices = c("Населення" = "pop", "Кількість шкіл" = "schools"),
                 selected = "pop"),
    
    downloadButton("downloadData", "Завантажити дані"),
    downloadButton("downloadPlot", "Завантажити графік")
  ),
  
  dashboardBody(
    fluidRow(
      box(title = "Графік", status = "primary", solidHeader = TRUE,
          width = 12, plotOutput("mainPlot")),
      
      box(title = "Таблиця даних", status = "info", solidHeader = TRUE,
          width = 12, dataTableOutput("dataTable"))
    )
  )
)

server <- function(input, output) {
  
  
  filtered_data <- reactive({
    cities %>%
      filter(
        Населення_тис >= input$pop_slider,
        Кількість_Шкіл >= input$school_slider
      )
  })
  
  output$mainPlot <- renderPlot({
    
    data <- filtered_data()
    
    if (input$plot_type == "pop") {
      ggplot(data, aes(x = reorder(Місто, Населення_тис), y = Населення_тис)) +
        geom_col(fill = "steelblue") +
        coord_flip() +
        theme_minimal() +
        labs(x = "Місто", y = "Населення (тис)", title = "Населення міст України")
    } 
    else if (input$plot_type == "schools") {
      ggplot(data, aes(x = reorder(Місто, Кількість_Шкіл), y = Кількість_Шкіл)) +
        geom_col(fill = "darkgreen") +
        coord_flip() +
        theme_minimal() +
        labs(x = "Місто", y = "Кількість шкіл", title = "Кількість шкіл у містах України")
    }
    
  })
  
 
  output$dataTable <- renderDataTable({
    filtered_data()
  },options = list(scrollX = TRUE))
  
  
  output$downloadData <- downloadHandler(
    filename = function() { "filtered_cities.csv" },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
  
  
  output$downloadPlot <- downloadHandler(
    filename = function() { "selected_plot.png" },
    content = function(file) {
      ggsave(file, plot = last_plot(), width = 10, height = 6)
    }
  )
}

shinyApp(ui = ui, server = server)