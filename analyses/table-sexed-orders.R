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
specimens_all <- read_csv(here("data/all-specimen-data-unsexed-2021-07.csv")) 
specimens_all <- 
  specimens_all %>%
  mutate(sexed = case_when(is.na(sex) ~ "unsexed", !is.na(sex) ~ "sexed"))

#---------------------------------------------------------  
# Table S?
#---------------------------------------------------------  
# Orders summary
ds_orders <-
  specimens_all %>%
  group_by(class) %>%
  add_count(binomial, name = "n") %>%
  add_count(binomial, sexed, name = "nn") %>%
  filter(n >= 10 & sexed == "sexed") %>%
  rename(sexedY = nn) %>%
  mutate(unsexed = n - sexedY) %>%
  select(class, order, binomial, n, sexedY, unsexed) %>%
  mutate(percent = (sexedY/n) * 100) %>%
  distinct()

sum_orders <-
  ds_orders %>%
  group_by(class, order) %>%
  summarise('n species' = length(unique(binomial)),
            'n specimens' = sum(n),
            '% sexed' = round(median(percent),2))

table_orders <-
  xtable(sum_orders,
         caption = "Median percentages of sexed specimens within species with at least 
                   10 specimens, or each order of amphibians and reptiles.",
         label = "table-orders",
         align = c("l", "l", "l", "c", "c", "c"),
         digits = 2)

print(table_orders, file = here("manuscript/figures/table-sexed-orders.tex"), 
      include.rownames = FALSE, tabular.environment = 'longtable',
      floating = FALSE, caption.placement = "top", include.colnames = TRUE,
      sanatize.colnames.function = c("bold.cells"))
