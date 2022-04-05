# Create dataset for extra species level variables
# Natalie Cooper
# Feb 2022
#--------------------------------------------------
# Load libraries
library(tidyverse)

# Read in full specimen dataset to extract species
specs <- read_csv("data/all-specimen-data-2021-07.csv")

# Read in SSD data
size <- read_csv("raw-data/body-size-herps-SA-NC-2022-02-09.csv")

#--------------------------------
# Merge data
#--------------------------------
all <- left_join(specs, size)  

# Write to file
write_csv(all, "data/extra-data-sexed-2022-04.csv")
