# NYC Data Science Academy
# R Shiny Project
# Joe Lu, Joe.Zhou.Lu@gmail.com

# Help file with all of the functions required to run app.R

# Import required libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(quadprog)
library(testit)
library(corrplot)
library(tidyr)
library(readxl)
library(lubridate)


file_name = "./Data_All_Assets_Compiled.xlsx"
returns_1999_2020 = read_excel(file_name, sheet = "Raw_Returns")
returns_1999_2020$Date = as.Date(returns_1999_2020$Date)

# Input: a vector of daily returns
#   Example: c(2, -1, 3) represents 2% return on day 1,
#   -1% on day 2, and 3% on day 3
# Output: the cumulative return after investing for all those days
#   Example: in this case, the cumulative return would be 4.01%
calculate_cumulative_return = function(returns_vector)
{
  return(100*(prod(1 + returns_vector / 100) - 1))
}


# Plot a correlation heatmap
plot_correlation_heatmap = function(returns_matrix)
{
  g = corrplot(cor(returns_matrix), method = "square")
  print(g)
}


# Given time series of returns, generate histogram showing distribution
plot_returns_histogram = function(return_series, asset_name, outline_color, fill_color)
{
  g = ggplot(data = data.frame(return_series), aes(x = return_series)) +
    geom_histogram(binwidth = 0.1, color = outline_color, fill = fill_color) +
    labs(title = paste("Returns Distribution for", asset_name), x = "Daily Return (%)", y = "Count")
  print(g)
}


# Plot overlapping density graphs
plot_overlapping_density = function(returns_matrix)
{
  n_cols = ncol(returns_matrix)
  name_first = names(returns_matrix)[1]
  name_last = names(returns_matrix)[n_cols]
  
  # Convert from: columns = asset 1, asset 2, asset 3, etc
  # with a rectangular matrix of returns for assets 1, 2, 3
  # To: lining the columns of all assets in one long column
  # named "return", and having a 2nd column listing if it is
  # asset 1, asset 2, etc.
  returns_matrix_long = returns_matrix %>%
    gather(asset, returns, name_first: name_last)
  
  g = ggplot(returns_matrix_long,
             aes(returns, stat(density), color = asset)) +
    geom_freqpoly(bins = 30) + xlim(-3, 3)
  print(g)
}


# Input: (m by 1) matrix of asset weights.  There are m assets
#   and (n by m+1) matrix of returns matrix. Left column is dates
#   There are n observations (n days or n months, etc)
# Output: (n by 2) matrix of portfolio returns
#   Again, the left column contains dates
calculate_portfolio_returns = function(asset_weights, returns_matrix)
{
  # Extract necessary parameters
  n_rows = nrow(returns_matrix)
  n_cols = ncol(returns_matrix)
  n_assets = n_cols - 1
  
  assert(length(asset_weights) == n_assets)
  assert(abs(sum(asset_weights)-1) <= 0.001)
  
  portfolio_returns = data.matrix(returns_matrix[,2:n_cols]) %*% asset_weights
  portfolio_returns_with_dates = cbind(returns_matrix[,1], portfolio_returns)
  
  return(portfolio_returns_with_dates)
}


# Input: a dataframe of m+1 columns, where leftmost column is dates
#   followed by m columns of asset returns (for m assets)
# Output: min-variance portfolio for that time period of asset returns
# Calculate the covariance matrix for the entire 20 years
calculate_min_var_portfolio = function(returns_matrix,
                                       print_description,
                                       plot_bar_chart)
{
  # Extract necessary parameters
  n_rows = nrow(returns_matrix)
  n_cols = ncol(returns_matrix)
  n_assets = n_cols - 1
  asset_names = colnames(returns_matrix)[2:n_cols]
  date_1 = returns_matrix[[1,1]]
  date_2 = returns_matrix[[n_rows,1]]
  
  # Calculate the covariance matrix of asset returns during this period
  cov_matrix = cov(returns_matrix[,2:n_cols])
  
  # Calculate the minimum variable portfolio
  aMat <- array(1, dim = c(1, n_assets))
  bVec <- 1
  zeros <- array(0, dim = c(n_assets, 1))
  solQP <- solve.QP(cov_matrix, zeros, t(aMat), bVec, meq = 1)
  
  # Optionally, print out an interpretion of the result
  if (print_description)
  {
    print(paste0("Using returns data between ",date_1," and ",date_2,", the portfolio with the minimum variance is:"))
    print(paste0(asset_names, ": ", round(100*solQP$solution,0), '%'))
  }
  
  # Optionally, make a bar plot
  if (plot_bar_chart)
  {
    bar_chart = ggplot(data = data.frame(asset_names, solQP$solution),
                       aes(x = asset_names, y = 100*solQP$solution)) +
      geom_bar(stat="identity", fill="seagreen4") +
      ggtitle("Min Variance Portfolio Weights") +
      xlab("Asset Class") + ylab("% Allocation") +
      coord_flip()
    
    print(bar_chart)
  }
  
  return(solQP$solution)
}
# Solution for 20y is: 22% US stocks, 9% developed markets, 0% EM
#   -3% REITs, 56% 30y Treasuries, 16% gold, 0% energy stocks



