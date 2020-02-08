#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  date_filtered_df = reactive({
    returns_1999_2020 %>% 
      filter(Date >= input$daterange1[1] & Date <= input$daterange1[2])
  })
  
  ### Checks the type of this input variable when the user changes it, good for debugging
  observe({
  # print(input$daterange1[1])
    print(date_filtered_df())
  })

  output$my_plot = renderPlot(
      # So I was wrong, the dateRangeInput does return objects of type Date. However,
      # the widget data is stored in the variable input$daterange which is a vector of
      # two dates. There is not input$start and input$end which was producing the error.

    plot_portfolio_growth_over_time(date_filtered_df()$Date, date_filtered_df()$Stocks_US, "U.S. Stocks")
  )
})
