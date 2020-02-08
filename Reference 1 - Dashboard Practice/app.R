
# Tutorial here: https://rstudio.github.io/shinydashboard/get_started.html


library(shiny)
library(shinydashboard)

header = dashboardHeader(
    
    title = "Basic dashboard title",
    
    dropdownMenu(type = "messages",
        messageItem(
            from = "My brain",
            message = "How does this reactive stuff work??"
        ),
        messageItem(
            from = "Santa Claus",
            message = "You are getting coal this Christmas"
        )
    )
)

sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
)

body = dashboardBody(
    tabItems(
        # First tab content
        tabItem(tabName = "dashboard",
                fluidRow(
                    box(plotOutput("plot1", height = 250)),
                    box(
                        title = "Controls",
                        sliderInput("slider", "Number of observations", 1, 100, 50)
                    )
                )
        ),
        
        tabItem(tabName = "widgets",
                h2("widgets tab content")
        )
    )
)

# Define UI for application that draws a histogram
ui <- dashboardPage(header, sidebar, body)

# Define server logic required to draw a histogram
server <- function(input, output) {
    set.seed(122)
    histdata = rnorm(500)
    
    output$plot1 = renderPlot({
        data = histdata[seq_len(input$slider)]
        hist(data)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
