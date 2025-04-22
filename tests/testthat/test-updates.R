library(testthat) library(sesIndia)

test_that("B.G. Prasad updates correctly", { result <- update_bg_prasad(cpi_iw = 143.2) expect_equal(result$lower[1], 8592) # Class I lower bound expect_equal(result$upper[2], 8591) # Class II upper bound })

test_that("Kuppuswamy updates correctly", { result <- update_kuppuswamy(cpi_iw = 143.2) expect_equal(result$lower[1], 60125) # Score 12 lower bound expect_equal(result$upper[2], 60095) # Score 10 upper bound })

test_that("Invalid CPI-IW throws error", { expect_error(update_bg_prasad(cpi_iw = -1)) expect_error(update_kuppuswamy(cpi_iw = 0)) })
