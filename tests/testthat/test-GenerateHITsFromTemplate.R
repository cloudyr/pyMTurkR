
test_that("GenerateHITsFromTemplate", {

  temp <- system.file("templates/htmlquestion2.xml", package = "pyMTurkR")
  readLines(temp)

  # create/load data.frame of template variable values
  a <- data.frame(hittitle = c("HIT title 1","HIT title 2","HIT title 3"),
                  hitvariable = c("HIT text 1","HIT text 2","HIT text 3"),
                  stringsAsFactors=FALSE)

  # create HITs from template and data.frame values
  temps <- GenerateHITsFromTemplate(template = temp, input = a)

  expect_type(temps, "list")

})


test_that("GenerateHITsFromTemplate write files", {

  temp <- system.file("templates/htmlquestion2.xml", package = "pyMTurkR")
  readLines(temp)

  # create/load data.frame of template variable values
  a <- data.frame(hittitle = c("HIT title 1"),
                  hitvariable = c("HIT text 1"),
                  stringsAsFactors=FALSE)

  # Create HIT and write to file ("NewHit1.html" by default)
  GenerateHITsFromTemplate(template = temp,
                           input = a,
                           write.files = T)

  expect_equal(file.exists("NewHit1.html"), TRUE)

  # Delete file
  system("rm NewHIT1.html")

  # Create HIT and write to file, specifying filename
  GenerateHITsFromTemplate(template = temp,
                           input = a,
                           write.files = T,
                           filenames = "MyHit.html")

  expect_equal(file.exists("MyHit.html"), TRUE)

  # Delete file
  system("rm MyHit.html")

})



test_that("GenerateHITsFromTemplate error", {

  temp <- system.file("templates/htmlquestion2.xml", package = "pyMTurkR")
  readLines(temp)

  # create/load data.frame of template variable values
  a <- data.frame(hittitle = c("HIT title 1"),
                  hitvariable = c("HIT text 1"),
                  stringsAsFactors=FALSE)

  # Create HIT and write to file ("NewHit1.html" by default)
  try(GenerateHITsFromTemplate(template = temp,
                           input = a,
                           write.files = T,
                           filenames = c('file1.html', 'file2.html'))) -> genhit

  expect_s3_class(genhit, 'try-error')

})
