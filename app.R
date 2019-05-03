## Best City Picker ##
## James Temoshenko and Kordell Teenie ##

library(graphics)
library(shiny)
library(dplyr)

### IMPORT RAW DATA ###

cities.data <- data.frame(read.csv("./data/uscitiestrimmed.csv"))
income.data <- data.frame(read.csv("./data/kaggle_income.csv"))

healthcare.data <- data.frame(read.csv("./data/")) #still need data
crime.data
taxes.data
housing.data
food.data #zomato data?
entertainment.data
civic.data
college.data
socialmedia.data

### PREPARE FOR SERVER ###

final.data <- select(cities.data,city,state_name,county_fips)

#income
income.data.min <- min(income.data$Mean)
income.data.max <- max(income.data$Mean)
income.data <- select(income.data,Zip_Code,Mean)

#crime
#taxes
#housing
#recreational
#entertainment
#food
#civic
#college
#socialmedia

## Final Preparations (this is the dataframe that is used in the server)
final.data <- merge(final.data, income.data, by.x="county_fips", by.y="Zip_Code")

ui <- fluidPage(titlePanel("censusVis"),
                
                sidebarLayout(
                  sidebarPanel(
                    
                    helpText("Importance of... (Lower=less important, higher=more important)"),
                    
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
                    ),
                    sliderInput(
                      "food",
                      label = "Restauraunts:",
                      min = 0,
                      max = 100,
                      value = 50
                    )
                  ),
                  
                  mainPanel(dataTableOutput('table'))
                  
                ))

server <- function(input, output) {
  
  ### Calculate scores
  
    final.data <- reactive({percent_rank(final.data$Mean) * input$income})
  
  ### Output
  output$table <- renderDataTable(final.data)
}

# Run the application
shinyApp(ui = ui, server = server)


