# Figures for classes and orders for sexed and unsexed
# Natalie Cooper 
# Aug 2021
#------------------------
# Load libraries
library(tidyverse)
library(viridis)
library(patchwork)
library(rphylopic)
library(grid)

# Read in phylopics
library(png)
img_frog <- readPNG(here("img/frog.png"))
img_croc <- readPNG(here("img/crocodile.png"))
img_lizard <- readPNG(here("img/lizard.png"))
img_salamander <- readPNG(here("img/salamander.png"))
img_turtle <- readPNG(here("img/tortoise.png"))
img_caecilian <- readPNG(here("img/caecilian.png"))


# Colour blind friendly palette
# First is grey
# Colour blind friendly palette
cbPalette <- c("#999999", "#a53606", "#b32db5", "#881a58", "#0e288e", "#164c64")

# Helper functions for plotting
annotation_custom2 <- 
  function (grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, height = NULL, width = NULL, data){ 
    layer(data = data, stat = StatIdentity, position = PositionIdentity, 
          geom = ggplot2:::GeomCustomAnn,
          inherit.aes = TRUE, params = list(grob = grob, 
                                            xmin = xmin, xmax = xmax, 
                                            ymin = ymin, ymax = ymax))}

#------------------------
# Read in all the data
#------------------------
specimens_all <- read_csv(here("data/all-specimen-data-unsexed-2021-07.csv")) 
specimens_all <- 
  specimens_all %>%
  mutate(sexed = case_when(is.na(sex) ~ "unsexed", !is.na(sex) ~ "sexed"))

# Extract required data
ds_orders <-
  specimens_all %>%
  group_by(class) %>%
  # Remove Rhynchocephalia as they only have one species 
  filter(order != "Rhynchocephalia") %>%
  add_count(binomial, name = "n") %>%
  add_count(binomial, sexed, name = "nn") %>%
  select(class, order, binomial, sexed, n, nn) %>%
  # Add in data for species with no males or no females
  complete(sexed, nesting(order, class, binomial, n), fill = list(nn = 0)) %>%
  filter(n >= 10 & sexed == "sexed") %>%
  rename(sexedY = nn) %>%
  mutate(unsexed = n - sexedY) %>%
  select(class, order, binomial, n, sexedY, unsexed) %>%
  mutate(percent = (sexedY/n) * 100) %>%
  distinct()

#--------------------------------------
# Make class plot
#--------------------------------------
class <- 
  ggplot(ds_orders, aes(x = percent, fill = class)) +
  geom_density(alpha = 0.5, colour = NA) +
  geom_vline(xintercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  xlab("% sexed specimens") +
  xlim(0, 100) +
  ylim(0, 0.35) +
  facet_wrap(~class, ncol = 1) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  theme(legend.position = "none") +
  theme(legend.position = "none",
        strip.background = element_rect(fill = "white"))

#--------------------------------------
# Make plots for each order
#--------------------------------------
order <-
  ggplot(ds_orders, aes(x = percent, fill = class)) +
  geom_density(colour = NA, alpha = 0.5) +
  geom_vline(xintercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  xlab("% sexed specimens") +
  ylab("density") +
  xlim(0, 100) +
  #ylim(0, 0.20) +
  expand_limits(x = 0, y = 0) +
  facet_wrap(~order, ncol = 1, scales = "free_y") +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  theme(legend.position = "none") +
  theme(legend.position = "none",
        strip.background = element_rect(fill = "white"))

# Add phylopics
frog <- annotation_custom2(rasterGrob(img_frog, interpolate=TRUE, height = 0.8), 
                        xmin=90, xmax=100, ymin=0.10, ymax=0.30,
                        data=ds_orders[1,])
salamander <- annotation_custom2(rasterGrob(img_salamander, interpolate=TRUE, height = 0.6), 
                                 xmin=85, xmax=85, ymin=0.1, ymax=0.40, 
                                 data=ds_orders[which(ds_orders$order == "Caudata")[1],])
croc <- annotation_custom2(rasterGrob(img_croc, interpolate=TRUE, height = 0.8), 
                           xmin=90, xmax=95, ymin=0, ymax=0.1, 
                           data=ds_orders[which(ds_orders$order == "Crocodylia")[1],])
lizard <- annotation_custom2(rasterGrob(img_lizard, interpolate=TRUE, height = 0.8), 
                             xmin=90, xmax=95, ymin=0.05, ymax=0.15, 
                             data=ds_orders[which(ds_orders$order == "Squamata")[1],])
turtle <- annotation_custom2(rasterGrob(img_turtle, interpolate=TRUE, height = 0.6), 
                             xmin=90, xmax=100, ymin=0.01, ymax=0.04, 
                             data=ds_orders[which(ds_orders$order == "Testudines")[1],])
caecilian <- annotation_custom2(rasterGrob(img_caecilian, interpolate=TRUE, height = 0.6), 
                             xmin=90, xmax=100, ymin=1, ymax=2, 
                             data=ds_orders[which(ds_orders$order == "Gymnophiona")[1],])

# Combine plots
class + order + frog + salamander + croc + lizard + turtle + caecilian

# Save
#ggsave("figures/unsexed-class-order-density.png", width = 9)
