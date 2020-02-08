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
        menuItem("Choose start & end date", tabName = "choosing_dates_tab", icon = icon("dashboard")),
        menuItem("Time Series Plot", tabName = "time_series_tab", icon = icon("chart-line")),
        menuItem("Distribution of Daily Returns", tabName = "histogram_tab", icon = icon("chart-bar"))
    )
)

body = dashboardBody(
    tabItems(
        # First tab content
        tabItem(tabName = "choosing_dates_tab",
            dateRangeInput("start_n_end_date", "Please choose start & end dates between Sep 1999 and Jan 2020:",
                           start = "2000-01-01",
                           end = "2020-01-01",
                           min = "2000-01-01",
                           max = "2020-01-01",
                           format = "yyyy/mm/dd",
                           separator = "to")
        ),
        
        tabItem(tabName = "time_series_tab",
                h2("If you had invested $100..."),
                plotOutput('stock_growth_over_time'),
                plotOutput('tsy_growth_over_time'),
                plotOutput('gold_growth_over_time')
        ),
        
        tabItem(tabName = "histogram_tab",
                h2("Daily returns of various assets..."),
                plotOutput('stock_return_histogram'),
                plotOutput('tsy_return_histogram'),
                plotOutput('gold_return_histogram')
        )
    )
)

# Define UI for application that draws a histogram
ui <- dashboardPage(header, sidebar, body, skin = "green")


server <- function(input, output) {
    
    date_filtered_df = reactive({
        returns_1999_2020 %>% 
            filter(Date >= input$start_n_end_date[1] &
                   Date <= input$start_n_end_date[2])
    })

    output$stock_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date,
                                        date_filtered_df()$Stocks_US,
                                        "U.S. Stocks",
                                        "limegreen")
    )
    
    output$tsy_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date,
                                        date_filtered_df()$Bonds_Tsy_30y,
                                        "30 Year Treasuries",
                                        "dodgerblue2")
    )
    
    output$gold_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date,
                                        date_filtered_df()$Gold,
                                        "Gold",
                                        "gold2")
    )
    
    output$stock_return_histogram = renderPlot(
        plot_returns_histogram(date_filtered_df()$Stocks_US, "U.S. Stocks",
                               outline_color = "green4", fill_color = "green3")
    )

    output$tsy_return_histogram = renderPlot(
        plot_returns_histogram(date_filtered_df()$Bonds_Tsy_30y, "30y Treasuries",
                               outline_color = "dodgerblue4", fill_color = "dodgerblue2")
    )

    output$gold_return_histogram = renderPlot(
        plot_returns_histogram(date_filtered_df()$Gold, "Gold",
                               outline_color = "gold4", fill_color = "gold3")
    )
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)