#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Pulpit nawigacyjny. Dane: google_play_tore"),
   
   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
 #     sidebarPanel(
  #       sliderInput("bins",
 #                    "Number of bins:",
 #                    min = 1,
  #                   max = 50,
 #                    value = 30)
  #    ),
      sidebarLayout(
        sidebarPanel(
          sliderInput(inputId = "y",
                      label = "Y-axis:",
                      choices = c("Rating" = googleplaystore$Rating),
                                  #"Rating", "Size" , "Category", "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver"), 
                      selected = "Rating")
        ),
        selectInput(inputId = "x", 
                    label = "X-axis:",
                    choices = c(
                      #"Rating", 
                      "Size"  = googleplaystore$Size),
                      #"Category", "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver"), 
                    selected = "Size")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
#         plotOutput("distPlot")
         plotOutput(outputId = "scatterplot")
      )
   )


# Define server logic required to draw a histogram
server <- function(input, output) {
   
#   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
#      x    <- faithful[, 2] 
#      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
#      hist(x, breaks = bins, col = 'darkgray', border = 'white')
#   })
   output$scatterplot <- renderPlot({
     ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
       geom_point()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

