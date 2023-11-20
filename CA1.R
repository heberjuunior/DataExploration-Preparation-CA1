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

# Creates a vector with mean, standard deviation, minimum, and maximum values
summary_stats <- c(mean = 10, sd = 2, min = 5, max = 15)

# Assigns the column "names" to the vector
names(summary_stats) <- c("Mean", "SD", "Min", "Max")

# Defines the column names for the data frame
col_names <- c("Mean", "SD", "Min", "Max")

# Converts the vector to a data frame with column names
summary_stats_df <- as.data.frame(summary_stats, col.names = col_names)

# Prints structure of the vector
str(summary_stats)
