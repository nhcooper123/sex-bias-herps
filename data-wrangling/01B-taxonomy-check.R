# Taxonomy check using AmphibiaWeb taxonomy and Reptile database

# Load libraries
library(tidyverse)

#----------------------------------
# AMPHIBIANS
#----------------------------------
# Read in our list of species
amp <- read_csv("raw-data/Amphibian-species.csv")

# Read in check list from AmphibiaWeb
amphibian_species <- read_csv("raw-data/amphib_names.csv")

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
rep <- read_csv("raw-data/Reptile-species.csv")

# Read in species check list from Uetz
reptile_species <- read_csv("raw-data/Reptile_checklist_2019_08.csv")

# Rename Species to binomial
# Separate out Familyetc column to get Family names
# Rename family to familyX so it is retained in joins
# Select only required columns
### Note this gives a warning as the Familyetc column is not of a standardised
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

