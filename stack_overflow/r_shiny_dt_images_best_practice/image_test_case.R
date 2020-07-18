library(shiny)
library(DT)


my_image_df = read.csv('image_test_case_table.csv')

# Define UI
ui <- fluidPage(
  
  fluidRow(
    
    DTOutput("my_table", width = "100%")
    
  )
  
)

# Define server
server <- function(input, output) {
  
  output$my_table = DT::renderDataTable(DT::datatable({data <- my_image_df},
                                                      escape = FALSE,
                                                      rownames = FALSE,
                                                      options = list(columnDefs = list(list(className = 'dt-center', targets = 0))),
                                                      selection = 'single'
                                                      )#datatable
                                        
                                        )#renderDataTable
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)