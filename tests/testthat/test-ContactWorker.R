
test_that("ContactWorker one worker, one message", {
  skip_if_not(CheckAWSKeys())

  expect_type(ContactWorker(subjects = as.factor('Thanks!'),
                            msgs = as.factor('Thanks for participating in my study!'),
                            workers = as.factor('A3LXJ76P1ZZPMC')), "list")

})


test_that("ContactWorker two workers", {
  skip_if_not(CheckAWSKeys())

  expect_s3_class(try(ContactWorker(subjects = 'Thanks!',
                            msgs = 'Thanks for participating in my study!',
                            workers = c('A3LXJ76P1ZZPMC', 'NOTAWORKER'))), "try-error")

})


test_that("ContactWorker 101 workers using batch process", {
  skip_if_not(CheckAWSKeys())

  # Generate 101 random Worker IDs
  workers <- c()
  for(i in 1:101){
    set.seed(i) # random seed
    workers <- c(workers, paste0("A", sample(c(0:9, LETTERS[1:6]), 31, T), collapse = ''))
  }
  # These will all fail, but that's OK
  expect_type(suppressMessages(ContactWorker(subjects = 'Thanks!',
                                             msgs = 'Thanks for participating in my study!',
                                             workers = workers,
                                             batch = TRUE,
                                             verbose = FALSE)), "list")

})


test_that("ContactWorker incorrect WorkerId specifications", {
  skip_if_not(CheckAWSKeys())

  # invalid
  expect_s3_class(try(ContactWorker(subjects = 'Thanks!',
                                    msgs = 'Thanks for participating in my study!',
                                    workers = 'NOTAWORKER')), "try-error")
  # too short
  expect_s3_class(try(ContactWorker(subjects = 'Thanks!',
                                    msgs = 'Thanks for participating in my study!',
                                    workers = '')), "try-error")
  # too long
  expect_s3_class(try(ContactWorker(subjects = 'Thanks!',
                                    msgs = 'Thanks for participating in my study!',
                                    workers = paste(rep("A",65), collapse = ""))), "try-error")
  # hasn't done any work for me
  expect_type(ContactWorker(subjects = 'Thanks!',
                                    msgs = 'Thanks for participating in my study!',
                                    workers = paste(rep("A",64), collapse = "")), "list")

})


test_that("ContactWorker incorrect parameter lengths", {
  skip_if_not(CheckAWSKeys())

  # Incorrect subjects length
  expect_s3_class(try(ContactWorker(subjects = c('Thanks!', 'x'),
                            msgs = 'Thanks for participating in my study!',
                            workers = rep('A3LXJ76P1ZZPMC', 3),
                            verbose = FALSE)), "try-error")

  # Incorrect msgs length
  expect_s3_class(try(ContactWorker(subjects = 'Thanks!',
                                    msgs = c('Thanks for participating in my study!', 'x'),
                                    workers = rep('A3LXJ76P1ZZPMC', 3),
                                    verbose = FALSE)), "try-error")

})


test_that("ContactWorker batch process errors", {
  skip_if_not(CheckAWSKeys())

  # Only one message can be used in batch mode
  expect_s3_class(try(ContactWorker(subjects = 'Thanks!',
                            msgs = c('x', 'y'),
                            workers = 'A3LXJ76P1ZZPMC',
                            batch = TRUE)), "try-error")

  # Subject cannot be more than 200 chars long
  expect_s3_class(try(ContactWorker(subjects = paste(rep("A",201), collapse = ""),
                                    msgs = 'Thanks for participating in my study!',
                                    workers = 'A3LXJ76P1ZZPMC',
                                    batch = TRUE)), "try-error")

  # Msg cannot be more than 4096 characters
  expect_s3_class(try(ContactWorker(subjects = 'Thanks!',
                                    msgs = paste(rep("A",4097), collapse = ""),
                                    workers = 'A3LXJ76P1ZZPMC',
                                    batch = TRUE)), "try-error")

})

