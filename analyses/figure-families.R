# Figures for all and type specimens, for sexed and unsexed, 
# split by family
# Natalie Cooper 
# July 2022
#------------------------
# Load libraries
library(tidyverse)
library(viridis)
library(patchwork)

# Colour blind friendly palette
# First is grey
# Colour blind friendly palette
cbPalette <- c("#999999", "#146B3A", "#F8B229", "#EA4630")

# Helper functions for plotting
remove_x <- 
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

remove_y <- 
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

#------------------------
# Read in all the data
#------------------------
specimens <- read_csv(here("data/all-specimen-data-2021-07.csv"))

specimens <- 
  specimens %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

specimens_all <- read_csv(here("data/all-specimen-data-unsexed-2021-07.csv"))

# Add sexed unsexed column
specimens_all <- 
  specimens_all %>%
  mutate(sexed = case_when(is.na(sex) ~ "unsexed", !is.na(sex) ~ "sexed")) %>%
  mutate(order = factor(order, levels = c("Anura", "Caudata", "Gymnophiona", 
                                          "Crocodylia", "Rhynchocephalia", 
                                          "Squamata","Testudines")))

#----------------------------------------------
# For squamates swap family for higher2
# Fill in gaps where higher2 did not exist first
#----------------------------------------------
specimens <- 
  specimens %>%
  # correct to anguimorpha
    mutate(higher2 = case_when(higher2 == "Anguiformes" ~ "Anguimorpha",
                               TRUE ~ as.character(higher2))) %>%
  # add missing higher taxon names  
  mutate(higher2 = case_when(family == "Aniliidae" ~ ,     
                             family == "Anomalepididae" ~ ,
                             family == "Anomochilidae" ~ , 
                             family == "Bipedidae" ~ "Lacertoidea",     
                             family == "Blanidae" ~ "Lacertoidea",       
                             family == "Bolyeriidae" ~ ,   
                             family == "Dibamidae" ~ "Dibamia",     
                             family == "Gerrhopilidae" ~ , 
                             family == "Lanthanotidae" ~ "Anguimorpha", 
                             family == "Loxocemidae" ~ ,   
                             family == "Pareidae" ~ ,      
                             family == "Rhineuridae" ~ "Lacertoidea",   
                             family == "Shinisauridae" ~ "Anguimorpha", 
                             family == "Trogonophidae" ~ "Lacertoidea", 
                             family == "Tropidophiidae" ~ "Pleurodonta",
                             family == "Xenodermidae" ~ ,  
                             family == "Xenophidiidae" ~ ,
                             TRUE ~ as.character(family))) %>%
    mutate(family = case_when(order == "Squamata" ~ higher2,
                              TRUE ~ as.character(family))) 

specimens_all <- 
  specimens_all %>%
  mutate(family = case_when(order == "Squamata" ~ higher2,
                            TRUE ~ as.character(family))) 
#----------------------------------------------
# Create datasets for plots
#----------------------------------------------
ds_all_family <-
  specimens %>%
  add_count(class, order, family, name = "n") %>%
  add_count(class, order, family, sex, name = "nn") %>%
  select(class, order,family, sex, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Just focus on types
# Exclude non-types and non-name-bearing types
ds_type_family <-
  specimens %>%
  filter(type == "Type") %>%
  add_count(class, order, family, type, name = "n") %>%
  add_count(class, order, family, sex, type, name = "nn") %>%
  select(class, order, family, sex, type, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Add unsexed sexed data
ds_all_unsexed_family <-
  specimens_all %>%
  add_count(class, order, family, name = "n") %>%
  add_count(class, order, family, sexed, name = "nn") %>%
  select(class, order, family, sexed, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Just focus on types
# Exclude non-types and non-name-bearing types
ds_type_unsexed_family <-
  specimens_all %>%
  filter(type == "Type") %>%
  add_count(class, order,family, type, name = "n") %>%
  add_count(class, order, family,sexed, type, name = "nn") %>%
  select(class, order, family,sexed, type, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

#---------------------------------------------------------------
# Make the plots
#---------------------------------------------------------------

# Remove tuatara
ds_all_family <- filter(ds_all_family, order != "Rhynchocephalia")
ds_all_unsexed_family <- filter(ds_all_unsexed_family, order != "Rhynchocephalia")

plot_all_family <-
  ggplot(ds_all_family, aes(y = percent, x = family, fill = sex)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[3], cbPalette[4]),
                    name = "Sex",
                    breaks = c("Female", "Male"),
                    labels = c("Female", "Male")) +
  coord_flip() +
  ylim(0, 101) +
  theme(legend.position = "top") +
  theme(axis.text.y = element_text(size = 5)) +
  facet_wrap(~order, scales = "free") +
  theme(strip.background = element_rect(fill = "white"))

plot_types_family <-
  ggplot(ds_type_family, aes(y = percent, x = family, fill = sex)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% type specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  theme(axis.text=element_text(size=12)) +
  scale_fill_manual(values = c(cbPalette[3], cbPalette[4]),
                    name = "Sex",
                    breaks = c("Female", "Male"),
                    labels = c("Female", "Male")) +
  coord_flip() +
  ylim(0, 101) +
  theme(legend.position = "none") +
  theme(axis.text.y = element_text(size = 5)) +
  facet_wrap(~order, scales = "free") +
  theme(strip.background = element_rect(fill = "white"))

# Unsexed
plot_all_unsexed_family <-
  ggplot(ds_all_unsexed_family, aes(y = percent, x = family, fill = sexed)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[2], cbPalette[1]),
                    name = "Sexed") +
  coord_flip() +
  ylim(0, 101) +
  theme(legend.position = "top") +
  remove_y+
  theme(axis.text.y = element_text(size = 5)) +
  facet_wrap(~order, scales = "free") +
  theme(strip.background = element_rect(fill = "white"))

plot_types_unsexed_family <-
  ggplot(ds_type_unsexed_family, aes(y = percent, x = family, fill = sexed)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% type specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[2], cbPalette[1]),
                    name = "Sexed") +
  coord_flip() +
  ylim(0, 101) +
  theme(legend.position = "none") +
  remove_y+
  theme(axis.text.y = element_text(size = 5)) +
  facet_wrap(~order, scales = "free") +
  theme(strip.background = element_rect(fill = "white"))

#---------------
# Plot and save
#---------------

#ggsave(plot_all_family, file = here("figures/all-family.png"), width = 7)
#ggsave(plot_all_unsexed_family, file = here("figures/all-unsexed-family.png"), width = 7)
#ggsave(plot_types_family, file = here("figures/types-family.png"), width = 7)
#ggsave(plot_types_unsexed_family, file = here("figures/types-unsexed-family.png"), width = 7)
