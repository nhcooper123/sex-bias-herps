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
# Create datasets for plots
#----------------------------------------------
ds_all_family <-
  specimens %>%
  add_count(class, order, family, name = "n") %>%
  add_count(class, order, family, sex, name = "nn") %>%
  select(class, order,family, sex, n, nn) %>%
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

# Remove tuatara
ds_all_family <- filter(ds_all_family, order != "Rhynchocephalia")
ds_all_unsexed_family <- filter(ds_all_unsexed_family, order != "Rhynchocephalia")

# Split amphibians and reptiles
ds_all_family_a <- filter(ds_all_family, class == "Amphibians")
ds_all_family_r <- filter(ds_all_family, class == "Reptiles")

ds_all_unsexed_family_a <- filter(ds_all_unsexed_family, class == "Amphibians")
ds_all_unsexed_family_r <- filter(ds_all_unsexed_family, class == "Reptiles")

#------------------------------------
# Higher taxon summary for squamates
#------------------------------------

ds_squamata <-
  specimens %>%
  add_count(class, order, higher2, name = "n") %>%
  add_count(class, order, higher2, sex, name = "nn") %>%
  filter(order == "Squamata") %>%
  select(higher2, sex, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2)) 

#---------------------------------------------------------------
# Make the plots
#---------------------------------------------------------------
# Amphibians
plot_all_family_a <-
  ggplot(ds_all_family_a, aes(y = percent, x = family, fill = sex)) +
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

# Unsexed
plot_all_unsexed_family_a <-
  ggplot(ds_all_unsexed_family_a, aes(y = percent, x = family, fill = sexed)) +
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

#---------------
# Plot and save
#---------------

#ggsave(plot_all_family_a, file = here("figures/all-family-amphibians.png"), width = 7)
#ggsave(plot_all_unsexed_family_a, file = here("figures/all-unsexed-family-amphibians.png"), width = 7)

#---------------
# Reptiles

plot_all_family_r <-
  ggplot(ds_all_family_r, aes(y = percent, x = family, fill = sex)) +
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

# Unsexed
plot_all_unsexed_family_r <-
  ggplot(ds_all_unsexed_family_r, aes(y = percent, x = family, fill = sexed)) +
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

#---------------
# Plot and save
#---------------

#ggsave(plot_all_family_r, file = here("figures/all-family-reptiles.png"), width = 7)
#ggsave(plot_all_unsexed_family_r, file = here("figures/all-unsexed-family-reptiles.png"), width = 7)

#---------------
# Higher for squamata
#------------------

plot_squamata <-
  ggplot(ds_squamata, aes(y = percent, x = higher2, fill = sex)) +
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
  theme(axis.text.y = element_text(size = 10))

# Unsexed
plot_unsexed_squamata <-
  ggplot(ds_unsexed_squamata, aes(y = percent, x = higher2, fill = sexed)) +
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

#---------------
# Plot and save
#---------------

#ggsave(plot_all_family_r, file = here("figures/all-family-reptiles.png"), width = 7)
#ggsave(plot_all_unsexed_family_r, file = here("figures/all-unsexed-family-reptiles.png"), width = 7)
