#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Add numericInput

#The app on the right allows users to randomly select a desired number of movies, 
#and displays some information on the selected movies in a tabular output. 
#This table is created using a new function, renderDataTable function from the DT package, 
#but for now we will keep our focus on the numericInput widget. 
#We will also learn to define variables outside of the app so that they 
#can be used in multiple spots to make our code more efficient.




# Define UI for application that draws a histogram
library(shiny)
library(dplyr)
library(DT)

load("movies.Rdata")
n_total <- nrow(movies)

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Text instructions - update reference to hardcoded sample size here
      HTML(paste("Enter a value between 1 and", n_total)),
      
      # Numeric input for sample size - define min and max
      numericInput(inputId = "n",
                   label = "Sample size:",
                   value = 30,
                   min = 1, max = n_total,
                   step = 1)
      
    ),
    
    # Output: Show data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    movies_sample <- movies %>%
      sample_n(input$n) %>%
      select(title:studio)
    DT::datatable(data = movies_sample, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)