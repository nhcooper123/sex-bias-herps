# Taxonomy check using AmphibiaWeb taxonomy and Reptile database
# April 2021

#-----------------------
# Prep
#-----------------------
# Load libraries
library(tidyverse)

# Read in our tidied data 
ds2 <- read_csv("raw-data/halfwaydone.csv")

# Split into amphibians and reptiles
# And select only the species and family
amphibians <- 
  ds2 %>%
  filter(class == "Amphibians") %>%
  select(binomial, family)

reptiles <- 
  ds2 %>%
  filter(class == "Reptiles") %>%
  select(binomial, family)

#----------------------------------
# AMPHIBIANS
#----------------------------------
# Read in check list from AmphibiaWeb
# https://amphibiaweb.org/amphib_names.txt
amphibians_frost <- read_delim("raw-data/amphib_names.txt", delim = "\t")

# Add binomial_frost column and binomial column
# We will join based on binomial, but then retain binomial_frost to correct
# names manually.
# Rename family to family_frost so it is retained in joins
# Select only required columns
amphibians_frost <-
  amphibians_frost %>%
  mutate(binomial_correct = paste(genus, species)) %>%
  mutate(binomial = binomial_correct) %>%
  rename(family_correct = family) %>%
  select(binomial, family_correct, binomial_correct)

# Join to cut out species found in AmphibiaWeb but not our data
# but keep those found in our data and not AmphibiaWeb
# these will need checking manually...
all_amphibians <- left_join(amphibians, amphibians_frost, by = c("binomial" = "binomial")) %>% 
  distinct()

# write_csv(all_amphibians, file = "raw-data/amphibian-taxonomy-corrections-to-complete.csv")
# Now manually check any mismatches and update the family taxonomy to match Frost
# then save file as amphibian-taxonomy-corrections.csv

#----------------------------------
# REPTILES
#----------------------------------
# Read in species check list from Uetz
# http://www.reptile-database.org/data/
reptiles_uetz <- read_csv("raw-data/reptile_checklist_2020_12.csv")

# Rename Species to binomial
# Separate out Familyetc column to get Family names
# We will join based on binomial, but then retain binomial_correct to correct
# names manually.
# Rename family to family_correct so it is retained in joins
# Select only required columns
### Note this gives a warning as the Familyetc column is not of a standardised
### size, but it doesn't matter as the first element (family) is all we want
reptiles_uetz <-
  reptiles_uetz %>%
  rename(binomial_correct = Species) %>%
  mutate(binomial = binomial_correct) %>%
  separate(Familyetc, sep = ",", into = c("family_correct", "x", "y", "z")) %>%
  select(binomial, family_correct, binomial_correct)

# Join to cut out species found in Reptile Database but not our data
# but keep those found in our data and not Reptile Database
# these will need checking manually...
all_reptiles <- left_join(reptiles, reptiles_uetz, by = c("binomial" = "binomial")) %>% 
  distinct()

# write_csv(all_reptiles, file = "raw-data/reptile-taxonomy-corrections-to-complete.csv")
# Now manually check any mismatches and update the family taxonomy to match Uetz
# then save file as reptile-taxonomy-corrections.csv