## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.height = 4,
  fig.width = 6
)

## ---- message=FALSE-----------------------------------------------------------
library(ssdtools)
library(ggplot2)

theme_set(theme_bw())

set.seed(7)
ssd_plot_cdf(ssd_match_moments(meanlog = 2, sdlog = 2)) + 
  scale_color_ssd()

## ----fig.height=5-------------------------------------------------------------
set.seed(7)
ssd_plot_cdf(ssd_match_moments(dists = ssd_dists_all(), meanlog = 2, sdlog = 2)) +
  theme(legend.position = "bottom") + 
  scale_color_ssd()

