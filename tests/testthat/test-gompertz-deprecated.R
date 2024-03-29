#    Copyright 2015 Province of British Columbia
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

test_that("dgompertz extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(dgompertz(numeric(0)), numeric(0))
  expect_identical(dgompertz(NA), NA_real_)
  expect_identical(dgompertz(NaN), NaN)
  expect_identical(dgompertz(0), 1)
  expect_equal(dgompertz(1), 0.487589298719261)
  expect_equal(dgompertz(1, log = TRUE), log(dgompertz(1)))
  expect_identical(dgompertz(0), 1)
  expect_identical(dgompertz(-Inf), 0)
  expect_identical(dgompertz(Inf), 0)
  expect_identical(dgompertz(c(NA, NaN, 0, Inf, -Inf)), 
                   c(dgompertz(NA), dgompertz(NaN), dgompertz(0), dgompertz(Inf), dgompertz(-Inf)))
  expect_equal(dgompertz(1:2, llocation = 1:2, lshape = 3:4), 
               c(dgompertz(1, 1, 3), dgompertz(2, 2, 4)))
  expect_equal(dgompertz(1:2, llocation = c(1, NA), lshape = 3:4), 
               c(dgompertz(1, 1, 3), NA))
})

test_that("pgompertz extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(pgompertz(numeric(0)), numeric(0))
  expect_identical(pgompertz(NA), NA_real_)
  expect_identical(pgompertz(NaN), NaN)
  expect_identical(pgompertz(0), 0)
  expect_equal(pgompertz(1), 0.820625921265983)
  expect_equal(pgompertz(1, log.p = TRUE), log(pgompertz(1)))
  expect_equal(pgompertz(1, lower.tail = FALSE), 1 - pgompertz(1))
  expect_equal(pgompertz(1, lower.tail = FALSE, log.p = TRUE), log(1 - pgompertz(1)))
  expect_identical(pgompertz(0), 0)
  expect_identical(pgompertz(-Inf), 0)
  expect_identical(pgompertz(Inf), 1)
  expect_identical(pgompertz(c(NA, NaN, 0, Inf, -Inf)), 
                   c(pgompertz(NA), pgompertz(NaN), pgompertz(0), pgompertz(Inf), pgompertz(-Inf)))
  expect_equal(pgompertz(1:2, llocation = 1:2, lshape = 3:4), 
               c(pgompertz(1, 1, 3), pgompertz(2, 2, 4)))
  expect_equal(pgompertz(1:2, llocation = c(1, NA), lshape = 3:4), 
               c(pgompertz(1, 1, 3), NA))
})

test_that("qgompertz extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(qgompertz(numeric(0)), numeric(0))
  expect_identical(qgompertz(NA), NA_real_)
  expect_identical(qgompertz(NaN), NaN)
  expect_identical(qgompertz(0), 0)
  expect_identical(qgompertz(1), Inf)
  expect_equal(qgompertz(0.75), 0.869741686191944)
  expect_equal(qgompertz(0.75, log.p = TRUE), NaN)
  expect_equal(qgompertz(log(0.75), log.p = TRUE), qgompertz(0.75))
  expect_equal(qgompertz(0.75, lower.tail = FALSE), qgompertz(0.25))
  expect_equal(qgompertz(log(0.75), lower.tail = FALSE, log.p = TRUE), qgompertz(0.25))
  expect_identical(qgompertz(0), 0)
  expect_identical(qgompertz(-Inf), NaN)
  expect_identical(qgompertz(Inf), NaN)
  expect_identical(qgompertz(c(NA, NaN, 0, Inf, -Inf)), 
                   c(qgompertz(NA), qgompertz(NaN), qgompertz(0), qgompertz(Inf), qgompertz(-Inf)))
  expect_equal(qgompertz(1:2, llocation = 1:2, lshape = 3:4), 
               c(qgompertz(1, 1, 3), qgompertz(2, 2, 4)))
  expect_equal(qgompertz(1:2, llocation = c(1, NA), lshape = 3:4), c(Inf, NaN))
  expect_equal(qgompertz(pgompertz(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rgompertz extremes", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(rgompertz(numeric(0)), numeric(0))
  expect_error(rgompertz(NA))
  expect_identical(rgompertz(0), numeric(0))
  set.seed(42)
  expect_equal(rgompertz(1), 1.24208466660006)
  set.seed(42)
  expect_equal(rgompertz(1.9), 1.24208466660006)
  set.seed(42)
  expect_equal(rgompertz(2), c(1.24208466660006, 1.32596518320944))
  set.seed(42)
  expect_equal(rgompertz(3:4), c(1.24208466660006, 1.32596518320944))
  expect_equal(rgompertz(0, llocation = -1), numeric(0))
  expect_equal(rgompertz(0, lshape = -1), numeric(0))
  expect_error(rgompertz(1, llocation = 1:2))
  expect_error(rgompertz(1, lshape = 1:2))
  expect_identical(rgompertz(1, llocation = NA), NA_real_)
  expect_identical(rgompertz(1, lshape = NA), NA_real_)
})
