# NYC Data Science Academy
# R Shiny Project
# Joe Lu
# Joe.Zhou.Lu@gmail.com

# Also, call the global.R helper file (my personalized library of functions)
library(shiny)
library(shinydashboard)
source("./global.R")

header = dashboardHeader(
    title = "Basic Asset Allocation"
)

sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Introduction", tabName = "introduction", icon = icon("info-circle")),
        menuItem("Choose start & end date", tabName = "choosing_dates_tab", icon = icon("dashboard")),
        menuItem("Time Series Plot", tabName = "time_series_tab", icon = icon("chart-line")),
        menuItem("Distribution of Daily Returns", tabName = "histogram_tab", icon = icon("chart-bar")),
        menuItem("Scatterplots", tabName = "scatterplot_tab", icon = icon("cloudversify")),
        menuItem("Correlation Matrix", tabName = "correlation_tab", icon = icon("table")),
        menuItem("2-Asset Return-Variance", tabName = "emf_tab1", icon = icon("chart-pie")),
        menuItem("3-Asset Return-Variance", tabName = "emf_tab2", icon = icon("chart-pie")),
        menuItem("Minimum Variance Portfolio", tabName = "min_var_tab", icon = icon("life-ring")),
        menuItem("Design Your Own Portfolio", tabName = "custom_portfolio", icon = icon("palette")),
        menuItem("About The Author", tabName = "about_author", icon = icon("user-tie"))
    )
)

