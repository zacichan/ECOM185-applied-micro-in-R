# Load necessary libraries
library(ggplot2)
library(dplyr)

data <- read_csv("data/processed/data.csv") %>%
  filter(year > 2010)

# Parallel Trends Test

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

# Filter the data for year_treated values of 2017 and above
filtered_data <- merged_data %>%
  filter(as.numeric(as.character(year_treated)) >= 2017)

# Plot using ggplot2
ggplot(filtered_data, aes(x = year)) +
  geom_line(aes(y = avg_y, color = "Treated Group", group = treated), size = 1) +
  geom_point(aes(y = avg_y, color = "Treated Group"), size = 2) +
  geom_line(aes(y = non_treated_y, color = "Non-treated Group"), linetype = "dashed", size = 1) +
  geom_vline(aes(xintercept = as.numeric(as.character(year_treated))), linetype = "dotted", color = "black", size = 1) +
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




# Scatter graphs

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Subset data for the specified year_treated cohorts
selected_years <- c(2017, 2018, 2019, 2021)
data_filtered <- data %>%
  filter(year_treated %in% selected_years)

# Reclassify 'treated' based on 'time_to_treatment'
data_filtered <- data_filtered %>%
  mutate(Treatment_Status = ifelse(time_to_treatment < 0, "Non-treated", "Treated"))

# Summarize the data by treatment status and year_treated
avg_data <- data_filtered %>%
  group_by(Treatment_Status, year_treated) %>%
  summarise(mean_y = mean(y, na.rm = TRUE),
            sd_y = sd(y, na.rm = TRUE),
            .groups = 'drop')

# Create the plot
ggplot() +
  geom_point(data = data_filtered, aes(x = Treatment_Status, y = y, color = Treatment_Status), alpha = 0.3, position = position_jitter(width = 0.2)) +
  geom_point(data = avg_data, aes(x = Treatment_Status, y = mean_y, color = Treatment_Status), size = 4) +
  geom_line(data = avg_data, aes(x = Treatment_Status, y = mean_y, group = 1), color = "black", size = 1) +
  geom_errorbar(data = avg_data, aes(x = Treatment_Status, ymin = mean_y - sd_y, ymax = mean_y + sd_y), width = 0.2) +
  scale_color_manual(values = c("red", "turquoise")) +
  labs(x = "Treatment Status", y = "Outcome (y)", title = "Average Treatment Effect Over Time by Cohort") +
  facet_wrap(~ year_treated) +
  theme_minimal()

