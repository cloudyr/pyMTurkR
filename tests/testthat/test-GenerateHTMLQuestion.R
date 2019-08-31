test_that("GenerateHTMLQuestion", {

  f <- system.file("templates/htmlquestion1.xml", package = "pyMTurkR")
  a <- GenerateHTMLQuestion(file = f)
  b <- GenerateHTMLQuestion(character = paste0(readLines(f), collapse = ""))

  expect_s3_class(a, "HTMLQuestion")
  expect_s3_class(a, "HTMLQuestion")
})
