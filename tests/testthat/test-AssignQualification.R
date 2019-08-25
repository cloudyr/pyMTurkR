
test_that("AssignQualification existing Qualification to worker", {
  skip_if_not(CheckAWSKeys())

  SearchQualificationTypes(must.be.owner = TRUE) -> quals
  quals$QualificationTypeId[1] -> qual

  expect_type(AssignQualification(qual = qual, workers = 'A3LXJ76P1ZZPMC'), "list")
  expect_type(AssignQualification(qual = as.factor(qual), workers = as.factor('A3LXJ76P1ZZPMC'), value = as.factor(1)), "list")
})

test_that("AssignQualification parameter misspecification errors", {
  skip_if_not(CheckAWSKeys())

  expect_s3_class(try(AssignQualification(qual = 'x', workers = 'x', notify = 'x', verbose = FALSE), TRUE), "try-error")
  expect_s3_class(try(AssignQualification(qual = 'x', workers = 'x', value = 'x'), TRUE), "try-error")
  expect_type(AssignQualification(qual = 'x', workers = c('x','x','x'), value = c(1, 2, '')), "list")
})

test_that("AssignQualification Qualification defined in function call", {
  skip_if_not(CheckAWSKeys())

  AssignQualification(workers = 'A3LXJ76P1ZZPMC',
                      name = 'This is a qualification',
                      description = 'Let me describe it to you',
                      keywords = 'qualification',
                      status = 'Active') -> result
  DeleteQualificationType(qual = result$QualificationTypeId)
  expect_type(result, "list")
})


test_that("AssignQualification Qualification definition misspecification", {
  skip_if_not(CheckAWSKeys())
  # Missing description
  expect_s3_class(try(AssignQualification(workers = 'A3LXJ76P1ZZPMC',
                                            name = 'This is a qualification',
                                            keywords = 'qualification',
                                            status = 'Active'), TRUE), "try-error")
  # Missing description
  expect_s3_class(try(AssignQualification(workers = 'A3LXJ76P1ZZPMC',
                                            name = 'This is a qualification',
                                            qual = 'x'), TRUE), "try-error")
  # Missing description
  AssignQualification(workers = 'A3LXJ76P1ZZPMC',
                      name = 'This is a qualification',
                      description = 'Let me describe it to you',
                      keywords = 'qualification',
                      status = 'X') -> result
  DeleteQualificationType(qual = result$QualificationTypeId)
  expect_type(result, "list")
})



