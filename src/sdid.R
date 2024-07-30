# Load necessary libraries, installing if not already installed
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

if (!requireNamespace("ssynthdid", quietly = TRUE)) {
  remotes::install_github("tjhon/ssynthdid")
}

# Load the required libraries
library(ssynthdid)
library(ggplot2)
library(tibble)
library(dplyr)

# Import data from a CSV file
data <- read.csv("data/processed/data.csv")

# Create the treated_active variable correctly, handling never treated units
data <- data %>%
  mutate(
    treated_active = if_else(treated == 1 & year >= year_treated, 1, 0)
  )

# Select specific columns for analysis
data <- data %>%
  select(id, year, treated_active, y)

# Convert columns to numeric if they are not already
data <- data %>%
  mutate(across(c(y, year, treated_active), as.numeric))

# Convert the data frame to a tibble for better manipulation
data <- as_tibble(data)

# Filter data to include only years from 2010 onwards
data_cut <- data %>%
  filter(year >= 2010)

# Remove rows where id starts with "E09" (e.g., London)
data_cut <- data_cut %>%
  filter(!grepl("^E09", id, ignore.case = TRUE))

# Check the structure to confirm the changes
str(data_cut)

# Estimate the synthetic control model using the filtered data
estimate <- ssynth_estimate(data_cut, "id", "year", "treated_active", "y")

# Display a glimpse of the estimate object to understand its structure
glimpse(estimate)

# Access the Average Treatment Effect (ATT) estimate and ATT table for the cohorts
att_estimate <- estimate$att_estimate
att_table <- estimate$att_table

# Plot the estimate using the synthetic DiD
plt_estimate <- ssynthdid_plot(estimate)

# Access specific cohorts in the plot
plt_estimate$time_2017
plt_estimate$time_2018
plt_estimate$time_2019
plt_estimate$time_2021

# Calculate the variance-covariance matrix using different methods

# Placebo method
confidence_placebo <- ss_vcov(estimate, method = "placebo", n_reps = 100)

# Bootstrap method
confidence_bootstrap <- ss_vcov(estimate, method = "bootstrap", n_reps = 100)

# Jackknife method
confidence_jackknife <- ss_vcov(estimate, method = "jackknife", n_reps = 100)

# Print the results
print(att_estimate)
print(att_table)
print(confidence_placebo)
print(confidence_bootstrap)
print(confidence_jackknife)