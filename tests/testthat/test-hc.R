#    Copyright 2021 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

test_that("hc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hc, "tbl")
  expect_snapshot_boot_data(hc, "hc")
})

test_that("ssd_hc hc defunct", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  lifecycle::expect_defunct(ssd_hc(fits, hc = 6))
})

test_that("ssd_hc list must be named", {
  skip_on_os("linux") # FIXME
  chk::expect_chk_error(ssd_hc(list()))
})

test_that("ssd_hc list names must be unique", {
  skip_on_os("linux") # FIXME
  chk::expect_chk_error(ssd_hc(list("lnorm" = NULL, "lnorm" = NULL)))
})

test_that("ssd_hc list handles zero length list", {
  skip_on_os("linux") # FIXME
  hc <- ssd_hc(structure(list(), .Names = character(0)))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$dist, character(0))
  expect_identical(hc$percent, numeric(0))
  expect_identical(hc$se, numeric(0))
})

test_that("ssd_hc list works null values handles zero length list", {
  skip_on_os("linux") # FIXME
  hc <- ssd_hc(list("lnorm" = NULL))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_equal(hc$dist, "lnorm")
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.193040816698737)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc list works multiple percent values", {
  skip_on_os("linux") # FIXME
  hc <- ssd_hc(list("lnorm" = NULL), percent = c(1, 99))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$percent, c(1, 99))
  expect_equal(hc$dist, c("lnorm", "lnorm"))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121))
  expect_equal(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc list works specified values", {
  skip_on_os("linux") # FIXME
  hc <- ssd_hc(list("lnorm" = list(meanlog = 2, sdlog = 2)))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$percent, 5)
  expect_true(vld_whole_numeric(hc$percent))
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$est, 0.275351379333677)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc list works multiple NULL distributions", {
  skip_on_os("linux") # FIXME
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$percent, c(5, 5))
  expect_equal(hc$dist, c("lnorm", "llogis"))
  expect_equal(hc$est, c(0.193040816698737, 0.0526315789473684))
  expect_equal(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc list works multiple NULL distributions with multiple percent", {
  skip_on_os("linux") # FIXME
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL), percent = c(1, 99))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_equal(hc$dist, c("lnorm", "lnorm", "llogis", "llogis"))
  expect_identical(hc$percent, c(1, 99, 1, 99))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121, 0.0101010101010101, 98.9999999999999))
  expect_equal(hc$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
})

test_that("ssd_hc fitdists works zero length percent", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, numeric(0))
  expect_s3_class(hc, class = "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_equal(hc$dist, character(0))
  expect_identical(hc$percent, numeric(0))
  expect_equal(hc$est, numeric(0))
  expect_equal(hc$se, numeric(0))
})

test_that("ssd_hc fitdists works NA percent", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, NA_real_)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc114")
})

test_that("ssd_hc fitdists works 0 percent", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, 0)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc122")
})

test_that("ssd_hc fitdists works 100 percent", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, 100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc130")
})

test_that("ssd_hc fitdists works multiple percents", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, percent = c(1, 99))
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc138")
})

test_that("ssd_hc fitdists averages", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc145")
})

test_that("ssd_hc fitdists correctly averages", {
  skip_on_os("linux") # FIXME
  library(ssdtools)
  library(ssddata)
  library(testthat)
  fits <- ssd_fit_dists(ssddata::aims_molybdenum_marine, dists = c("lgumbel", "lnorm_lnorm"))
  hc <- ssd_hc(fits, average = FALSE)
  expect_equal(hc$est, c(3881.17238083968, 5540.68414532741))
  expect_equal(hc$wt, c(0.0968427088339105, 0.90315729116609))
  hc_avg <- ssd_hc(fits)
  expect_equal(hc_avg$est, sum(hc$est * hc$wt))
})

test_that("ssd_hc fitdists averages single dist by multiple percent", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, average = TRUE, percent = 1:99)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc153")
})

test_that("ssd_hc fitdists not average single dist by multiple percent gives whole numeric", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, average = FALSE, percent = 1:99)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc161")
})

test_that("ssd_hc fitdists not average", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits, average = FALSE)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc168")
})

test_that("ssd_hc fitdists correct for rescaling", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  fits_rescale <- ssd_fit_dists(ssddata::ccme_boron, rescale = TRUE)
  hc <- ssd_hc(fits)
  hc_rescale <- ssd_hc(fits_rescale)
  expect_equal(hc_rescale, hc, tolerance = 1e-05)
})

test_that("ssd_hc fitdists cis", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE)
  expect_s3_class(hc, "tbl_df")

  expect_snapshot_data(hc, "hc_cis")
})

test_that("ssd_hc fitdists cis level = 0.8", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, level = 0.8)
  expect_s3_class(hc, "tbl_df")

  expect_snapshot_data(hc, "hc_cis_level08")
})

test_that("ssd_hc doesn't calculate cis with inconsistent censoring", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.858174709802522)

  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
                 "^Parametric CIs cannot be calculated for inconsistently censored data[.]$")
  expect_identical(hc$se, NA_real_)
})

test_that("ssd_hc works with fully left censored data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.00143406862620477)
})

test_that("ssd_hc not work partially censored even if all same left", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0.1
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
                 "^Parametric CIs cannot be calculated for inconsistently censored data[.]$")
})

