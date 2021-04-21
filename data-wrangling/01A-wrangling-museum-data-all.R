# Tidying the data from databases
# Natalie Cooper
# March 2021
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
#------------------------------------------------------------------
amphibians <- read.delim("raw-data/gbif-amphibians-2021-04-21.txt", sep =  "\t", quote = "")

reptiles1 <- read.delim("raw-data/gbif-reptiles-2021-04-21.txt", sep =  "\t", nrows = 1000000, quote = "")
reptiles2 <- read.delim("raw-data/gbif-reptiles-2021-04-21.txt", sep =  "\t", skip = 1000000, nrows = 2000000, header = FALSE, quote = "")
reptiles3 <- read.delim("raw-data/gbif-reptiles-2021-04-21.txt", sep =  "\t", skip = 2000000, nrows = 3000000, header = FALSE, quote = "")
reptiles4 <- read.delim("raw-data/gbif-reptiles-2021-04-21.txt", sep =  "\t", skip = 3000000, header = FALSE, quote = "")

# Change headers so they match
names(reptiles2) <- names(reptiles1)
names(reptiles3) <- names(reptiles1)
names(reptiles4) <- names(reptiles1)

# Combine into a list
all <- list(amphibians, reptiles1, reptiles2, reptiles3, reptiles4)

# Combine based on shared columns
ds <- rbind(amphibians, reptiles1, reptiles2, reptiles3, reptiles4)

#----------------------------------
# Tidy up the data
#----------------------------------
ds2 <-
  
  ds %>%
  
  # Remove paleo collections from NHMUK data and other incorrect codes
  filter(collectionCode != "PAL" & collectionCode != "Birds" & 
         collectionCode != "" & collectionCode != "Fishes" &
         collectionCode != "BMNH(E)" & collectionCode != "BOT") %>%

  # Check that all included records are specimens not observations
  filter(basisOfRecord == "PRESERVED_SPECIMEN") %>%
  
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
  #filter(sex == "Male" | sex == "Female" | is.na(sex) | sex == "") %>%
  
  # Replace the poorly coded year data with NAs
  # This will throw a warning as it makes blanks and non numeric entries into NAs.
  mutate(year = as.numeric(as.character(year))) %>%
  mutate(year = ifelse(year > 2021 | year < 1750, NA_character_, year)) %>%
  # Coerce to numeric again
  mutate(year = as.numeric(year)) %>%
  
  # Add decade variable (function above)
  # This maps to character to deal with NAs so needs coercing back to numeric
  mutate(decade = map_chr(year, floor_decade)) %>%
  mutate(decade = as.numeric(decade)) %>%
  
  # TAXONOMY (note there is a second set of checks later)
  # 1. Remove entries where we only have the Genus
  # 2. Create binomial column
  separate(species, c("Genus", "Species"), sep = " ", 
           extra = "drop", fill = "right") %>%
  filter(!is.na(Species) & Species != "sp." & Species != "sp") %>%
  unite("binomial", Genus, Species, sep = " ") %>%
    
  # Remove entries with incorrect orders
  filter(order != "Dinosauria" & order != "" 
         & order != "395dfaad-8b0d-47e2-a2ea-bf8a3fd5c10c"
         & order != "beddb937-47b8-48f6-8efb-e347383aa9b5")  %>%
  
  # Remove classes that shouldn't be there
  filter(class != "Actinopterygii" & class != "Aves") %>%

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
  select(gbifID, institutionCode, specID, binomial, sex, class, order, family, genus,
         continent, countryCode, year, decade, typeStatus, type, iucnRedListCategory)

# To deal with the issues of "" rather than NA in some records
# write to file and then read back in for next step
# Write to file
write_csv(ds2, file = "raw-data/halfwaydone.csv")

#----------------------------------------------------------------
# Match taxonomy to Frost/Uetz
#----------------------------------------------------------------
# taxize is not working properly, so done semi-manually

# I've put in into another script called 01B-taxonomy-corrections-herps.R
# It takes ds2 and matches it up to the taxonomies then outputs a file for correcting
# the mismatches manually.

# This is then read back in below and merged to obtain the most up to date names
#------------------------------------------------------------------------------------
# Read data back in, with column designations as appropriate
# otherwise sex, year and decade become logical
ds2 <- readr::read_csv("raw-data/halfwaydone.csv", col_types = c("ccccccccciiccc"))

# Read in the two taxonomy files
amphibians <- read_csv("raw-data/amphibian-taxonomy-corrections.csv")
reptiles <- read_csv("raw-data/reptile-taxonomy-corrections.csv")

# Stick them together, and remove the family column as it is not needed.
taxonomy <- rbind(amphibians, reptiles)
taxonomy <- dplyr::select(taxonomy, -family)

# Merge the specimen dataset and taxonomy data
ds3 <- left_join(ds2, taxonomy, by = "binomial")

# Remove the now defunct original binomial and family columns 
# and then rename the _correct columns to make coding simpler
# Create a new genus column using the updated genera
# and remove the species column as it is also not needed
# And remove any row without binomial names
final <- 
  ds3 %>%
  dplyr::select(-binomial, -family, -genus) %>%
  rename(family = family_correct) %>%
  rename(binomial = binomial_correct) %>%
  separate(binomial, c("genus", "species"), sep = " ", remove = FALSE) %>%
  dplyr::select(-species) %>%
  filter(!is.na(binomial))
  
  
#------------------------------------------------------------------------------------
# Write to file for analyses
#-----------------------------------------------------

write_csv(final, file = "data/all-specimen-data-2021-04.csv")  

#------------------------------------------------------------------------------------
# Note that this was followed by a data quality check, scrolling through
# species names to check for obvious duplicates (i.e. very similar species names)
# to reduce mismatches caused by taxonomic differences.