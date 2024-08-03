# Load necessary libraries
library(tidyverse)
library(readr)

# Load the datasets
productivity_df <- read_csv('./data/raw/labourproductivitylocalauthorities.csv', skip = 4)
treatment_df <- read_csv('./data/raw/Treatment_dataset.csv')

# Clean and reshape the productivity dataset
colnames(productivity_df)[1] <- "LAD_Code"
year_columns <- grepl("Pounds", colnames(productivity_df)) | colnames(productivity_df) %in% c("LAD_Code", "LAD_Name")

# Filter the dataframe to only keep relevant columns
productivity_df_filtered <- productivity_df[, year_columns]

# Convert from wide to long format
productivity_long <- productivity_df_filtered %>%
  pivot_longer(cols = starts_with("Pounds"), names_to = "Year", values_to = "Productivity")

# Extract year and handle NaN values safely
productivity_long <- productivity_long %>%
  mutate(Year = as.integer(gsub("\\D", "", Year))) %>%
  drop_na(Year)

# Merge the datasets
merged_df <- productivity_long %>%
  inner_join(treatment_df, by = c("LAD_Code" = "LAD_Code_2021"))

# Create new columns for the final dataset
merged_df <- merged_df %>%
  mutate(
    year_treated = ifelse(Treated == 0, 1000, Treatment_year),
    time_to_treatment = ifelse(Treated == 0, -1000, (Year - Treatment_year)),
    treated = Treated
  )

# Select and rename columns to match the desired format
final_df <- merged_df %>%
  rename(id = LAD_Code, year = Year, y = Productivity) %>%
  select(id, year, year_treated, time_to_treatment, treated, y)

# Display the final dataset
print(final_df)

write_csv(final_df, "data/processed/data.csv")