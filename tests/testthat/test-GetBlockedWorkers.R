
test_that("GetBlockedWorkers", {
  skip_if_not(CheckAWSKeys())

  BlockWorker('A3LXJ76P1ZZPMC', 'testing')
  GetBlockedWorkers() -> result
  expect_type(result, "list")
  GetBlockedWorkers(return.pages = 1, results = 1) -> result
  expect_type(result, "list")
  UnblockWorker('A3LXJ76P1ZZPMC')
})

