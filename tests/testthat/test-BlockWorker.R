test_that("BlockWorker and UnblockWorker", {
  skip_if_not(CheckAWSKeys())

  # Test block
  expect_type(BlockWorker("A1RO9UJNWXMU65", reasons = "Did not follow instructions"), "list")
  expect_type(BlockWorker(as.factor("A1RO9UJNWXMU65"),
                          reasons = as.factor("Did not follow instructions")), "list")

  # Multiple workers
  expect_type(BlockWorker(c("A1RO9UJNWXMU65", "A1RO9UJNWXMU65"),
                          reasons = "Did not follow instructions"), "list")

  # Incorrect number of reasons
  expect_s3_class(try(BlockWorker("A1RO9UJNWXMU65",
                          reasons = c("reason1", "reason2")), TRUE), "try-error")

  # Unblock
  expect_type(UnblockWorker("A1RO9UJNWXMU65"), "list")
  expect_type(UnblockWorker(workers = "A1RO9UJNWXMU65", reasons = "redemption"), "list")
})

test_that("BlockWorker and UnblockWorker misspecifications", {
  skip_if_not(CheckAWSKeys())
  expect_type(UnblockWorker("A1RO9UJNWXMU65"), "list")
})
