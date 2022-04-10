#    Copyright 2021 Environment and Climate Change Canada
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

test_that("lnorm_lnorm", {
  
  test_dist("lnorm_lnorm", qroottolerance = 1e-04)
  expect_equal(ssd_plnorm_lnorm(1), 0.329327626965729)
  expect_equal(ssd_qlnorm_lnorm(0.75), 3.53332231582824)
  set.seed(42)
  expect_equal(ssd_rlnorm_lnorm(2), c(0.568531719998709, 1.43782047983794))
})

test_that("ssd_qlnorm_lnorm allows reversed distributions", {
  expect_equal(
    ssd_qlnorm_lnorm(0.05, meanlog1 = 0, meanlog2 = 1, pmix = 0.1), 
    ssd_qlnorm_lnorm(0.05, meanlog1 = 1, meanlog2 = 0, pmix = 0.9)
  )
})

test_that("ssd_plnorm_lnorm allows reversed distributions", {
  expect_equal(
    ssd_plnorm_lnorm(1, meanlog1 = 0, meanlog2 = 1, pmix = 0.1), 
    ssd_plnorm_lnorm(1, meanlog1 = 1, meanlog2 = 0, pmix = 0.9)
  )
})

test_that("ssd_rlnorm_lnorm allows reversed distributions", {
  set.seed(10)
  r1 <- ssd_rlnorm_lnorm(1, meanlog1 = 0, meanlog2 = 1, pmix = 0.1)
  set.seed(10)
  r2 <- ssd_rlnorm_lnorm(1, meanlog1 = 1, meanlog2 = 0, pmix = 0.9)
  expect_equal(r1, r2)
})

test_that("lnorm_lnorm fits anonb", {
  set.seed(99)
  data <- ssddata::anon_b
  fit <- ssd_fit_dists(data, dists = c("lnorm_lnorm"), 
                       at_boundary_ok = FALSE, min_pmix = 0.05)
  
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "tidy_anonb")
  expect_snapshot_plot(ssd_plot(data, predict(fit), ci = FALSE), "plot_anonb")
})