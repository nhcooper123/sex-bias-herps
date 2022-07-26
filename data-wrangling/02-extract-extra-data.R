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

#--------------------------------
# Unsexed data
#--------------------------------
# Read in full specimen dataset to extract species
specimens_all <- read_csv(here("data/all-specimen-data-unsexed-2021-07.csv")) 
# Create sexed column
specimens_all <- 
  specimens_all %>%
  mutate(sexed = case_when(is.na(sex) ~ "unsexed", !is.na(sex) ~ "sexed"))

#--------------------------------
# Merge data
#--------------------------------
all2 <- left_join(specimens_all, size)  

# Write to file
write_csv(all2, "data/extra-data-unsexed-2022-07.csv")
