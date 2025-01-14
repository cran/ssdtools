## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 4
)

## ----fig.alt = "A plot showing the model averaged fit and the individual fits for the ccme_boron data."----
library(ssdtools)

dist <- ssd_fit_dists(ssddata::ccme_boron)
ssd_plot_cdf(dist, average = NA)

## ----message = FALSE, fig.alt = "A plot showing the model averaged fit with a mathematical expression in the xlabel with the units."----
library(ssdtools)

ssd_plot(ssddata::ccme_boron, ssdtools::boron_pred, label = "Species", shape = "Group") +
  ggplot2::scale_x_continuous(latex2exp::TeX("Boron $(\\mu g$/L)$"), breaks = c(1, 10, 100, 1000, 10000))

## ----results = "asis", echo = FALSE-------------------------------------------
cat(ssd_licensing_md())

