#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    titlePanel("Please select a date between Jan 01 2010 and Jan 01 2020"),
    
    sidebarLayout(
        sidebarPanel(
            dateRangeInput("daterange1", "Date range:",
                           start = "2000-01-01",
                           end = "2020-01-01",
                           min = "2000-01-01",
                           max = "2020-01-01",
                           format = "yyyy/mm/dd",
                           separator = "-")
        ),
        mainPanel(
            #img(src = "https://149348465.v2.pressablecdn.com/wp-content/uploads/2016/07/hero-finance-hub.jpg"),
            plotOutput('my_plot')
        )
    )
))
