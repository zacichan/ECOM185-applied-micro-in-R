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
library(fixest)
library(readr)
library(iplots)


# Staggered Difference-in-Difference ----

# Load the dataset
data <- read_csv("data/processed/data.csv") %>%
  filter(year > 2010)

# Estimate the Sun and Abraham (2020) model
res_sa20 <- feols(y ~ sunab(year_treated, year) | id + year,
                  data,
                  vcov = newey_west ~ id + year)

# Visualise Coefficients
iplot(list(res_sa20), sep = 0.5,
      main = "Effect of Metro Mayors on GVA",
      sub = "Examining productivity changes post-election (Reference Year: 10)",
      xlab = "Years Relative to Mayor Election",
      ylab = "Estimated Effect on GVA per Hour Worked",
      col = "royalblue",
      pch = 19,  # Solid circle points
      cex = 1.4,  # Larger points
      lwd = 2,  # Thicker error bars
      ylim = c(-3, 3),
      grid = TRUE,
      gridcol = "lightgray")  # Increase x-axis label size

# Summarize the results
summary(res_sa20, agg = "att")

etable(res_sa20)

summary(res_sa20, agg = "cohort")


# Staggered Synthetic Difference-in-Difference ----

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

# Access the Average Treatment Effect (ATT) estimate and ATT table for the
# cohorts
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


# Robustness Checks ----


## 1) Visual Inspection of Parallel Trends ----

data <- read_csv("data/processed/data.csv") %>%
  filter(year > 2010)

# Ensure the treated and year_treated variables are factors for plotting
data$treated <- as.factor(data$treated)
data$year_treated <- as.factor(data$year_treated)

# Calculate the average Y for each year and treated group
avg_data <- data %>%
  group_by(year, treated, year_treated) %>%
  summarise(avg_y = mean(y, na.rm = TRUE)) %>%
  ungroup()

# Create a new dataframe that includes the non-treated group's data for each
# year treated
non_treated_data <- avg_data %>%
  filter(treated == "0") %>%
  select(year, avg_y) %>%
  rename(non_treated_y = avg_y)

# Merge the non-treated data with the original avg_data
merged_data <- avg_data %>%
  left_join(non_treated_data, by = "year")

# Filter the data for year_treated values of 2017 and above
filtered_data <- merged_data %>%
  filter(as.numeric(as.character(year_treated)) >= 2017)

# Plot using ggplot2
ggplot(filtered_data, aes(x = year)) +
  geom_line(aes(y = avg_y, color = "Treated Group", group = treated), size = 1) +
  geom_point(aes(y = avg_y, color = "Treated Group"), size = 2) +
  geom_line(aes(y = non_treated_y, color = "Non-treated Group"),
            linetype = "dashed", size = 1) +
  geom_vline(aes(xintercept = as.numeric(as.character(year_treated))),
             linetype = "dotted", color = "black", size = 1) +
  labs(title = "The Effect of Mayoral Devolution on Labour Productivity: A Heterogeneous Impact Across Different Cohorts",
       subtitle = "An Analysis of Gross Value Added (GVA) per Hour Worked Across English Local Authorities (2010-2022)",
       x = "Year",
       y = "Labour Productivity (GVA per Hour Worked, £)",
       color = "Group",
       caption = "Data Source: Office for National Statistics (ONS), 2010-2022") +
  scale_color_manual(values = c("Treated Group" = "blue", "Non-treated Group" = "red")) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.caption = element_text(hjust = 0, face = "italic")) +
  scale_x_continuous(breaks = seq(2012, 2022, 1)) +
  facet_wrap(~year_treated)


## 2) Event Study Analysis ----

data <- read_csv("data/processed/data.csv") %>%
  filter(year > 2010)

# Create relative time variable
data <- data %>%
  mutate(rel_time = year - year_treated)

# Estimate event study model
event_study <- feols(y ~ i(rel_time, ref = -1) | id + year,
                     data = data %>% filter(abs(rel_time) <= 4),
                     vcov = "hetero")

# Plot event study results
iplot(event_study,
      main = "Event Study: Effect of Metro Mayors on GVA",
      xlab = "Years relative to mayor election")


## 3) Test for anticipatory effects: ----

# Check coefficients on lead terms
summary(event_study)


## 4) Common Shocks Assumption: ----

data <- read_csv("data/processed/data.csv") %>%
  filter(year > 2010)

common_shocks <- feols(y ~ i(year, treated) | id + year,
                       data = data,
                       vcov = "hetero")

etable(common_shocks)
