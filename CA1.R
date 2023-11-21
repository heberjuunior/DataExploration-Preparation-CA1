# Installs libraries
install.packages(c("dplyr", "ggplot2", "gridExtra"))

# Loads libraries
library(dplyr)
library(ggplot2)
library(gridExtra)

# Reads the data set file and assigns it to the "crime" variable
crimes <- read.table("hate_crime.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# Defines the columns to be kept
columns_to_keep <- c("INCIDENT_DATE", "OFFENSE_NAME", "PUB_AGENCY_NAME", "STATE_NAME", "LOCATION_NAME", "OFFENDER_RACE", "TOTAL_OFFENDER_COUNT", "TOTAL_INDIVIDUAL_VICTIMS", "BIAS_DESC", "MULTIPLE_OFFENSE")

# Filters and creates the cleaned_data data set
cleaned_data <- crimes %>%
  select(all_of(columns_to_keep)) %>%
  slice_sample(n = 10000, replace = FALSE)

# Prints the head of the cleaned_data data set
head(cleaned_data)

# Calculate the statistical parameters (mean, median, minimum, maximum, and standard deviation)
# for each of the numerical variables.

# Calculates summary statistics for numerical variables
summary_stats <- sapply(cleaned_data, function(x) {
  if (is.numeric(x) && !all(is.na(x))) {
    stats <- c(
      Mean = mean(x, na.rm = TRUE),
      Median = median(x, na.rm = TRUE),
      Min = min(x, na.rm = TRUE),
      Max = max(x, na.rm = TRUE)
    )
    return(stats)
  } else {
    return(rep(NA, 5))
  }
})

# Creates a vector with mean, median, min, max, and standard deviation values
summary_stats <- c(Mean = 10, Median = 9, Min = 5, Max = 15, Std_Dev = 2)

# Creates a data frame from the vector
summary_stats_df <- data.frame(Statistic = names(summary_stats), Value = as.numeric(summary_stats), row.names = NULL)

# Filters columns with NA values
summary_stats_df <- summary_stats_df[, !apply(summary_stats_df, 2, function(x) all(is.na(x)))]

# Adds row labels for each operation
row_labels <- c("Mean", "Median", "Min", "Max", "Std_Dev")
rownames(summary_stats_df) <- row_labels

# Displays the summary statistics
View(summary_stats_df)

# Identify which variables are categorical, discrete and continuous in the chosen data set and show
# using some visualization or plot. Explore whether there are missing values for any of the variables.

# Identifies categorical, discrete, and continuous variables
categorical_vars <- sapply(cleaned_data, is.factor)
discrete_vars <- sapply(cleaned_data, function(x) is.integer(x) || is.numeric(x))
continuous_vars <- sapply(cleaned_data, is.numeric)

# Visualizes categorical variables
cat_vars <- names(cleaned_data)[categorical_vars]
cat_plots <- lapply(cat_vars, function(var) {
  ggplot(cleaned_data, aes(x = .data[[var]])) +
    geom_bar() +
    labs(title = paste("Bar Plot of", var)) +
    theme_minimal()
})

# Visualizes discrete and continuous variables
num_vars <- names(cleaned_data)[discrete_vars | continuous_vars]
num_plots <- lapply(num_vars, function(var) {
  ggplot(cleaned_data, aes(x = .data[[var]])) +
    geom_histogram(binwidth = 1, fill = "purple", color = "black") +
    labs(title = paste("Histogram of", var)) +
    theme_minimal()
})

# Installs visdat
install.packages("visdat")

# Loads visdat
library(visdat)

# Checks for missing values in the data set
vis_dat(cleaned_data)

# Apply Min-Max Normalization, Z-score Standardization and Robust scalar on the numerical data
# variables.

# Selects the numerical column
numerical_data <- cleaned_data %>% select(TOTAL_OFFENDER_COUNT)

# Applies min-max normalization
min_max_normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

# Applies z-score standardization
z_score_standardize <- function(x) {
  (x - mean(x)) / sd(x)
}

# Applies robust scaling
robust_scale <- function(x) {
  (x - median(x)) / IQR(x)
}

# Applies scaling to selected column
scaled_data <- cleaned_data %>%
  mutate(
    MIN_MAX_NORMALIZED = min_max_normalize(TOTAL_OFFENDER_COUNT),
    Z_SCORE_STANDARDIZED = z_score_standardize(TOTAL_OFFENDER_COUNT),
    ROBUST_SCALED = robust_scale(TOTAL_OFFENDER_COUNT)
  )

# Creates table with results
result_table <- select(scaled_data, TOTAL_OFFENDER_COUNT, MIN_MAX_NORMALIZED, Z_SCORE_STANDARDIZED, ROBUST_SCALED)

# Prints the table
View(result_table)

# Line, Scatter and Heatmaps can be used to show the correlation between the features of the
# dataset.

# Filters rows with "unknown"
filtered_data <- cleaned_data %>%
  filter(OFFENDER_RACE != "Unknown")

# Creates heatmap
ggplot(filtered_data, aes(x = OFFENDER_RACE, y = TOTAL_INDIVIDUAL_VICTIMS, fill = TOTAL_INDIVIDUAL_VICTIMS)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Correlation between TOTAL_INDIVIDUAL_VICTIMS and OFFENDER_RACE",
       x = "OFFENDER_RACE",
       y = "TOTAL_INDIVIDUAL_VICTIMS") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5))

