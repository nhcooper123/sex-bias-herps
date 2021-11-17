# Figure for years
# Natalie Cooper
# Nov 2021
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
#------------------------------------
# Read in all the specimen data
specimens <- read_csv(here("data/all-specimen-data-2021-07.csv")) 

# Summarise by species by year
# Extract numbers of males and females
# proportions, and totals
# Remove species with < 10 specimens
# And the two points before 1880
ds_years <-
  specimens %>%
  filter(!is.na(year)) %>%
  group_by(class) %>%
  add_count(binomial, year, name = "n") %>%
  add_count(binomial, year, sex, name = "nn") %>%
  select(class, order, binomial, year, sex, n, nn) %>%
  # Add in data for species with no males or no females
  complete(sex, nesting(class, order, binomial, year, n), fill = list(nn = 0)) %>%
  filter(n >= 10 & sex == "Female" & year > 1880) %>%
  rename(female = nn) %>%
  mutate(male = n - female) %>%
  select(class, order, binomial, year,  n, female, male) %>%
  mutate(percentf = (female/n) * 100) %>%
  distinct()

#-------------------------------------------------------------------
# Plot % female by year
plot_year <-   
ggplot(ds_years, aes(x = year, y = percentf/100, colour = class)) +
  geom_point(alpha = 0.6, size = 0.8) +
  geom_smooth(method = "glm",
              method.args = list(family = "quasibinomial"), 
              col = "darkgrey", size = 0.5) +
  geom_abline(slope = 0, intercept = 0.5, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("Collection year") +
  #ylim(0, 1) +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  xlim(1880, 2020) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

plot_year
#ggsave("figures/years-all.png", plot_year, width = 7)

#--------------------------------------------------------
# Add unsexed plots
#---------------------------------------------------------
# Read in all the specimen data
specimens_all <- read_csv(here("data/all-specimen-data-unsexed-2021-07.csv")) 
# Create sexed column
specimens_all <- 
  specimens_all %>%
  mutate(sexed = case_when(is.na(sex) ~ "unsexed", !is.na(sex) ~ "sexed"))

# First set up dataset
# Exclude the two points before 1880 as they skew the analyses and plots
ds_years_all <-
  specimens_all %>%
  filter(!is.na(year)) %>%
  group_by(class) %>%
  add_count(binomial, year, name = "n") %>%
  add_count(binomial, year, sexed, name = "nn") %>%
  select(class, order, binomial, year, sexed, n, nn) %>%
  # Add in data for species with no males or no females
  complete(sexed, nesting(class, order, binomial, year, n), fill = list(nn = 0)) %>%
  filter(n >= 10 & sexed == "sexed" & year > 1880) %>%
  rename(sexedY = nn) %>%
  mutate(unsexed = n - sexedY) %>%
  select(class, order, binomial, year, n, sexedY, unsexed) %>%
  mutate(percent = (sexedY/n) * 100) %>%
  distinct()

# Plot
plot_year_sex <-   
  ggplot(ds_years_all, aes(x = year, y = percent/100, colour = class)) +
  geom_point(alpha = 0.6, size = 0.8) +
  geom_smooth(method = "glm",
              method.args = list(family = "quasibinomial"), 
              col = "darkgrey", size = 0.5) +
  theme_bw(base_size = 14) +
  ylab("% sexed specimens") +
  xlab("Collection year") +
  #ylim(0, 1) +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  xlim(1880, 2020) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

plot_year_sex

#ggsave("figures/years-all-unsexed.png", plot_year, width = 7)

#--------------------------------------------------------
# Add total specimens plots
#---------------------------------------------------------
# Plot

year_totals <-
  ds_years_all %>%
  group_by(class, year) %>%
  summarise(total = n())

plot_year_totals <-   
  ggplot(year_totals, aes(x = year, y = total, colour = class)) +
  geom_line(alpha = 0.8, size = 0.8) +
  theme_bw(base_size = 14) +
  ylab("all specimens") +
  xlab("Collection year") +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  xlim(1880, 2020) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1) +
  remove_x

plot_year_totals

year_totals_sexed <-
  ds_years %>%
  group_by(class, year) %>%
  summarise(total = n())

plot_year_totals_sexed <-   
  ggplot(year_totals_sexed, aes(x = year, y = total, colour = class)) +
  geom_line(alpha = 0.8, size = 0.8) +
  theme_bw(base_size = 14) +
  ylab("sexed specimens") +
  xlab("Collection year") +
  scale_colour_manual(values = c(cbPalette[c(3,5)])) +
  xlim(1880, 2020) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1) +
  remove_x

plot_year_totals_sexed + plot_year_totals

#ggsave("figures/years-total-specimens.png", width = 7)

#--------------------------------------------------------
# Combine
#---------------------------------------------------------

(plot_year_totals_sexed + plot_year_totals) / (plot_year + plot_year_sex)

#ggsave("figures/years-combined-totals.png", height = 7)

plot_year + plot_year_sex

#ggsave("figures/years-combined.png", width = 7)
