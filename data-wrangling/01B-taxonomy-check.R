# Taxonomy check using AmphibiaWeb taxonomy and Reptile database

# Load libraries
library(tidyverse)

#----------------------------------
# AMPHIBIANS
#----------------------------------
# Read in our list of species
amp <- 
  ds2 %>%
  filter(class == "Amphibians") %>%
  select(binomial, family) %>%
  distinct()
  
# Read in check list from AmphibiaWeb
# https://amphibiaweb.org/amphib_names.txt
amphibian_species <- read_delim("raw-data/amphib_names.txt", delim = "\t")

# Add binomial column
# Rename family to familyX so it is retained in joins
# Select only required columns
amphibian_species <-
  amphibian_species %>%
  mutate(binomial = paste(genus, species)) %>%
  rename(familyX = family) %>%
  select(familyX, binomial)

# Join to cut out species found in AmphibiaWeb but not our data
# but keep those found in our data and not AmphibiaWeb
# these will need checking...
all_amp <- left_join(amp, amphibian_species, by = "binomial")

# Which family names need correcting?
fix_family_amphibians <- filter(all_amp, family != familyX)

# Which species names need correcting?
fix_species_amphibians <- filter(all_amp, is.na(familyX)) %>% arrange(binomial)
#----------------------------------
# REPTILES
#----------------------------------
# Read in our list of species
rep <-   
  ds2 %>%
  filter(class == "Reptiles") %>%
  select(binomial, family) %>%
  distinct()

# Read in species check list from Uetz
# http://www.reptile-database.org/data/
reptile_species <- read_csv("raw-data/reptile_checklist_2020_12.csv")

# Rename Species to binomial
# Separate out Familyetc column to get Family names
# Rename family to familyX so it is retained in joins
# Select only required columns
### Note this gives a warning as the Family etc column is not of a standardised
### size, but it doesn't matter as the first element (family) is all we want
reptile_species <-
  reptile_species %>%
  rename(binomial = Species) %>%
  separate(Familyetc, sep = ",", into = c("family", "x", "y", "z")) %>%
  rename(familyX = family) %>%
  select(familyX, binomial)

# Join to cut out species found in Uetz but not our data
# but keep those found in our data and not Eutz
# these will need checking...
all_rep <- left_join(rep, reptile_species, by = "binomial")

# Which family names need correcting?
fix_family_reptiles <- filter(all_rep, family != familyX)

# Which species names need correcting?
fix_species_reptiles <- filter(all_rep, is.na(familyX)) %>% arrange(binomial)

# Fixes are in the script 01C-taxonomy-fix-herps

# Get the code for corrections
#for (i in 1:length(fix_species_amphibians$binomial)){
#  print(paste0("mutate(binomial = str_replace(binomial, '", fix_species_amphibians$binomial[i], "', 'FIX')) %>%" ))
#} 