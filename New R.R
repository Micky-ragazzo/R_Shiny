
library(shiny)
library(ggplot2)
library(DT)
library(dplyr)

#n_total <- nrow(df)
all_genres <- sort(unique(df$Genres))

#setting criteria date 
min_date <- min(df$Last.Updated)
max_date <- max(df$Last.Updated)
# Define UI for application that plots features of movies 
ui <- fluidPage(
  
  titlePanel("Dashboard of google play"),
  
  # Sidebar layout with a input and output definitions 
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Rating", "Size" , "Category", "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver", "Android.Ver"), 
                  selected = "Category"),
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Rating", "Size" , "Category", "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver", "Android.Ver"), 
                  selected = "Installs"),
      selectInput(inputId = "z", 
                  label = "Color: by",
                  choices = c("Rating", "Size" , "Category", "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver", "Android.Ver"),
                  selected = "Type"),
      sliderInput(inputId = "alpha",
                  label = "View Scale:",
                  min = 0, max = 1,
                  value = 0.1),
      selectInput(inputId = "Genres",
                  label = "Select genres:",
                  choices = all_genres,
                  selected = "Social",
                  multiple = TRUE),
      HTML(paste0("Last updated. Pick dates between ", 
                  min_date, " and ", max_date, ".")),
      
      # Break for visual separation
      br(), br(),
      
      # Date input
      dateRangeInput(inputId = "date",
                     label = "Select dates:",
                     start = "2013-01-01", end = "2014-01-01",
                     min = min_date, max = max_date,
                     startview = "year")
    )
    
      
 #     HTML(paste("Enter a value between 1 and", n_total)),
#      selectInput(inputId = "n",
  #                 label = "Sample size:",
   #                value = 30,
  #                 min = 1, max = n_total,
   #                step = 1)
    ),
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      plotOutput(outputId = "densityplot", height = 200),
      DT::dataTableOutput(outputId = "df_table")
    )
  )
)



# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = df, aes_string(x = input$x, y = input$y, 
                                 color = input$z)) +
      geom_point(alpha = input$alpha)
  })
  output$densityplot <- renderPlot({
    ggplot(data = df, aes_string(x = input$x)) +
      geom_density()
  })
  output$df_table <- DT::renderDataTable({
    req(input$Genres)
    df_sample <- df %>%
      filter(Genres %in% input$Genres) %>%
#      sample_n(input$n, input$Genres) %>%
      select(Price:Genres)
      DT::datatable(data = df_sample, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
    
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