test_that("ssd_hc doesn't works with inconsisently censored data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  data$Conc[1] <- data$Conc2[1] / 2
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
                 "^Parametric CIs cannot be calculated for inconsistently censored data[.]$")
})

test_that("ssd_hc same with equally weighted data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)

  data$Weight <- rep(2, nrow(data))
  fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hc2 <- ssd_hc(fits2, ci = TRUE, nboot = 10)
  expect_equal(hc2, hc)
})

test_that("ssd_hc calculates cis with equally weighted data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.9241428592058)
})

test_that("ssd_hc calculates cis in parallel but one distribution", {
  skip_on_os("linux") # FIXME
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.9241428592058)
})

test_that("ssd_hc calculates cis with two distributions", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.93754149386013)
})

test_that("ssd_hc calculates cis in parallel with two distributions", {
  skip_on_os("linux") # FIXME
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.93754149386013)
})

test_that("ssd_hc doesn't calculate cis with unequally weighted data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  data$Weight[1] <- 2
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
                 "^Parametric CIs cannot be calculated for unequally weighted data[.]$")
  expect_identical(hc$se, NA_real_)
})

test_that("ssd_hc no effect with higher weight one distribution", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  set.seed(10)
  hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10)
  expect_equal(hc_10, hc)
})

test_that("ssd_hc effect with higher weight two distributions", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  set.seed(10)
  hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10)
  expect_equal(hc$est, 1.64903597051184)
  expect_equal(hc_10$est, 1.6811748398812)
  expect_equal(hc$se, 0.93754149386013)
  expect_equal(hc_10$se, 0.9241428592058)
})

test_that("ssd_hc cis with non-convergence", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1/10, sdlog2 = 1/10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.15)
  expect_identical(attr(fit, "min_pmix"), 0.15)
  hc15 <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.98)
  attr(fit, "min_pmix") <- 0.3
  expect_identical(attr(fit, "min_pmix"), 0.3)
  hc30 <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.96)
  expect_s3_class(hc30, "tbl")
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hc30, "hc_30")
})

test_that("ssd_hc cis with error", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1/10, sdlog2 = 1/10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  expect_warning(hc_err <- ssd_hc(fit, ci = TRUE, nboot = 100))
  expect_s3_class(hc_err, "tbl")
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hc_err, "hc_err_na")
  hc_err <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.92)
  expect_s3_class(hc_err, "tbl")
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_boot_data(hc_err, "hc_err")
})

test_that("ssd_hc cis with error and multiple dists", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1/10, sdlog2 = 1/10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = c("lnorm", "llogis_llogis"), min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  set.seed(99)
  expect_warning(hc_err_two <- ssd_hc(fit, ci = TRUE, nboot = 100, average = FALSE, delta = 100))
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hc_err_two, "hc_err_two")
  set.seed(99)
  expect_warning(hc_err_avg <- ssd_hc(fit, ci = TRUE, nboot = 100,
                                      delta = 100))
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hc_err_avg, "hc_err_avg")
})

test_that("ssd_hc with 1 bootstrap", {
  skip_on_os("linux") # FIXME
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fit, ci = TRUE, nboot = 1)
  expect_snapshot_data(hc, "hc_1")
})

test_that("ssd_hc comparable parametric and non-parametric big sample size", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  data <- data.frame(Conc = ssd_rlnorm(10000, 2, 1))
  fit <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hc_para <- ssd_hc(fit, ci = TRUE, nboot = 10)
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_data(hc_para, "hc_para")
  set.seed(10)
  hc_nonpara <- ssd_hc(fit, ci = TRUE, nboot = 10, parametric = FALSE)
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_boot_data(hc_nonpara, "hc_nonpara")
})

test_that("ssd_hc parametric and non-parametric small sample size", {
  skip_on_os("linux") # FIXME
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hc_para_small <- ssd_hc(fit, nboot = 10, ci = TRUE)
  expect_snapshot_data(hc_para_small, "hc_para_small")
  set.seed(47)
  hc_nonpara_small <- ssd_hc(fit, nboot = 10, ci = TRUE, parametric = FALSE)
  expect_snapshot_data(hc_para_small, "hc_para_small")
})

test_that("ssd_hc_burrlioz gets estimates with invpareto", {
  skip_on_os("linux") # FIXME
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hc_boron <- ssd_hc(fit, nboot = 10, ci = TRUE, min_pboot = 0)
  expect_snapshot_boot_data(hc_boron, "hc_boron")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hc_burrIII3 <- ssd_hc(fit, nboot = 10, ci = TRUE, min_pboot = 0)
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hc_burrIII3, "hc_burrIII3")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3 parametric", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hc_burrIII3 <- ssd_hc(fit, nboot = 10, ci = TRUE, min_pboot = 0,
                        parametric = TRUE)
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hc_burrIII3, "hc_burrIII3_parametric")
})

test_that("ssd_hc passing all boots ccme_chloride lnorm_lnorm", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_chloride,
                        min_pmix = 0.0001, at_boundary_ok = TRUE,
                        dists = c("lnorm_lnorm", "llogis_llogis"))

  set.seed(102)
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 1000, average = FALSE))
  expect_s3_class(hc, "tbl_df")
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hc, "hc_cis_chloride50")
})
