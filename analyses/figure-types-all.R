# Figures for all and type specimens, for sexed and unsexed, 
# split by class and by order
# Natalie Cooper 
# Aug 2021
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
ds_all <-
  specimens %>%
  add_count(class, name = "n") %>%
  add_count(class, sex, name = "nn") %>%
  select(class, sex, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Just focus on types
# Exclude non-types and non-name-bearing types
ds_type <-
  specimens %>%
  filter(type == "Type") %>%
  add_count(class, type, name = "n") %>%
  add_count(class, sex, type, name = "nn") %>%
  select(class, sex, type, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Add unsexed sexed data
ds_all_unsexed <-
  specimens_all %>%
  add_count(class, name = "n") %>%
  add_count(class, sexed, name = "nn") %>%
  select(class, sexed, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Just focus on types
# Exclude non-types and non-name-bearing types
ds_type_unsexed <-
  specimens_all %>%
  filter(type == "Type") %>%
  add_count(class, type, name = "n") %>%
  add_count(class, sexed, type, name = "nn") %>%
  select(class, sexed, type, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

#---------------------------------------------------------------
# Make the plots
#---------------------------------------------------------------
plot_all <-
  ggplot(ds_all, aes(y = percent, x = class, fill = sex)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[3], cbPalette[4]),
                    name = "Sex",
                    breaks = c("Female", "Male"),
                    labels = c("Female", "Male")) +
  ylim(0, 101) +
  theme(legend.position = "none")

plot_types <-
  ggplot(ds_type, aes(y = percent, x = class, fill = sex)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% type specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[3], cbPalette[4]),
                    name = "Sex",
                    breaks = c("Female", "Male"),
                    labels = c("Female", "Male")) +
  ylim(0, 101)

# Unsexed

plot_all_unsexed <-
  ggplot(ds_all_unsexed, aes(y = percent, x = class, fill = sexed)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[2], cbPalette[1]),
                    name = "Sexed") +
  ylim(0, 101) +
  theme(legend.position = "none")

plot_types_unsexed <-
  ggplot(ds_type_unsexed, aes(y = percent, x = class, fill = sexed)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% type specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[2], cbPalette[1]),
                    name = "Sexed") +
  ylim(0, 101)


#---------------
# Plot and save
#---------------
plot <- (plot_all + plot_types)/ (plot_all_unsexed + plot_types_unsexed)

#ggsave(file = here("figures/types-class.png"), plot, width = 7)

#--------------------------------------
# By ORDER
#--------------------------------------

#----------------------------------------------
# Create datasets for plots
#----------------------------------------------
ds_all_order <-
  specimens %>%
  add_count(class, order, name = "n") %>%
  add_count(class, order, sex, name = "nn") %>%
  select(class, order, sex, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Just focus on types
# Exclude non-types and non-name-bearing types
ds_type_order <-
  specimens %>%
  filter(type == "Type") %>%
  add_count(class, order, type, name = "n") %>%
  add_count(class, order, sex, type, name = "nn") %>%
  select(class, order, sex, type, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Add unsexed sexed data
ds_all_unsexed_order <-
  specimens_all %>%
  add_count(class, order, name = "n") %>%
  add_count(class, order, sexed, name = "nn") %>%
  select(class, order, sexed, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

# Just focus on types
# Exclude non-types and non-name-bearing types
ds_type_unsexed_order <-
  specimens_all %>%
  filter(type == "Type") %>%
  add_count(class, order, type, name = "n") %>%
  add_count(class, order, sexed, type, name = "nn") %>%
  select(class, order, sexed, type, n, nn) %>%
  distinct() %>%
  mutate(percent = round(nn/n*100, 2))

#---------------------------------------------------------------
# Make the plots
#---------------------------------------------------------------
plot_all_order <-
  ggplot(ds_all_order, aes(y = percent, x = order, fill = sex)) +
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
  theme(legend.position = "top")

plot_types_order <-
  ggplot(ds_type_order, aes(y = percent, x = order, fill = sex)) +
  geom_col(alpha = 0.8, position = position_stack(reverse = TRUE)) +
  ylab("% type specimens") +
  xlab("") +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = c(cbPalette[3], cbPalette[4]),
                    name = "Sex",
                    breaks = c("Female", "Male"),
                    labels = c("Female", "Male")) +
  coord_flip() +
  ylim(0, 101) +
  theme(legend.position = "none") 

# Unsexed
plot_all_unsexed_order <-
  ggplot(ds_all_unsexed_order, aes(y = percent, x = order, fill = sexed)) +
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
  remove_y

plot_types_unsexed_order <-
  ggplot(ds_type_unsexed_order, aes(y = percent, x = order, fill = sexed)) +
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
  remove_y


#---------------
# Plot and save
#---------------
plot2 <- (plot_all_order + plot_all_unsexed_order)/ (plot_types_order + plot_types_unsexed_order)

#ggsave(file = here("figures/types-order.png"), plot2, width = 7)

#--------------------------------------
# By FAMBLY
#--------------------------------------

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