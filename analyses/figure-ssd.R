# Figure for years
# Natalie Cooper
# Apr 2022
#------------------------------------
# Load libraries
library(tidyverse)
library(here)
library(patchwork)

# Colour blind friendly palette
# First is grey
# Colour blind friendly palette
cbPalette <- c("#999999", "#a53606", "#b32db5", "#881a58", "#0e288e", "#164c64")

# Helper functions for plotting
remove_x <- 
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

# Read in all the specimen data and body size data
extra <- read_csv(here("data/extra-data-sexed-2022-04.csv"))

# Add ssd (male/female)
extra <- mutate(extra, ssd = max_male / max_female)

# Reformat data
ds_size <-
  extra %>%
  group_by(class) %>%
  add_count(binomial, name = "n") %>%
  add_count(binomial, sex, name = "nn") %>%
  select(class, order, binomial, sex, n, nn, max_body_size_mm, max_male, max_female, ssd, larger_sex) %>%
  # Add in data for species with no males or no females
  complete(sex, nesting(order, class, binomial, n), fill = list(nn = 0)) %>%
  filter(n >= 10 & sex == "Female") %>%
  rename(female = nn) %>%
  mutate(male = n - female) %>%
  mutate(percentf = (female/n) * 100) %>%
  distinct()

#-------------------------------------------------------------------
# Plot % female against body size
#-------------------------------------------------------------------
plot_size <-   
ggplot(ds_size, aes(x = log(max_body_size_mm), y = percentf/100, colour = class)) +
  geom_point(alpha = 0.6, size = 0.8) +
  geom_abline(slope = 0, intercept = 0.5, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("ln(maximum body size)") +
  #ylim(0, 1) +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  xlim(2, 9) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

plot_size
#ggsave("figures/size-all.png", plot_size, width = 7)

#-------------------------------------------------------------------
# Plot % female against body size of males
#-------------------------------------------------------------------
plot_size_males <-   
  ggplot(ds_size, aes(x = log(max_male), y = percentf/100, colour = class)) +
  geom_point(alpha = 0.6, size = 0.8) +
  geom_abline(slope = 0, intercept = 0.5, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("ln(maximum body size)") +
  #ylim(0, 1) +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  xlim(2, 9) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

plot_size_males

#ggsave("figures/size-males.png", plot_size_males, width = 7)

#-------------------------------------------------------------------
# Plot % female against body size of females
#-------------------------------------------------------------------
plot_size_females <-   
  ggplot(ds_size, aes(x = log(max_female), y = percentf/100, colour = class)) +
  geom_point(alpha = 0.6, size = 0.8) +
  geom_abline(slope = 0, intercept = 0.5, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("ln(maximum body size)") +
  #ylim(0, 1) +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  xlim(2, 9) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

plot_size_females

#ggsave("figures/size-females.png", plot_size_females, width = 7)

#-------------------------------------------------------------------
# Plot % female against body size of males
#-------------------------------------------------------------------
plot_size_ssd <-   
  ggplot(ds_size, aes(x = ssd, y = percentf/100, colour = class)) +
  geom_point(alpha = 0.6, size = 0.8) +
  geom_abline(slope = 0, intercept = 0.5, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("SSD") +
  #ylim(0, 1) +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  xlim(0, 2) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  geom_vline(xintercept = 1, linetype = 3) +
  facet_wrap(~class, ncol = 1)

plot_size_ssd

#ggsave("figures/size-ssd.png", plot_size_ssd, width = 7)

#---------------------------------------------------------
# Larger sex
#---------------------------------------------------------
ds_size_larger <-
  ds_size %>%
  filter(!is.na(larger_sex) & larger_sex != "Parthenogenetic")

plot_size_larger <-
ggplot(ds_size_larger, aes(x = larger_sex, y = percentf/100, fill = class)) +
  geom_boxplot(alpha = 0.6) +
  geom_abline(slope = 0, intercept = 0.5, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("larger sex") +
  scale_fill_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

# Numbers in the figure
ds_size_larger %>% group_by(class, larger_sex) %>% summarise(n())
ds_size_larger %>% group_by(larger_sex) %>% summarise(n())
ds_size_larger %>% ungroup() %>% summarise(n())
#--------------------------------------------------------
# Combine
#---------------------------------------------------------

(plot_size + plot_size_females + plot_size_males) / 
  (plot_size_ssd + plot_size_larger) + plot_annotation(tag_levels = 'A')
   
#ggsave("figures/size-combined.png", height = 7, width = 9)
   