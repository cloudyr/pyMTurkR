test_that("BlockWorker", {
  skip_if_not(CheckAWSKeys())

  # Test block
  expect_type(BlockWorker("A3LXJ76P1ZZPMC", reasons = "Did not follow instructions"), "list")
  expect_type(BlockWorker(as.factor("A3LXJ76P1ZZPMC"),
                          reasons = as.factor("Did not follow instructions")), "list")

  # Multiple workers
  expect_type(BlockWorker(c("A3LXJ76P1ZZPMC", "A3LXJ76P1ZZPMC"),
                          reasons = "Did not follow instructions"), "list")

  # Incorrect number of reasons
  expect_s3_class(try(BlockWorker("A3LXJ76P1ZZPMC",
                          reasons = c("reason1", "reason2")), TRUE), "try-error")

  # Unblock
  UnblockWorker("A3LXJ76P1ZZPMC")
})
