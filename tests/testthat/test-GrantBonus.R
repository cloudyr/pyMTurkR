
test_that("GrantBonus one worker, one bonus", {
  skip_if_not(CheckAWSKeys())

  GetAssignment(annotation = ';', status = 'Approved') -> assignments

  GrantBonus(workers = as.factor('A3LXJ76P1ZZPMC'),
              assignments = as.factor(assignments$AssignmentId[[1]]),
              amounts = .1,
              reasons = as.factor('Thanks!')) -> result
  expect_type(result, "list")

  # Duplicates, skip prompt
  GrantBonus(workers = c('A3LXJ76P1ZZPMC', 'A3LXJ76P1ZZPMC'),
             assignments = c(assignments$AssignmentId[[1]], assignments$AssignmentId[[1]]),
             amounts = .1,
             reasons = as.factor('Thanks!'),
             skip.prompt = TRUE) -> result
  expect_type(result, "list")

})




test_that("GrantBonus incorrect WorkerId specifications", {
  skip_if_not(CheckAWSKeys())

  # invalid
  expect_s3_class(try(GrantBonus(workers = 'NOTAWORKER',
                                  assignments = assignments$AssignmentId[[1]],
                                  amounts = .1,
                                  reasons = 'Thanks!')), "try-error")
  # too short
  expect_s3_class(try(GrantBonus(workers = '',
                                 assignments = assignments$AssignmentId[[1]],
                                 amounts = .1,
                                 reasons = 'Thanks!')), "try-error")
  # too long
  expect_s3_class(try(GrantBonus(workers = paste(rep("A",65)),
                                 assignments = assignments$AssignmentId[[1]],
                                 amounts = .1,
                                 reasons = 'Thanks!')), "try-error")

})


test_that("ContactWorker incorrect parameter lengths", {
  skip_if_not(CheckAWSKeys())

  # Incorrect reasons length
  try(GrantBonus(workers = 'A3LXJ76P1ZZPMC',
             assignments = assignments$AssignmentId[[1]],
             amounts = .1,
             reasons = c('Thanks!', 'x'))) -> result
  expect_s3_class(result, "try-error")

  try(GrantBonus(workers = 'A3LXJ76P1ZZPMC',
                 assignments = assignments$AssignmentId[[1]],
                 amounts = .1,
                 reasons = paste(rep("A",4097), collapse=""))) -> result
  expect_s3_class(result, "try-error")

  # Incorrect rewards length
  try(GrantBonus(workers = 'A3LXJ76P1ZZPMC',
                 assignments = assignments$AssignmentId[[1]],
                 amounts = c(.1, .5),
                 reasons = 'Thanks!')) -> result
  expect_s3_class(result, "try-error")

})

