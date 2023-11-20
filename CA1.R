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