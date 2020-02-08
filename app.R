# NYC Data Science Academy
# R Shiny Project
# Joe Lu
# Joe.Zhou.Lu@gmail.com

library(shiny)
library(shinydashboard)
source("./global.R")

header = dashboardHeader(
    title = "Asset Allocation"
)


sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Charts", tabName = "charts", icon = icon("bar-chart-o")),
        menuItem("Charts2", tabName = "charts2", icon = icon("bar-chart-o"))
    )
)

body = dashboardBody(
    tabItems(
        # First tab content
        tabItem(tabName = "dashboard",
            dateRangeInput("daterange1", "Date range:",
                           start = "2000-01-01",
                           end = "2020-01-01",
                           min = "2000-01-01",
                           max = "2020-01-01",
                           format = "yyyy/mm/dd",
                           separator = "-")
        ),
        
        tabItem(tabName = "charts",
                h2("charts content"),
                plotOutput('my_plot')
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

    output$my_plot = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date, date_filtered_df()$Stocks_US, "U.S. Stocks")
    )
}

# Run the application 
shinyApp(ui = ui, server = server)