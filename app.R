# NYC Data Science Academy
# R Shiny Project
# Joe Lu
# Joe.Zhou.Lu@gmail.com

# Also, call the global.R helper file (my personalized library of functions)
library(shiny)
library(shinydashboard)
source("./global.R")

header = dashboardHeader(
    title = "Asset Allocation"
)

sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Choose start & end date", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Time Series Plot", tabName = "time_series_tab", icon = icon("bar-chart-o")),
        menuItem("Charts2", tabName = "charts2", icon = icon("bar-chart-o"))
    )
)

body = dashboardBody(
    tabItems(
        # First tab content
        tabItem(tabName = "dashboard",
            dateRangeInput("daterange1", "Please choose start & end dates between Sep 1999 and Jan 2020:",
                           start = "2000-01-01",
                           end = "2020-01-01",
                           min = "2000-01-01",
                           max = "2020-01-01",
                           format = "yyyy/mm/dd",
                           separator = "-")
        ),
        
        tabItem(tabName = "time_series_tab",
                h2("If you had invested $100..."),
                plotOutput('stock_growth_over_time'),
                plotOutput('tsy_growth_over_time'),
                plotOutput('gold_growth_over_time')
        ),
        
        tabItem(tabName = "charts2",
                h2("charts2 content BLAH")
        )
    )
)

# Define UI for application that draws a histogram
ui <- dashboardPage(header, sidebar, body, skin = "green")


server <- function(input, output) {
    
    date_filtered_df = reactive({
        returns_1999_2020 %>% 
            filter(Date >= input$daterange1[1] & Date <= input$daterange1[2])
    })

    output$stock_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date, date_filtered_df()$Stocks_US, "U.S. Stocks")
    )
    
    output$tsy_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date, date_filtered_df()$Bonds_Tsy_30y, "30 Year Treasuries")
    )
    
    output$gold_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date, date_filtered_df()$Gold, "Gold")
    )    
    
}

# Run the application 
shinyApp(ui = ui, server = server)