# Input: a series of dates (increasing) and series of corresponding returns
# Output: a graph of how $100 grows over this time period
plot_portfolio_growth_over_time = function(date_series, return_series, asset_name, color)
{
  # Verify that the length of the dates vector matches with return vector
  assert(length(date_series) == length(return_series))
  
  n_obs = length(date_series)
  price_series = c(100.0*(1 + return_series[1]/100))
  
  for (i in 2:n_obs)
  {
    price_series = append(price_series,
                          price_series[i-1]*(1 + return_series[i]/100))
  }
  
  assert(length(date_series) == length(price_series))
  
  price_plot = ggplot(data = data.frame(date_series, price_series),
                      aes(x = date_series, y = price_series)) +
    geom_line(color = color, size = 1) +
    ggtitle(paste("If you had invested $100 in", asset_name, "...")) +
    xlab("Time") + ylab("Portfolio value")
  print(price_plot)
}



# Input: m+1 columns of asset returns (from m assets)
# Output: plot the efficient market frontier
plot_efficient_market_frontier = function(asset_returns, n_points)
{
  # Extract necessary parameters
  n_assets = ncol(asset_returns) - 1
  n_obs = nrow(asset_returns)
  n_years = n_obs / 252
  
  # Initialize containers for holding return and vol simulations
  return_vector = c()
  vol_vector = c()
  sharpe_vector = c()
  
  for (i in 1:n_points)
  {
    # Generate random weights for n assets from uniform(0,1)
    asset_weights = runif(n_assets, min = 0, max = 1)
    normalization_ratio = sum(asset_weights)
    # Asset weights need to add up to 100%
    asset_weights = asset_weights / normalization_ratio
    
    # print(asset_weights)
    # print(asset_returns)
    
    # Generate the portfolio return vector using these weights
    random_portfolio_returns = calculate_portfolio_returns(
      asset_weights,
      asset_returns)
    # print(random_portfolio_returns)
    # plot_returns_histogram(random_portfolio_returns$portfolio_returns)
    
    cumulative_return = calculate_cumulative_return(random_portfolio_returns$portfolio_returns)
    annualized_return = 100*((1 + cumulative_return/100)^(1/n_years) - 1)
    annualized_vol = sd(random_portfolio_returns$portfolio_returns)*(252^0.5)
    sharpe = annualized_return / annualized_vol
    
    return_vector = append(return_vector, annualized_return)
    vol_vector = append(vol_vector, annualized_vol)
    sharpe_vector = append(sharpe_vector, sharpe)
    
    #print(paste("Asset weights:",asset_weights))
    #print(paste("Anualized return:",annualized_return))
    #print(paste("Annualized vol:",annualized_vol))
  }
  
  g = ggplot(data = data.frame(vol_vector, return_vector, sharpe_vector),
             aes(x = vol_vector, y = return_vector, color = sharpe_vector)) +
    scale_color_gradient(low = "red", high = "blue", name = "Sharpe Ratio\n(Return/Risk)") + 
    ggtitle("Efficient Market Frontier") +
    xlab("Annualized Vol (%)") +
    ylab("Annualized Return (%)") + 
    geom_point()
  print(g)
}

# Print key metrics of cumulative return, annualized return,
#   annualized volatility, etc.
print_key_metrics = function(asset_name, asset_returns, start_date, end_date)
{
  n_obs = nrow(df)
  n_years = n_obs / 252
  
  cumulative_return = calculate_cumulative_return(asset_returns)
  annualized_return = 100*((1 + cumulative_return/100)^(1/n_years) - 1)
  annualized_vol = sd(asset_returns)*(252^0.5)
  cat("For",asset_name,"between",as.character(start_date),"and",as.character(end_date),":\n",
      "Total return:",round(cumulative_return,1),"%\n",
      "Annualized return:",round(annualized_return,1),"%\n",
      "Annualized vol:",round(annualized_vol,1),"%\n")
}


# Plot a scatterplot of returns between assets 1 and 2
plot_scatter_of_returns = function(asset1_returns, asset2_returns,
                                   asset1_name, asset2_name)
{
  g = ggplot(data = data.frame(asset1_returns, asset2_returns),
             aes(x = asset1_returns, y = asset2_returns)) +
    geom_point(color = "darkblue", size = 1) +
    ggtitle(paste("Scatterplot of Returns between",
                  asset1_name, "and", asset2_name)) + 
    xlab(paste("Returns of", asset1_name)) +
    ylab(paste("Returns of", asset2_name)) +
    geom_smooth(color = "red", method=lm, se=FALSE)
  print(g)
}


