# Figures for classes and orders
# Natalie Cooper 
# July 2021
#------------------------
# Load libraries
library(tidyverse)
library(viridis)
library(patchwork)
library(rphylopic)
library(grid)
library(here)

# Read in phylopics
library(png)
img_frog <- readPNG(here("img/frog.png"))
img_croc <- readPNG(here("img/crocodile.png"))
img_lizard <- readPNG(here("img/lizard.png"))
img_salamander <- readPNG(here("img/salamander.png"))
img_turtle <- readPNG(here("img/turtle.png"))


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
specimens <- read_csv(here("data/all-specimen-data-2021-07.csv"))
#glimpse(specimens)

#------------------------
# Extract data required
#------------------------
ds_orders <-
  specimens %>%
  #group_by(class) %>%
  add_count(binomial, name = "n") %>%
  add_count(binomial, sex, name = "nn") %>%
  select(class, order, binomial, sex, n, nn) %>%
  # Add in data for species with no males or no females
  complete(sex, nesting(order, class, binomial, n), fill = list(nn = 0)) %>%
  filter(n >= 10 & sex == "Female") %>%
  filter(order != "Gymnophiona" & order != "Rhynchocephalia") %>%
  mutate(percent = round(nn/n*100, 2)) %>%
  select(class, order, binomial, percent) %>%
  distinct()

#--------------------------------------
# Make class plot
#--------------------------------------
class <- 
  ggplot(ds_orders, aes(x = percent, fill = class)) +
  geom_density(alpha = 0.5, colour = NA) +
  geom_vline(xintercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  xlab("% female specimens") +
  xlim(0, 100) +
  ylim(0, 0.04) +
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
  xlab("% female specimens") +
  ylab("density") +
  xlim(0, 100) +
  ylim(0, 0.04) +
  expand_limits(x = 0, y = 0) +
  facet_wrap(~order, ncol = 2) +
  scale_fill_manual(values = cbPalette[c(3,5)]) +
  theme(legend.position = "none") +
  theme(legend.position = "none",
        strip.background = element_rect(fill = "white"))

# Add phylopics
frog <- annotation_custom2(rasterGrob(img_frog, interpolate=TRUE, height = 0.8), 
                        xmin=90, xmax=90, ymin=0.025, ymax=0.04,
                        data=ds_orders[1,])
salamander <- annotation_custom2(rasterGrob(img_salamander, interpolate=TRUE, height = 0.65), 
                                 xmin=80, xmax=80, ymin=0.025, ymax=0.041, 
                                 data=ds_orders[which(ds_orders$order == "Caudata")[1],])
croc <- annotation_custom2(rasterGrob(img_croc, interpolate=TRUE, height = 0.7), 
                           xmin=80, xmax=80, ymin=0.023, ymax=0.042, 
                           data=ds_orders[which(ds_orders$order == "Crocodylia")[1],])
lizard <- annotation_custom2(rasterGrob(img_lizard, interpolate=TRUE, height = 0.7), 
                             xmin=80, xmax=80, ymin=0.023, ymax=0.041, 
                             data=ds_orders[which(ds_orders$order == "Squamata")[1],])
turtle <- annotation_custom2(rasterGrob(img_turtle, interpolate=TRUE, height = 0.8), 
                             xmin=85, xmax=95, ymin=0.023, ymax=0.043, 
                             data=ds_orders[which(ds_orders$order == "Testudines")[1],])

# Combine plots
class + order + frog + salamander + croc + lizard + turtle

# Save
#ggsave("figures/class-order-density.png")
