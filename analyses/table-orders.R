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
# Table S1
#---------------------------------------------------------  
# Orders summary
ds_orders <-
  specimens %>%
  group_by(class) %>%
  add_count(binomial, name = "n") %>%
  add_count(binomial, sex, name = "nn") %>%
  filter(n >= 10 & sex == "Female") %>%
  rename(female = nn) %>%
  mutate(male = n - female) %>%
  select(class, order, binomial, n, female, male) %>%
  mutate(percentf = (female/n) * 100) %>%
  distinct()

sum_orders <-
  ds_orders %>%
  group_by(class, order) %>%
  summarise('n species' = length(unique(binomial)),
            'n specimens' = sum(n),
            '% female' = round(median(percentf),2))

table_orders <-
  xtable(sum_orders,
         caption = "Median percentages of female specimens within species with at least 
                   10 specimens, or each order of amphibians and reptiles. 
                   Orders with median percentages of female specimens of over 50% are in bold.",
         label = "table-orders",
         align = c("l", "l", "l", "c", "c", "c"),
         digits = 2)

print(table_orders, file = here("manuscript/figures/table-orders.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))
