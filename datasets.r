library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)

# Define the user interface
ui <- dashboardPage(
  dashboardHeader(title = "Dataset Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Datasets", tabName = "datasets", icon = icon("table")),
      menuItem("Plots", tabName = "plots", icon = icon("bar-chart"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "datasets", 
              fluidRow(
                box(width=10,
                  title = "Select a dataset", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  selectInput("dataset", "Select a dataset:", 
                              choices = c("mtcars" , "iris" , "ToothGrowth"))
                )
              ),
              fluidRow(
                box(width=10,
                  dataTableOutput("table")
                )
              )
      ),
      tabItem(tabName = "plots", 
              fluidRow(
                box(width=7,
                  title = "Select a plot type", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  selectInput("plot_type", "Select a plot type:",
                              choices = c("Scatter Plot" , "Line Plot", "Bar Plot"))
                )
              ),
              fluidRow(
                box(width=7,
                  plotOutput("plot")
                )
              )
      )
    )
  )
)

server <- function(input, output) {
  
  # Reactive dataset
  dataset <- reactive({
    switch(input$dataset,
           "mtcars" = mtcars,
           "iris" = iris,
           "ToothGrowth" = ToothGrowth)
  })
  
  # Reactive plot
  plot <- reactive({
    switch(input$dataset,
           "mtcars" = ggplot(data = mtcars) + 
             geom_point(mapping = aes(x = wt, y = mpg)),
           "iris" = ggplot(data = iris) + 
             geom_line(mapping = aes(x = Sepal.Width, y = Sepal.Length)),
           "ToothGrowth" = ggplot(data = ToothGrowth) + 
             geom_bar(mapping = aes(x = len, y = supp), stat = "identity"))
  })
  
  # Render the table
  output$table <- renderDataTable({
    data = dataset( )
  })
  
  # Render the plot
  output$plot <- renderPlot({
    plot()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
