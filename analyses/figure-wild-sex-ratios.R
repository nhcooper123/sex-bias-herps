#----------------
# Wild sex ratios
#----------------
# Load libraries
library(tidyverse)
library(patchwork)

# Colour blind friendly palette
# First is grey
# Colour blind friendly palette
cbPalette <- c("#999999", "#a53606", "#b32db5", "#881a58", "#0e288e", "#164c64")
#------------------------------------------------
# Read in the data
ds <- read_csv("data/wild-sex-ratios.csv")

# Plot
ggplot(ds, aes(x = `skew`, y = `female`, fill = class))+
  geom_boxplot(alpha = 0.6) +
  geom_abline(slope = 0, intercept = 50, linetype = 2) +
  theme_bw(base_size = 14) +
  ylab("% female specimens") +
  xlab("wild sex ratio") +
  scale_fill_manual(values = c(cbPalette[c(3,5)])) +
  scale_y_continuous(labels = c(0,25,50,75,100)) +
  theme(legend.position = "none",
        strip.background = element_rect(fill="white")) +
  facet_wrap(~class, ncol = 1)

#ggsave("figures/wild-sex-ratios.png")

ds %>% group_by(class, skew) %>% summarise(n())

ds %>% summarise(n())
