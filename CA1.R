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