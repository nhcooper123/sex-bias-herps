# Make tables for supplemental materials
# August 2022
#-----------------------  
# Preliminaries

# Load libraries
library(tidyverse)
library(patchwork)
library(png)
library(knitr)
library(broom)
library(here)
library(xtable)

# Read in all the specimen data
specimens <- read_csv(here("data/all-specimen-data-2021-07.csv")) 
specimens_all <- read_csv(here("data/all-specimen-data-unsexed-2021-07.csv")) 
#---------------------------------------------------------  
# Table ???
#---------------------------------------------------------  
## Which are the worst contenders?
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
  arrange(class, percent)

# Subset out reptiles
worstr <- filter(worst, class == "Reptiles")
# Stick together worst 25 for each class
worst_both <- rbind(worst[1:25, ], worstr[1:25, ])
# Remove sex and nn column
worst_both <- select(worst_both, -sex, -nn)

table_worst <-
  xtable(worst_both,
         caption = "Top 25 species of amphibians and reptiles with the most extreme male-biased sex ratios
                  in our data.",
         label = "table_worst",
         align = c("l", "l", ">{\\itshape}l", "c", "c"),
         digits = 2)

colnames(table_worst) <- c("class", "binomial", "n specimens", "% female")

print(table_worst, file = here("outputs/table-worst.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))

#---------------------------------------------------------  
# Table ???
#---------------------------------------------------------  
## Which are the best contenders?

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
  arrange(class, -percent)

# Subset out reptiles
bestr <- filter(best, class == "Reptiles")
# Stick together best 25 for each class
best_both <- rbind(best[1:25, ], bestr[1:25, ])
# Remove sex and nn column
best_both <- select(best_both, -sex, -nn)

table_best <-
  xtable(best_both,
         caption = "Top 25 species of amphibians and reptiles with the most extreme female-biased sex ratios
                  in our data.",
         label = "table_worst",
         align = c("l", "l", ">{\\itshape}l", "c", "c"),
         digits = 2)

colnames(table_best) <- c("class", "binomial", "n specimens", "% female")

print(table_best, file = here("outputs/table-best.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))

#---------------------------------------------------------  
# Table ???
#---------------------------------------------------------  
# Families summary
ds_family <-
  specimens %>%
  add_count(class, order, family, name = "n") %>%
  add_count(class, order, family, sex, name = "nn") %>%
  select(class, order, family, binomial, sex, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Split by class
sum_family_amphibians <-
  ds_family %>%
  filter(class == "Amphibians") %>%
  group_by(order, family) %>%
  summarise('n species' = length(unique(binomial)),
            'n specimens' = sum(n),
            '% female' = round(median(percent),2))

sum_family_reptiles <-
  ds_family %>%
  filter(class == "Reptiles") %>%
  group_by(order, family) %>%
  summarise('n species' = length(unique(binomial)),
            'n specimens' = sum(n),
            '% female' = round(median(percent),2))

table_family_amphibians <-
  xtable(sum_family_amphibians,
         caption = "Percentages of female specimens for each family of amphibians.",
         label = "table-family_amphibians",
         align = c("l", "l", "l", "c", "c", "c"),
         digits = 2)

print(table_family_amphibians, file = here("outputs/table-family_amphibians.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))

table_family_reptiles <-
  xtable(sum_family_reptiles,
         caption = "Percentages of female specimens for each family of reptiles.",
         label = "table-family_reptiles",
         align = c("l", "l", "l", "c", "c", "c"),
         digits = 2)

print(table_family_reptiles, file = here("outputs/table-family_reptiles.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))

#---------------------------------------------------------  
# Table ???
#---------------------------------------------------------  
# Higher taxon summary
ds_higher <-
  specimens %>%
  add_count(class, order, higher2, name = "n") %>%
  add_count(class, order, higher2, sex, name = "nn") %>%
  select(class, order, higher2, binomial, sex, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Subset out squamates
sum_squamates <-
  ds_higher %>%
  filter(order == "Squamata") %>%
  group_by(higher2) %>%
  summarise('n species' = length(unique(binomial)),
            'n specimens' = sum(n),
            '% female' = round(median(percent),2))

table_squamates <-
  xtable(sum_squamates,
         caption = "Percentages of female specimens for each more inclusive taxonomic grouping of squamates.",
         label = "table-squamates",
         align = c("l", "l", "l", "c", "c", "c"),
         digits = 2)

print(table_squamates, file = here("outputs/table-squamates.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))
