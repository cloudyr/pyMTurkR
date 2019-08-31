test_that("GenerateNotification", {

  a <- GenerateNotification(destination = 'email@email.com',
                            event.type = 'AssignmentAccepted')

  expect_equal(class(a)[1], "python.builtin.dict")

})


test_that("GenerateNotification parameter misspecification", {

  a <- try(GenerateNotification(destination = 'email@email.com',
                            event.type = 'x'))
  expect_s3_class(a, 'try-error')

  a <- try(GenerateNotification(event.type = 'AssignmentAccepted',
                                transport = 'FTP'))
  expect_s3_class(a, 'try-error')

})
