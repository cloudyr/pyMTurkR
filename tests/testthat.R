library(testthat)
library(pyMTurkR)

test_that("All tests", {
  skip_if_not(
    is.null(tryCatch({reticulate:::ensure_python_initialized()}, error=function(e) T)),
    "Skipping tests as we cannot get reticulate to recognize our python setup"
  )
  test_dir("testthat")
})
