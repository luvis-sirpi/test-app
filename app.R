library(shiny)
library(ggplot2)
library(DT)

# UI
ui <- fluidPage(
    titlePanel("Interactive Data Explorer"),
    sidebarLayout(
        sidebarPanel(
            selectInput("var", "Select a variable:", 
                        choices = names(mtcars), selected = "mpg"),
            sliderInput("bins", "Number of bins:", min = 5, max = 30, value = 10),
            actionButton("update", "Update Plot")
        ),
        mainPanel(
            plotOutput("histPlot"),
            DTOutput("dataTable")
        )
    )
)

# Server
server <- function(input, output, session) {
    data <- reactive({
        mtcars[, input$var, drop = FALSE]
    })
    
    output$histPlot <- renderPlot({
        req(input$update)
        ggplot(mtcars, aes_string(input$var)) +
            geom_histogram(bins = input$bins, fill = "blue", alpha = 0.7) +
            labs(title = paste("Histogram of", input$var))
    })
    
    output$dataTable <- renderDT({
        datatable(mtcars, options = list(pageLength = 5))
    })
}

# Run App
shinyApp(ui, server)
