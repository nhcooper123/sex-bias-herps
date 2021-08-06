# Figure for years
# Natalie Cooper
# Aug 2021
#------------------------------------
# Load libraries
library(tidyverse)
library(here)

# Colour blind friendly palette
# First is grey
# Colour blind friendly palette
cbPalette <- c("#999999", "#a53606", "#b32db5", "#881a58", "#0e288e", "#164c64")
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
  filter(n >= 10 & sex == "Female" & year > 1880) %>%
  rename(female = nn) %>%
  mutate(male = n - female) %>%
  select(class, order, binomial, year, decade, n, female, male) %>%
  mutate(percentf = (female/n) * 100) %>%
  distinct()

#-------------------------------------------------------------------
# Plot % female by year
plot_year <-   
ggplot(ds_years, aes(x = year, y = percentf/100, colour = class)) +
  geom_point(alpha = 0.8, size = 0.8) +
  geom_smooth(method = "glm",
              method.args = list(family = "quasibinomial"), 
              col = "darkgrey", size = 0.5) +
  geom_abline(slope = 0, intercept = 0.5, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("Collection year") +
  #ylim(0, 1) +
  scale_colour_manual(values = c(cbPalette[c(3:5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  xlim(1880, 2020) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

plot_year
ggsave("figures/years-all.png", plot_year, width = 7)
