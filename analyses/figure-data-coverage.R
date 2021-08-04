# Data coverage across orders 
# Natalie Cooper
# Aug 2021



# Load libraries

library(tidyverse)
library(knitr)
library(patchwork)
library(here)

# Helper functions for plotting
remove_x <- 
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

remove_y <- 
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

# Colour blind friendly palette
# First is grey
# Colour blind friendly palette
cbPalette <- c("#999999", "#a53606", "#b32db5", "#881a58", "#0e288e", "#164c64")

# Read in all the specimen data
specimens <- read_csv(here("data/all-specimen-data-2021-07.csv")) 
specimens_all <- read_csv(here("data/all-specimen-data-unsexed-2021-07.csv")) 

# Read in list of total species per order
taxa <- read_csv(here("raw-data/taxa_april2021.csv"))

# Calculate the number of specimens and species per order, and % species coverage for each order, for sexed specimens only.
# Extract sexed specimens per order
specs <- 
  specimens %>%
  group_by(class, order) %>%
  summarise(Nspecs = n()) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

# Extract species per order
species <- 
  specimens %>%
  select(class, order, binomial) %>%
  distinct() %>%
  group_by(class, order) %>%
  summarise(Nspecies = n()) %>%
  full_join(taxa) %>%
  mutate(percent = (Nspecies/species) * 100) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

#write_csv(species, here("outputs/taxonomy-coverage-sexed.csv"))

# Calculate the number of specimens and species per order, and % species coverage for each order, for females and males separately specimens only.
# Extract sexed specimens per order
specs_female <- 
  specimens %>%
  filter(sex == "Female") %>%
  group_by(class, order) %>%
  summarise(Nspecs = n()) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

# Extract species per order
species_female <- 
  specimens %>%
  filter(sex == "Female") %>%
  select(class, order, binomial) %>%
  distinct() %>%
  group_by(class, order) %>%
  summarise(Nspecies = n()) %>%
  full_join(taxa) %>%
  mutate(percent = (Nspecies/species) * 100) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

# Extract sexed specimens per order
specs_male <- 
  specimens %>%
  filter(sex == "Male") %>%
  group_by(class, order) %>%
  summarise(Nspecs = n()) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

# Extract species per order
species_male <- 
  specimens %>%
  filter(sex == "Male") %>%
  select(class, order, binomial) %>%
  distinct() %>%
  group_by(class, order) %>%
  summarise(Nspecies = n()) %>%
  full_join(taxa) %>%
  mutate(percent = (Nspecies/species) * 100) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))
# Calculate the number of specimens and species per order, and % species coverage for each order, for non-sexed specimens only.
# Extract sexed specimens per order
specs_all <- 
  specimens_all %>%
  filter(is.na(sex)) %>%
  group_by(class, order) %>%
  summarise(Nspecs = n()) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

# Extract species per order
species_all <- 
  specimens_all %>%
  filter(is.na(sex)) %>%
  select(class, order, binomial) %>%
  distinct() %>%
  group_by(class, order) %>%
  summarise(Nspecies = n()) %>%
  full_join(taxa) %>%
  mutate(percent = (Nspecies/species) * 100) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

#write_csv(species, here("outputs/taxonomy-coverage-unsexed.csv"))

### Plots of coverage

# specimens female only
p1 <-
  ggplot(specs_female, aes(y = log(Nspecs), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  ylim(0,15) +
  coord_flip() +
  theme_bw(base_size = 14) +
  xlab("female") +
  ylab("log(specimens)") +
  theme(legend.position = "none") +
  remove_x
 
# species female only
p2 <-
  ggplot(species_female, aes(y = log(Nspecies+1), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  ylim(0, 10) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("log(species+1)") +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#% coverage species female only
p3 <-
  ggplot(species_female, aes(y = percent, x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("coverage (%)") +
  theme(legend.position = "none") +
  remove_y +
  remove_x

# specimens male only
p4 <-
  ggplot(specs_male, aes(y = log(Nspecs), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  ylim(0, 15) +
  coord_flip() +
  theme_bw(base_size = 14) +
  xlab("male") +
  ylab("log(specimens)") +
  theme(legend.position = "none") +
  remove_x

# species male only
p5 <-
  ggplot(species_male, aes(y = log(Nspecies+1), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  scale_y_continuous(breaks = c(0,2,4,6,8,10), limits = c(0,10)) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("log(species+1)") +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#% coverage species male only
p6 <-
  ggplot(species_male, aes(y = percent, x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("coverage (%)") +
  theme(legend.position = "none") +
  remove_y +
  remove_x

# specimens sexed only
p7 <-
  ggplot(specs, aes(y = log(Nspecs), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  ylim(0,15) +
  coord_flip() +
  theme_bw(base_size = 14) +
  xlab("sexed") +
  ylab("log(specimens)") +
  theme(legend.position = "none") +
  remove_x
 
# species sexed only
p8 <-
  ggplot(species, aes(y = log(Nspecies+1), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  ylim(0, 10) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("log(species+1)") +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#% coverage species sexed only
p9 <-
  ggplot(species, aes(y = percent, x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("coverage (%)") +
  theme(legend.position = "none") +
  remove_y +
  remove_x

# specimens unsexed only
p10 <-
  ggplot(specs_all, aes(y = log(Nspecs), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  ylim(0, 15) +
  coord_flip() +
  theme_bw(base_size = 14) +
  xlab("unsexed") +
  ylab("log(specimens)") +
  theme(legend.position = "none") 

# species unsexed only
p11 <-
  ggplot(species_all, aes(y = log(Nspecies+1), x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  scale_y_continuous(breaks = c(0,2,4,6,8,10), limits = c(0,10)) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("log(species+1)") +
  theme(legend.position = "none") +
  remove_y

#% coverage species unsexed only
p12 <-
  ggplot(species_all, aes(y = percent, x = order, fill = class)) + 
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  coord_flip() +
  theme_bw(base_size = 14) +
  ylab("coverage (%)") +
  theme(legend.position = "none") +
  remove_y

# Create megaplot
(p1 + p2 + p3) / (p4 + p5 + p6) /
(p7 + p8 + p9) / (p10 + p11 + p12)

# Save plot
#ggsave(here("figures/order-data-coverage.png"), height = 7)