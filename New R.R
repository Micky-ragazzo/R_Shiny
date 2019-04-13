
library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
#gg <- crosstab(df, row.vars = "Category", col.vars = "Type", type = "f")
#n_total <- nrow(df)
# > output <- read.table("~/GitHub/R_Shiny1/output.txt", quote="\"", comment.char="")
# 
#               > output <- read_table("output.txt", na = "empty")
#               Parsed with column specification:
#                 cols(
#                   X1 = col_character(),
#                   Type = col_logical(),
#                   `0` = col_double(),
#                   Free = col_double(),
#                   `NaN` = col_double(),
#                   Paid = col_double(),
#                   Sum = col_double()
#                 )

all_genres <- sort(unique(df$Genres))

#setting criteria date 
min_date <- min(as.numeric(df$Last.Updated))
max_date <- max(as.numeric(df$Last.Updated))

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
                  choices = c("Type", "Free", "Paid" , "Sum"), #, "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver", "Android.Ver"), 
                  selected = "Type"),
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Free", "Paid" , "Sum"), #, "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver", "Android.Ver"), 
                  selected = "Free"),
      selectInput(inputId = "z", 
                  label = "Color: by",
                  choices = c("Type", "Free", "Paid", "Sum"), #, "Category", "Installs", "Type", "Price", "Content.Rating", "Genres", "Last.Updated", "Current.Ver", "Current.Ver", "Android.Ver"),
                  selected = "Paid"),
      sliderInput(inputId = "alpha",
                  label = "View Scale:",
                  min = 0, max = 1,
                  value = 0.99),
      selectInput(inputId = "Genres",
                  label = "Select genres:",
                  choices = all_genres,
                  selected = "Social",
                  multiple = TRUE)
      # ,HTML(paste0("Last updated. Pick dates between ",
      #             min_date, " and ", max_date, ".")),
      
      # Break for visual separation
      # br(), br(),
      
      # Date input
      # dateRangeInput(inputId = "date",
      #                label = "Select dates:",
      #                start = "2015-01-01", end = "2019-01-01",
      #                min = min_date, max = max_date,
      #                startview = "year")
      # 
    
      
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
      
      # ,plotOutput(outputId = "scatterplot")
      
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = CT, aes_string(x = input$x, y = input$y, 
                                 color = input$z)) +
      geom_point(alpha = input$alpha)
  })
  output$densityplot <- renderPlot({
    ggplot(data = CT, aes_string(x = input$x)) +
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
  #   output$scatterplot <- renderPlot({
  #       req(input$date)
  #       df_selected_date <- df %>%
  #        # mutate(as.numeric(Last.Updated) = as.Date(as.numeric(Last.Updated))) %>% # convert thtr_rel_date to Date format
  #         filter(as.numeric(Last.Updated) >= input$date[1] & as.numeric(Last.Updated) <= input$date[2])
  #       ggplot(data = df_selected_date, aes(x = Genres, y = Rating, color = Type)) +
  #         geom_point()
  #     
  # })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)

#https://www.kaggle.com/nursah/data-visualization
#https://campus.datacamp.com/courses/building-web-applications-in-r-with-shiny/inputs-outputs-and-rendering-functions?ex=8
#https://www.academia.edu/38348726/RNotesForProfessionals.pdf
