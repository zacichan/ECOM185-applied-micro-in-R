# Load necessary libraries
library(ggplot2)
library(dplyr)

# Assuming the data is stored in a dataframe called data
# If not, read the data from a CSV file
# data <- read.csv('path/to/data.csv')

# Ensure the treated and year_treated variables are factors for plotting
data$treated <- as.factor(data$treated)
data$year_treated <- as.factor(data$year_treated)

# Calculate the average Y for each year and treated group
avg_data <- data %>%
  group_by(year, treated, year_treated) %>%
  summarise(avg_y = mean(y, na.rm = TRUE)) %>%
  ungroup()

# Create a new dataframe that includes the non-treated group's data for each year treated
non_treated_data <- avg_data %>%
  filter(treated == "0") %>%
  select(year, avg_y) %>%
  rename(non_treated_y = avg_y)

# Merge the non-treated data with the original avg_data
merged_data <- avg_data %>%
  left_join(non_treated_data, by = "year")

# Plot using ggplot2
ggplot(merged_data, aes(x = year)) +
  geom_line(aes(y = avg_y, color = treated, group = treated), size = 1) +
  geom_point(aes(y = avg_y, color = treated), size = 2) +
  geom_line(aes(y = non_treated_y), color = "red", linetype = "dashed", size = 1) +
  labs(title = "Parallel Trends Check",
       x = "Year",
       y = "Average Y",
       color = "Treated") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  facet_wrap(~year_treated)