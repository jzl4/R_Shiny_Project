
# Libraries that we need to use
library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)

###############################################################
# FUNCTIONS
###############################################################

# Help functions
source("C:\\MAIN\\NYCDSA\\R Shiny Project\\Shiny_Project_Functions.R")

# Read in the file and look at some descriptive statistics
file_name = "C:\\MAIN\\NYCDSA\\R Shiny Project\\Data_All_Assets_Compiled.xlsx"
returns_1999_2020 = read_excel(file_name, sheet = "Raw_Returns")

###############################################################
# FIRST GLANCE AT THE DATA
###############################################################

# Take a look at the data
head(returns_1999_2020, n = 10)

# Check for missing values
sum(is.na(returns_1999_2020))

# Check for outlier values
summary(returns_1999_2020)
# We notice that there was a day where REITs lost 19.3% and
#   U.S. stocks lost 9.8%.  Which day(s) were this?
worst_loss_stocks_US = min(returns_1999_2020$Stocks_US)
worst_loss_stocks_US
row_with_worst_loss_stocks_US = returns_1999_2020[(returns_1999_2020$Stocks_US == worst_loss_stocks_US),]
row_with_worst_loss_stocks_US
# Oct 15th, 2008 saw U.S. stocks decline by 9.8%, REITs decline
#   by 12.6%, and energy sector decline by 15%
# Read more about the atmosphere at that time here:
#   https://money.cnn.com/2008/10/15/markets/markets_newyork/

###############################################################
# TOTAL RETURN, PORTFOLIO GROWTH, HISTOGRAM
###############################################################

start_date = ymd("2000-08-01")
end_date = ymd("2020-01-01")

df = returns_1999_2020 %>% filter(Date >= start_date &
                                  Date <= end_date)

# Calculate the cumulative return of various assets

print_key_metrics("U.S. Stocks", df$Stocks_US, start_date, end_date)
print_key_metrics("E.M. Stocks", df$Stocks_EM, start_date, end_date)
print_key_metrics("30y Treasuries", df$Bonds_Tsy_30y, start_date, end_date)
print_key_metrics("Gold", df$Gold, start_date, end_date)

# Plot how $100 invested in assets would grow over this period
plot_portfolio_growth_over_time(df$Date, df$Stocks_US, "U.S. Stocks")
plot_portfolio_growth_over_time(df$Date, df$Bonds_Tsy_30y, "30y Treasuries")
plot_portfolio_growth_over_time(df$Date, df$Gold, "Gold")

# Plot histogram of daily returns for various assets
plot_returns_histogram(df$Stocks_US, "U.S. Stocks")
plot_returns_histogram(df$Bonds_Tsy_30y, "30y Treasuries")
plot_returns_histogram(df$Gold, "Gold")

###############################################################
# SELECT ASSETS AND DRAW EFFICIENT MARKET FRONTIER
###############################################################

# Select a subset of assets and plot the efficient market frontier
df2 = df %>% select(Date, Stocks_US, Bonds_Tsy_30y)
generate_EMF(df2, 10000)

###############################################################
# SOLVING FOR MIN VAR PORTFOLIO
###############################################################

# Calculate the portfolio weights with the min variance
#   over this period of time
min_var_weights = calculate_min_var_portfolio(df,
                  print_description = TRUE,
                  plot_bar_chart = TRUE)

# Calculate daily returns of min_var portfolio
min_var_returns = generate_portfolio_returns(min_var_weights, df)

# Calculate cumulative return of min_var portfolio
calculate_cumulative_return(min_var_returns$portfolio_returns)

# Plot how $100 invested in min_var would grow over this period
plot_portfolio_growth_over_time(min_var_returns$Date,
                                min_var_returns$portfolio_returns,
                                "Min Var Porfolio")

# Plot histogram of daily min_var portfolio returns
plot_returns_histogram(min_var_returns$portfolio_returns,
                       "Min Var Porfolio")

###############################################################
# MAKING YOUR OWN CUSTOM PORTFOLIO
###############################################################

US_stock_weight = 65
Developed_stocks_weight = 0
EM_stocks_weight = 0
REITs_weight = 0
Bond_30y_weight = 25
Gold_weight = 10
Energy_stocks = 0

custom_weights = c(US_stock_weight/100,
                   Developed_stocks_weight/100,
                   EM_stocks_weight/100,
                   REITs_weight/100,
                   Bond_30y_weight/100,
                   Gold_weight/100,
                   Energy_stocks/100)

custom_returns = generate_portfolio_returns(custom_weights, df)

calculate_cumulative_return(custom_returns$portfolio_returns)

plot_portfolio_growth_over_time(custom_returns$Date,
                                custom_returns$portfolio_returns,
                                "Custom Portfolio")

plot_returns_histogram(custom_returns$portfolio_returns,
                       "Custom Porfolio")

# As you can see, the cumulative return of U.S. stocks
#   from Aug 1999 to Jan 2020 was 252%, despite going through
#   two terrible corrections (dot-com and great recession)
#   Therefore stocks are an amazing investment

# You see, this is why your EMF breaks for 1999-2020 data:
#   stocks produced a 252% return while 30y Treasuries
#   produced a 316% return
#   So, the EMF would curve downward, showing that you can
#   obtain more return with less vol by going heavy in Treasuries