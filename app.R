## Best City Picker ##
## James Temoshenko and Kordell Teenie ##

library(graphics)
library(shiny)
library(dplyr)

### Import ###

cities.data <- data.frame(read.csv("./data/uscitiestrimmed.csv"))

healthcare.data

income.data <- data.frame(read.csv("./data/kaggle_income.csv"))
crime.data
taxes.data
housing.data
recreational.data
entertainment.data
civic.data
college.data

### Prepare ###

income.min <- min(income.data$Mean)
income.max <- max(income.data$Mean)
income.data <- select(income.data,City,State,Zip,Mean)
income.data %>% sapply(income.data$Mean, function(x){x-mean(x)})

ui <- fluidPage(titlePanel("censusVis"),
                
                sidebarLayout(
                  sidebarPanel(
                    helpText("Importance of..."),
                    
                    sliderInput(
                      "healthcare",
                      label = "Healthcare: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "income",
                      label = "Median Income: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "crime",
                      label = "Crime Rate: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "taxes",
                      label = "State & City Taxes: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "housing",
                      label = "Housing Cost: ",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "recreational",
                      label = "Recreational Score:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "entertainment",
                      label = "Entertainment Score:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "civic",
                      label = "Civic Score:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "college",
                      label = "College Ratings:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    
                    sliderInput(
                      "socialmedia",
                      label = "Social Media Sentiment: ",
                      min = 0,
                      max = 100,
                      value = 50
                    )
                  ),
                  
                  mainPanel(dataTableOutput('table'))
                ))


server <- function(input, output) {
  
  ### Calculate scores
  
  ### Format table
  
  ### Output
  output$table <- renderDataTable(cities.data)
}

# Run the application
shinyApp(ui = ui, server = server)


