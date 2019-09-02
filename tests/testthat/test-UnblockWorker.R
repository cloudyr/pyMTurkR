test_that("UnblockWorker", {
  skip_if_not(CheckAWSKeys())

  # Block
  BlockWorker("A3LXJ76P1ZZPMC", reasons = "Did not follow instructions")

  # Unblock
  expect_type(UnblockWorker("A3LXJ76P1ZZPMC"), "list")
  expect_type(UnblockWorker(workers = "A3LXJ76P1ZZPMC",
                            reasons = as.factor("redemption")), "list")

  # More reasons than workers, error
  expect_s3_class(try(UnblockWorker(workers = "A3LXJ76P1ZZPMC",
                                reasons = c("x", "y")),
                  TRUE), "try-error")
})