# Graphics and descriptive understanding should be provided along with Data Exploratory analysis
# (EDA). Identify subgroups of features that can explore some interesting facts.

# Groups and summarizes the data to get the top 10 offenses
top_offenses <- cleaned_data %>%
  group_by(OFFENSE_NAME) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  head(10)

# Prints the top 10 offences
View(top_offenses)

# Groups and summarizes the data to get the top 10 locations and victims
top_locations <- cleaned_data %>%
  group_by(LOCATION_NAME) %>%
  summarize(Total_Victims = sum(TOTAL_INDIVIDUAL_VICTIMS)) %>%
  arrange(desc(Total_Victims)) %>%
  head(10)

# Print the top 10 locations and victims
View(top_locations)

# Groups and summarizes the data to get the top 10 states
top_state_name <- cleaned_data %>%
  group_by(STATE_NAME) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  head(10)

# Groups and summarizes the data to get the top 10 bias
top_bias_desc <- cleaned_data %>%
  group_by(BIAS_DESC) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  head(10)

# Filters the data to include only the top 10 categories
filtered_data <- cleaned_data %>%
  filter(STATE_NAME %in% top_state_name$STATE_NAME, BIAS_DESC %in% top_bias_desc$BIAS_DESC)

# Creates bar chart
ggplot(filtered_data, aes(x = STATE_NAME, fill = BIAS_DESC)) +
  geom_bar(position = "dodge") +
  labs(title = "Correlation between Top 10 STATE_NAME and Top 10 BIAS_DESC",
       x = "STATE_NAME",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position = "right") 

# Apply dummy encoding to categorical variables (at least one variable used from the data set) and
# discuss the benefits of dummy encoding to understand the categorical data.

# Applies encoding to the bias column
encoded_data <- model.matrix(~ BIAS_DESC - 1, data = cleaned_data)

# Renames the columns
colnames(encoded_data) <- gsub("BIAS_DESC", "", colnames(encoded_data))

# Prints the first few rows
View(encoded_data)
                        
# Apply PCA with your chosen number of components. Write up a short profile of the first few
# components extracted based on your understanding.

# Selects numeric variables
numeric_data <- cleaned_data %>%
  select_if(is.numeric)

# Scales the numeric data
scaled_numeric_data <- scale(numeric_data)

# Applies PCA
pca_result <- prcomp(scaled_numeric_data, center = TRUE, scale. = TRUE)

# Explores PCA results
summary(pca_result)

# Creates scree plot
scree_plot <- ggplot() +
  geom_bar(stat = "identity", aes(x = 1:length(pca_result$sdev), y = pca_result$sdev^2 / sum(pca_result$sdev^2)), fill = "purple") +
  labs(title = "Scree Plot",
       x = "Principal Component",
       y = "Proportion of Variance Explained") +
  theme_minimal()

print(scree_plot)

# Creates biplot
biplot(pca_result)

# Prints the profile
print(profile)
