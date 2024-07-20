# Load necessary libraries
library(fixest)
library(dplyr)
library(readr)

# Load the dataset
data <- read_csv("data/processed/data.csv")

# Estimate the "naive" TWFE model
res_twfe <- feols(y ~ i(time_to_treatment, ref = c(-1, -1000)) | id + year,
                  data,
                  vcov = newey_west ~ id + year)

# Estimate the Sun and Abraham (2020) model
res_sa20 <- feols(y ~ sunab(year_treated, year) | id + year,
                  data,
                  vcov = newey_west ~ id + year)

# Plot the results
iplot(list(res_twfe, res_sa20), sep = 0.5)

# Plot the results
iplot(list(res_sa20), sep = 0.5)

# Summarize the results
summary(res_sa20, agg = "att")

etable(res_sa20)

summary(res_sa20, agg = "cohort")
