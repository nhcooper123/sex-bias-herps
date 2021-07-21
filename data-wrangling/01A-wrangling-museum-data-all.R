# Tidying the data from databases
# Natalie Cooper
# April 2021
#---------------------------------
# Load libraries
library(tidyverse)
library(lubridate)
library(purrr)
library(naniar)

# Short function to get decades
floor_decade <- function(x){
  if(!is.na(x)){
  x - x %% 10
  }else{NA_character_}
}
#------------------------------------------------------------------
# Read in the GBIF data
# Separate the reptile data as it is too large to read in one chunk
# Then add column names so they can be joined
# Note that quote = "" is needed or R only reads in half the data!
#------------------------------------------------------------------
amphibians <- read.delim("raw-data/gbif-amphibians-2021-04-21.txt", sep =  "\t", quote = "")

reptiles1 <- read.delim("raw-data/gbif-reptiles-2021-04-21.txt", sep =  "\t", nrows = 2000000, quote = "")
reptiles2 <- read.delim("raw-data/gbif-reptiles-2021-04-21.txt", sep =  "\t", skip = 2000000, header = FALSE, quote = "")

# Change headers so they match
names(reptiles2) <- names(reptiles1)

# Combine into a list
all <- list(amphibians, reptiles1, reptiles2)

# Combine based on shared columns
ds <- rbind(amphibians, reptiles1, reptiles2)

#----------------------------------
# Tidy up the data
#----------------------------------
ds2 <-
  
  ds %>%

  # Check that all included records are specimens not observations
  filter(basisOfRecord == "PRESERVED_SPECIMEN") %>%
  
  # Remove entries with no order or species
  filter(order != "" & species != "") %>%
  
  # Create a new column for specimen ID number
  unite(col = specID, `institutionCode`, `catalogNumber`, sep = "_", remove = FALSE) %>%
  
  # Remove records where specimen is definitely not an adult
  # This will exclude the juveniles, fetuses and young
  # All unknown age individuals (the majority) are kept, on the basis
  # that juveniles are almost always coded as such, but adult status is not
  filter(lifeStage == "ADULT" | is.na(lifeStage) | lifeStage == "") %>%
  
  # Remove capitalised words in sex
  mutate(sex = str_replace(sex, "FEMALE", "Female")) %>%
  mutate(sex = str_replace(sex, "MALE", "Male")) %>%
  
  # Extract only male or female specimens
  # Excludes specimens with ?, intersex and multiple sex specimens
  filter(sex == "Male" | sex == "Female") %>%
  
  # ALTERNATIVE CODE that keeps specimens that have not been sexed
  # If using this, comment out the line above
  # filter(sex == "Male" | sex == "Female" | is.na(sex) | sex == "") %>%
  
  # Add decade variable (function above)
  # This maps to character to deal with NAs so needs coercing back to numeric
  mutate(decade = map_chr(year, floor_decade)) %>%
  mutate(decade = as.numeric(decade)) %>%
  
  # Add a name bearing type column and designate name bearing types as such
  # Non types
  mutate(typeStatus = as.character(typeStatus)) %>%
  mutate(type = if_else(is.na(typeStatus), "NonType", typeStatus)) %>%
  
  # Name bearing types
  mutate(type = str_replace(type, "HOLOTYPE", "Type")) %>%
  mutate(type = str_replace(type, "SYNTYPE", "Type")) %>%
  mutate(type = str_replace(type, "LECTOTYPE", "Type")) %>%
  mutate(type = str_replace(type, "NEOTYPE", "Type")) %>%
  
  # Non name bearing types
  mutate(type = str_replace(type, "COTYPE", "NonNameType")) %>%
  mutate(type = str_replace(type, "ALLOTYPE", "NonNameType")) %>%
  mutate(type = str_replace(type, "PARALECTOTYPE", "NonNameType")) %>%
  mutate(type = str_replace(type, "PARAType", "NonNameType")) %>%
  mutate(type = str_replace(type, "PARATYPE", "NonNameType")) %>%
  mutate(type = str_replace(type, "TOPOTYPE", "NonNameType")) %>% 
  mutate(type = str_replace(type, "HYPOTYPE", "NonNameType")) %>% 
  
  # It is unclear if these are name bearing or not
  mutate(type = str_replace(type, "TYPE", "AmbiguousType")) %>%
  
  # Rename classes to english names
  mutate(class = str_replace_all(class, "Amphibia", "Amphibians")) %>%
  mutate(class = str_replace_all(class, "Reptilia", "Reptiles")) %>%
  
  # Select just the columns of interest
  # Note that we keep gbifID as it is the only unique identifier of each record
  # in herps it is common for a number of specimens to have the same museum ID
  select(gbifID, institutionCode, specID, binomial = species, sex, class, order, family, genus,
         continent, countryCode, year, decade, typeStatus, type, iucnRedListCategory)

