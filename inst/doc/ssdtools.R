## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 4,
  fig.height = 4
)

## ---- eval = FALSE------------------------------------------------------------
#  install.packages(c("ssdtools", "tidyverse"))

## ---- message = FALSE---------------------------------------------------------
library(ssdtools)
library(tidyverse)

## ---- eval = FALSE------------------------------------------------------------
#  data <- read_csv(file = "path/to/file.csv")

## -----------------------------------------------------------------------------
ccme_boron <- ssddata::ccme_boron
print(ccme_boron)

## -----------------------------------------------------------------------------
ssd_dists_all()

## -----------------------------------------------------------------------------
fits <- ssd_fit_dists(ccme_boron, dists = c("llogis", "lnorm", "gamma"))

## -----------------------------------------------------------------------------
tidy(fits)

## ---- fig.width = 5-----------------------------------------------------------
theme_set(theme_bw()) # set plot theme

autoplot(fits) + 
  ggtitle("Species Sensitivity Distributions for Boron") +
  scale_colour_ssd()

## -----------------------------------------------------------------------------
ssd_gof(fits)

## ---- eval = FALSE------------------------------------------------------------
#  doFuture::registerDoFuture()
#  future::plan(future::multisession)
#  
#  set.seed(99)
#  boron_pred <- predict(fits, ci = TRUE)

## -----------------------------------------------------------------------------
boron_pred

## ---- fig.height = 5, fig.width = 6-------------------------------------------
ssd_plot(ccme_boron, boron_pred,
         color = "Group", label = "Species",
         xlab = "Concentration (mg/L)", ribbon = TRUE) + 
  expand_limits(x = 5000) + # to ensure the species labels fit
  ggtitle("Species Sensitivity for Boron") +
  scale_colour_ssd()

## -----------------------------------------------------------------------------
set.seed(99)
boron_hc5 <- ssd_hc(fits, ci = TRUE)
print(boron_hc5)

## -----------------------------------------------------------------------------
ggplot(ccme_boron) +
  geom_ssdpoint(aes_string(x = "Conc"))

## -----------------------------------------------------------------------------
ggplot(ccme_boron) +
  geom_ssdsegment(aes_string(x = "Conc", xend = "Conc * 2"))

## -----------------------------------------------------------------------------
ggplot(boron_pred) +
  geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent/100"))

## -----------------------------------------------------------------------------
ggplot() +
  geom_hcintersect(xintercept = c(1, 2, 3), yintercept = c(5, 10, 20) / 100)

## -----------------------------------------------------------------------------
gp <- ggplot(boron_pred, aes_string(x = "est")) +
  geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent/100"), alpha = 0.2) +
  geom_line(aes_string(y = "percent/100")) +
  geom_ssdsegment(data = ccme_boron, aes_string(x = "Conc / 2", xend = "Conc * 2")) +
  geom_ssdpoint(data = ccme_boron, aes_string(x = "Conc / 2")) +
  geom_ssdpoint(data = ccme_boron, aes_string(x = "Conc * 2")) +
  scale_y_continuous("Species Affected (%)", labels = scales::percent) +
  expand_limits(y = c(0, 1)) +
  xlab("Concentration (mg/L)")
print(gp + geom_hcintersect(xintercept = boron_hc5$est, yintercept = 5 / 100))

## -----------------------------------------------------------------------------
gp <- gp + coord_trans(x = "log10") +
  scale_x_continuous(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = comma_signif
  )
print(gp + geom_hcintersect(xintercept = boron_hc5$est, yintercept = 5 / 100))