body = dashboardBody(
    tabItems(
        
        tabItem(tabName = "introduction",
            h2("Introduction"),
            h4("Asset allocation is one of the most important decisions to make during your investing process."),
            img(src = "https://www.thebalance.com/thmb/TWxpp7hM7I_7qrG-FXzgYXiDMww=/2121x1414/filters:fill(auto,1)/GettyImages-469078560-5b59fa7c46e0fb0024edc32d.jpg",
                width = "40%"),
            
            h4("Some financial assets perform well during periods of rapid economic activity (for example, stocks and real estate)."),
            img(src = "https://si.wsj.net/public/resources/images/BN-WM443_3jX5Q_M_20171207112419.jpg",
                width = "40%"),
            
            h4("Others perform well during periods of slowing economic growth (government bonds of powerful countries)."),
            img(src = "https://images.bostonprivate.com/FI-101-1304.jpg",
                width = "40%"),
            h4("Yet others outperform during periods of high inflation (precious metals, TIPS)."),
            img(src = "https://g.foolcdn.com/editorial/images/448239/silver-and-gold-gettyimages-523214485.jpg",
                width = "40%"),
            
            h4("While others do well during low inflation (cash, government bonds)."),
            img(src = "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/11/20/17/istock-502911292.jpg",
                width = "40%"),
            
            h4("It is very difficult to predict which economic conditions come next.
               Thus, the best solution is to hold a well-diversified mixture of different types of assets,
               to protect your portfolio from crippling losses, no matter which way economic conditions develop."),
            img(src = "https://cdn.boulevards.com/files/2014/07/300Storm-Surfers1.jpg",
                width = "40%")
        ),
        
        tabItem(tabName = "choosing_dates_tab",
            dateRangeInput("start_n_end_date", "Please choose start & end dates between Jan 2002 and Jan 2020:",
               start = "2002-01-01",
               end = "2020-01-01",
               min = "2000-01-01",
               max = "2020-01-01",
               format = "yyyy/mm/dd",
               separator = "to"),
            h4("This dataset runs through one of the worst financial crises in the history of United States,
               so this is a particularly effective demonstration of how to keep your portfolio stable through chaos"),
            img(src = "https://i.insider.com/56a8e95a58c32397008b5943?width=1100&format=jpeg",
                width = "70%"),
            h4("In this case study, we have 7 asset types, but we will only really need 4-5 of them:"),
            tags$div(tags$ul(
                tags$li(tags$span("U.S. stocks (estimated using market-cap weighted ETFs such as SPY or VOO")),
                tags$li(tags$span("Developed market stocks (stocks from Western Europe, Japan, Canada, Australia, etc)")),
                tags$li(tags$span("Emerging market stocks (stocks from China, Brazil, Russia, South Africa, etc)")),
                tags$li(tags$span("Real estate investment trusts (reflecting the U.S. housing market)")),
                tags$li(tags$span("30 year U.S. Treasuries (U.S. government bonds with a maturity of 20+ years)")),
                tags$li(tags$span("Gold (with ~0.3% expense annually to hold, estimated using GLD and IAU)")),
                tags$li(tags$span("Energy stocks (stocks in companies such as Exxon, Chevron, etc)"))
            ))
            
        ),
        
        tabItem(tabName = "time_series_tab",
            h2("If you had invested $100..."),

            textOutput('stock_key_metrics'),
            plotOutput('stock_growth_over_time'),
            
            textOutput('REIT_key_metrics'),
            plotOutput('REIT_growth_over_time'),
            
            textOutput('EM_stock_key_metrics'),
            plotOutput('EM_stock_growth_over_time'),
            
            textOutput('tsy_key_metrics'),
            plotOutput('tsy_growth_over_time'),
            
            textOutput('gold_key_metrics'),            
            plotOutput('gold_growth_over_time')
        ),
        
        tabItem(tabName = "histogram_tab",
            h2("Daily returns of various assets..."),
            
            plotOutput('stock_return_histogram'),
            
            plotOutput('REIT_return_histogram'),
            
            plotOutput('EM_stock_return_histogram'),
            
            plotOutput('tsy_return_histogram'),
            
            plotOutput('gold_return_histogram')
        ),
        
        tabItem(tabName = "scatterplot_tab",
            h2("Scatterplot of Daily Returns"),
            h4("The long-run return of the U.S. stock market is 8-10%,
                which makes it one of the best instruments to build wealth.
                But as you can see, the volatility is also quite high,
                sometimes with daily losses of 10% and annual losses of 45%.
                So how can we hedge against such massive drawdowns in stocks?"),
            plotOutput('stock_vs_REIT'),
            plotOutput('stock_vs_EM'),
            plotOutput('stock_vs_gold'),
            plotOutput('stock_vs_tsy')
        ),
        
        tabItem(tabName = "correlation_tab",
            h2("Correlation Matrix"),
            h4("We observe that gold has close to zero correlation to other assets,
               while U.S. Treasuries have a strong negative correlation vs. U.S. stocks.
               Adding Treasuries to a stock portfolio lowers risk (volatility),
               but what happens to returns?"),
            plotOutput('correlation_heatmap')
        ),
        
        tabItem(tabName = "emf_tab1",
            h2("U.S. Stocks vs Treasuries: Return-Variance Tradeoff"),
            h4("If we start with a 100% portfolio of Treasuries and add some stocks,
               the variance goes down while the return goes up.
               These are suboptimal points that we should never invest in.
               However, after the stock allocation in the portfolio goes above ~50%,
               the variance starts to drift upward as the penalty for increasing your returns even more"),
            plotOutput('plot_emf1')
        ),
        
        tabItem(tabName = "emf_tab2",
            h2("U.S. Stocks, Treasuries, and Gold: Return-Variance Tradeoff"),
            h4("If we randomly generate portfolio allocations of U.S. stocks, Treasuries, and gold
                that add up to 100%, instead of a curved line, we get a \"moon\" shaped area.
                We would never choose the points on the right side; we would always pick
                a portfolio allocation that hugs the top part of the curved barrier on the left"),
            plotOutput('plot_emf2')
        ),
        
        tabItem(tabName = "min_var_tab",
            h2("Min Variance Portfolio"),
            h4("What if we were really risk-averse and close to retirement?
               And capital preservation were our top priority?
               Let's find the portfolio that minimizes the daily fluctation
               of our portfolio"),
            plotOutput('plot_min_var_Bar'),
            textOutput('min_var_key_metrics'), 
            plotOutput('plot_min_var_growth'),
            plotOutput('plot_min_var_hist')
            
        ),
        
        tabItem(tabName = "custom_portfolio",
            h2("Design Your Own Portfolio"),
            h4("Long story short: Allocating some portion of your  portfolio out of stocks and into
                long-duration Treasuries and gold can reduce your portfolio risk,
                while sacrificing returns.  Ultimately, you need to choose a portfolio that suits
                your return targets, risk tolerance, and investment horizon.
                On this page you can enter weights adding up to 100% and observe how it would have performed.
                (Disclaimer: past performance does not predict future returns.)"),
            numericInput(inputId = "US_stock_weight", "U.S. Stocks (%)", value = 30,
                         min = 0, max = 100, step = 5),
            numericInput(inputId = "Dev_stock_weight", "Developed stocks (%)", value = 10,
                         min = 0, max = 100, step = 5),
            numericInput(inputId = "EM_stock_weight", "EM Stocks (%)", value = 10,
                         min = 0, max = 100, step = 5),
            numericInput(inputId = "REITs_weight", "Real Estate (%)", value = 10,
                         min = 0, max = 100, step = 5),
            numericInput(inputId = "Bond_30y_weight", "U.S. Treasuries (%)", value = 25,
                         min = 0, max = 100, step = 5),
            numericInput(inputId = "Gold_weight", "Gold (%)", value = 10,
                         min = 0, max = 100, step = 5),
            numericInput(inputId = "Energy_stock_weight", "Energy stocks (%)", value = 5,
                         min = 0, max = 100, step = 5),
            textOutput('custom_key_metrics'),
            plotOutput('custom_growth_over_time'),
            plotOutput('custom_histogram')
        ),
        
        tabItem(tabName = "about_author",
            h2("About The Author: Joe Lu"),
            h4("Background"),
            tags$div(tags$ul(
                tags$li(tags$span("NYC Data Science Academy")),
                tags$li(tags$span("Seven Years of Front Office Financial Industry Experience")),
                tags$li(tags$span("M.S. Computational Finance, Carnegie Mellon")),
                tags$li(tags$span("B.A. Mathematics & Economics, Cornell University"))            
            )),            
            h4("Contact"),
            tags$div(tags$ul(
                tags$li(tags$span("GitHub: https://github.com/jzl4/")),
                tags$li(tags$span("Linkedin: https://www.linkedin.com/in/joe-lu-44945114/")),
                tags$li(tags$span("Email: Joe.Zhou.Lu@gmail.com"))            
            )),
            h4("Tools Used"),
            tags$div(tags$ul(
                tags$li(tags$span("R: Shiny Dashboard, dplyr, tidyr, ggplot2, quadprog, corrplot")),
                tags$li(tags$span("Data from: yahoo finance")),
                tags$li(tags$span("References: Modern Portfolio Theory / Capital Asset Pricing Model,
                                  Risk-Parity / All-Weather Portfolio Theory (particularly AQR and Bridgewater)"))
            ))            
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
    
    df3 = reactive({
        date_filtered_df() %>%
            select(Stocks_US,
                   Stocks_Developed,
                   Stocks_EM,
                   REITs,
                   Stocks_Energy,
                   Gold,
                   Bonds_Tsy_30y)
    })
    
    df4 = reactive({
        date_filtered_df() %>%
            select(Date, Stocks_US, Bonds_Tsy_30y)
    })
    
    df5 = reactive({
        date_filtered_df() %>%
            select(Date, Stocks_US, Bonds_Tsy_30y, Gold)
    })
    
    min_var_weights = reactive({
        calculate_min_var_portfolio(date_filtered_df(),
                                    print_description = TRUE)
    })
    
    min_var_returns = reactive({
        calculate_portfolio_returns(min_var_weights(), date_filtered_df())
    })

    #EEEEEEEEEEEEEEEEEEEEEE
    custom_returns = reactive({
        calculate_portfolio_returns(
            c(input$US_stock_weight/100,
              input$Dev_stock_weight/100,
              input$EM_stock_weight/100,
              input$REITs_weight/100,
              input$Bond_30y_weight/100,
              input$Gold_weight/100,
              input$Energy_stock_weight/100),
             date_filtered_df())
    })


####################################################################
    
    output$stock_key_metrics = renderText({
        print_key_metrics("U.S. Stocks",
                          date_filtered_df()$Stocks_US,
                          input$start_n_end_date[1],
                          input$start_n_end_date[2])
    })
    
    output$REIT_key_metrics = renderText({
        print_key_metrics("REITs",
                          date_filtered_df()$REITs,
                          input$start_n_end_date[1],
                          input$start_n_end_date[2])
    })    
    
    output$EM_stock_key_metrics = renderText({
        print_key_metrics("E.M. Stocks",
                          date_filtered_df()$Stocks_EM,
                          input$start_n_end_date[1],
                          input$start_n_end_date[2])
    })
    
    output$tsy_key_metrics = renderText({
        print_key_metrics("U.S. Treasuries",
                          date_filtered_df()$Bonds_Tsy_30y,
                          input$start_n_end_date[1],
                          input$start_n_end_date[2])        
    })

    output$gold_key_metrics = renderText({
        print_key_metrics("Gold",
                          date_filtered_df()$Gold,
                          input$start_n_end_date[1],
                          input$start_n_end_date[2])        
    })
    
    output$stock_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date,
                                        date_filtered_df()$Stocks_US,
                                        "U.S. Stocks",
                                        "limegreen")
    )
    
    output$REIT_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date,
                                        date_filtered_df()$REITs,
                                        "REITs",
                                        "orangered2")
    )    
    
    output$EM_stock_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(date_filtered_df()$Date,
                                        date_filtered_df()$Stocks_EM,
                                        "EM Stocks",
                                        "turquoise4")
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

    output$REIT_return_histogram = renderPlot(
        plot_returns_histogram(date_filtered_df()$REITs, "REITs",
                               outline_color = "orangered3", fill_color = "orangered1")
    )
    
    output$EM_stock_return_histogram = renderPlot(
        plot_returns_histogram(date_filtered_df()$Stocks_EM, "E.M. Stocks",
                               outline_color = "turquoise4", fill_color = "turquoise3")
    )
    
    output$tsy_return_histogram = renderPlot(
        plot_returns_histogram(date_filtered_df()$Bonds_Tsy_30y, "30y Treasuries",
                               outline_color = "dodgerblue4", fill_color = "dodgerblue2")
    )

    output$gold_return_histogram = renderPlot(
        plot_returns_histogram(date_filtered_df()$Gold, "Gold",
                               outline_color = "gold4", fill_color = "gold3")
    )
    
    output$stock_vs_REIT = renderPlot(
        plot_scatter_of_returns(date_filtered_df()$Stocks_US,
                                date_filtered_df()$REITs,
                                "U.S. Stocks", "REITs")
    )    
    
    output$stock_vs_EM = renderPlot(
        plot_scatter_of_returns(date_filtered_df()$Stocks_US,
                                date_filtered_df()$Stocks_EM,
                                "U.S. Stocks", "EM Stocks")
    )
    
    output$stock_vs_tsy = renderPlot(
        plot_scatter_of_returns(date_filtered_df()$Stocks_US,
                                date_filtered_df()$Bonds_Tsy_30y,
                                "U.S. Stocks", "30y Treasuries")        
    )
    
    output$stock_vs_gold = renderPlot(
        plot_scatter_of_returns(date_filtered_df()$Stocks_US,
                                date_filtered_df()$Gold,
                                "U.S. Stocks", "Gold")          
    )
    
    output$correlation_heatmap = renderPlot(
        plot_correlation_heatmap(df3())
    )
    
    output$plot_emf1 = renderPlot(
        plot_efficient_market_frontier(df4(), n_points = 10000)
    )
    
    output$plot_emf2 = renderPlot(
        plot_efficient_market_frontier(df5(), n_points = 10000)
    )
    
    output$plot_min_var_Bar = renderPlot(
        plot_min_var_bar(date_filtered_df(), min_var_weights())
    )

    output$min_var_key_metrics = renderText({
        print_key_metrics("Min Var Portfolio",
                          min_var_returns()$portfolio_returns,
                          input$start_n_end_date[1],
                          input$start_n_end_date[2])        
    })
    
    output$plot_min_var_growth = renderPlot(
        plot_portfolio_growth_over_time(min_var_returns()$Date,
                                        min_var_returns()$portfolio_returns,
                                        "Min Var Porfolio",
                                        "darkviolet")
    )
    
    output$plot_min_var_hist = renderPlot(
        plot_returns_histogram(min_var_returns()$portfolio_returns,
                               "Min Var Porfolio",
                               outline_color = "purple4", fill_color = "purple2")    
    )
    
    output$custom_key_metrics = renderText({
        print_key_metrics("Custom Portfolio",
                          custom_returns()$portfolio_returns,
                          input$start_n_end_date[1],
                          input$start_n_end_date[2])        
    })    

    output$custom_growth_over_time = renderPlot(
        plot_portfolio_growth_over_time(custom_returns()$Date,
                                        custom_returns()$portfolio_returns,
                                        "Custom Portfolio",
                                        "tomato2")
    )
    
    output$custom_histogram = renderPlot(
        plot_returns_histogram(custom_returns()$portfolio_returns,
                               "Custom Porfolio",
                               outline_color = "tomato4",
                               fill_color = "tomato2")
    )
}

# Run the application 
shinyApp(ui = ui, server = server)

