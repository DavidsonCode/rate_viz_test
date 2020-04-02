#https://plotly-r.com/linking-views-with-shiny.html
#17.1
#https://plotly.com/r/filter/ worked
#https://plotly.com/r/aggregations/#basic-example

library(shiny)
library(plotly)

snbml <- read.csv("scraped_rates_test_3.csv")
snbml$dater <- as.Date(snbml$date, format="%m/%d/%Y")

ui <- fluidPage(
  selectizeInput(
    inputId = "types",
    label = "Select a type",
    choices = unique(snbml$Type),
    selected = "Fixed",
    multiple = TRUE
  ),
  selectizeInput(
    inputId = "lenders",
    label = "Select a lender",
    choices = unique(snbml$Lender),
    selected = "Desjardins",
    multiple = TRUE
  ),
  plotlyOutput(outputId = "p")
    
)

server <- function(input, output, ...) {
  output$p <- renderPlotly({
    plot_ly(
      type = 'scatter',
      mode = 'lines',
      x = snbml$dater,
      y = snbml$rate,
      transforms = list(
        list(
          type = 'filter',
          target = snbml$Type,
          operation = '=',
          value = input$types
        ),
        list(
          type = 'filter',
          target = snbml$Lender,
          operation = '=',
          value = input$lenders
        ),
        list(
          type = 'aggregate',
          groups = snbml$dater,
          aggregations = list(
            list(
              target = 'y', func = 'sum', enabled = 'T'
            )
          )
        )
      )
      
    )
    
  })
}

shinyApp(ui = ui, server = server)
