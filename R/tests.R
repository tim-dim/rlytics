library("devtools")
install_github("tim-dim/rlytics")

library(rlytics)
library("ggplot2")


ggplot(mpg, aes(displ, hwy, colour = class)) +
  geom_point() +
  theme_classic() +
  scale_colour_eyp()
