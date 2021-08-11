# Make tables for supplemental materials

#-----------------------  
# Preliminaries

# Load libraries
library(tidyverse)
library(patchwork) # from GitHub
library(png)
library(knitr)
library(broom)
library(here)
library(xtable)

# Read in all the specimen data
specimens <- read_csv(here("data/all-specimen-data-2021-07.csv")) 

#---------------------------------------------------------  
# Table S?
#---------------------------------------------------------  
# Best and worst species
best <-
  specimens %>%
  add_count(class, binomial, name = "n") %>%
  add_count(class, binomial, sex, name = "nn") %>%
  select(class, binomial, sex, n, nn) %>%
  # Add in data for species with no males or no females
  complete(sex, nesting(class, binomial, n), fill = list(nn = 0)) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2)) %>%
  filter(sex == "Female" & n >= 10) %>%
  arrange(class, -percent) %>%
  filter(percent >=75) %>%
  select(class, binomial, `n specimens` = n, 
         `% female` = percent)

worst <-
  specimens %>%
  add_count(class, binomial, name = "n") %>%
  add_count(class, binomial, sex, name = "nn") %>%
  select(class, binomial, sex, n, nn) %>%
  # Add in data for species with no males or no females
  complete(sex, nesting(class, binomial, n), fill = list(nn = 0)) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2)) %>%
  filter(sex == "Female" & n >= 10) %>%
  arrange(class, percent) %>%
  filter(percent <=25) %>%
  select(class, binomial, `n specimens` = n, 
         `% female` = percent)

table_best <-
  xtable(best,
         caption = "Best with >=10 specimens over 75% female",
         label = "table-best",
         align = c("l", "l", "l", "c", "c"),
         digits = 2)

table_worst <-
  xtable(worst,
         caption = "Worst with >=10 specimens under 25% female",
         label = "table-best",
         align = c("l", "l", "l", "c", "c"),
         digits = 2)

print(table_best, file = here("manuscript/figures/table-best.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))

print(table_worst, file = here("manuscript/figures/table-worst.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))