# To deal with the issues of "" rather than NA in some records
# write to file and then read back in for next step
# Write to file
write_csv(ds2, file = "raw-data/halfwaydone.csv")
# ALTERNATIVE CODE that keeps specimens that have not been sexed
# write_csv(ds2, file = "raw-data/halfwaydone-unsexed.csv")

#----------------------------------------------------------------
# Match taxonomy to Frost/Uetz
#----------------------------------------------------------------
# taxize is not working properly, so done semi-manually

# I've put in into another script called 01B-taxonomy-corrections-herps.R
# It takes ds2 and matches it up to the taxonomies then outputs a file for correcting
# the mismatches manually.

# This is then read back in below and merged to obtain the most up to date names
#------------------------------------------------------------------------------------
# Read in the two taxonomy files, and the higher taxonomy file for squamates
amphibians <- read_csv("raw-data/amphibian-taxonomy-corrections.csv")
reptiles <- read_csv("raw-data/reptile-taxonomy-corrections.csv")
higher <- read_csv("raw-data/squamate-higher-taxonomy.csv")

# Stick the amphibianx and reptiles together, and remove the 
# family column as it is not needed.
taxonomy <- rbind(amphibians, reptiles)
taxonomy <- dplyr::select(taxonomy, -family)
#------------------------------------------------------------------------------------
# Merge taxonomy and data
# Read data back in
ds2 <- readr::read_csv("raw-data/halfwaydone.csv")

# Merge the specimen dataset and taxonomy data
ds3 <- left_join(ds2, taxonomy, by = "binomial")

# Remove the now defunct original binomial and family columns 
# and then rename the _correct columns to make coding simpler
# Create a new genus column using the updated genera
# and remove the species column as it is also not needed
# And remove any row without binomial names
# Finally add the higher level taxonomy for squamates
final <- 
  ds3 %>%
  dplyr::select(-binomial, -family, -genus) %>%
  rename(family = family_correct) %>%
  rename(binomial = binomial_correct) %>%
  separate(binomial, c("genus", "species"), sep = " ", remove = FALSE) %>%
  dplyr::select(-species) %>%
  filter(!is.na(binomial)) %>%
  full_join(higher, by = "family")

#------------------------------------------------------------------------------------
# Write to file for analyses
#-----------------------------------------------------
write_csv(final, file = "data/all-specimen-data-2021-07.csv")  

#------------------------------------------------------------------------------------
# Note that this was followed by a data quality check, scrolling through
# species names to check for obvious duplicates (i.e. very similar species names)
# to reduce mismatches caused by taxonomic differences.

#------------------------------------------------------------------------------------
# Unsexed data - merge taxonomy and data and save for future analyses
#------------------------------------------------------------------------------------
# Merge taxonomy and data
# Read data back in
ds2_unsexed <- readr::read_csv("raw-data/halfwaydone-unsexed.csv")

# Merge the specimen dataset and taxonomy data
ds3_unsexed <- left_join(ds2_unsexed, taxonomy, by = "binomial")

# Remove the now defunct original binomial and family columns 
# and then rename the _correct columns to make coding simpler
# Create a new genus column using the updated genera
# and remove the species column as it is also not needed
# And remove any row without binomial names to exclude fossils and uncertain taxonomy species
# Finally add the higher level taxonomy for squamates
final_unsexed <- 
  ds3_unsexed %>%
  dplyr::select(-binomial, -family, -genus) %>%
  rename(family = family_correct) %>%
  rename(binomial = binomial_correct) %>%
  separate(binomial, c("genus", "species"), sep = " ", remove = FALSE) %>%
  dplyr::select(-species) %>%
  filter(!is.na(binomial)) %>%
  full_join(higher, by = "family")

#------------------------------------------------------------------------------------
# Write to file for analyses
#-----------------------------------------------------
write_csv(final_unsexed, file = "data/all-specimen-data-unsexed-2021-07.csv")  
#------------------------------------------------------------------------------------