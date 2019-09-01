
test_that("GenerateQualificationRequirement", {

  quals.list <- list(
      list(QualificationTypeId = "2F1KVCNHMVHV8E9PBUB2A4J79LU20F",
           Comparator = "Exists",
           IntegerValues = 1,
           RequiredToPreview = TRUE
      ),
      list(QualificationTypeId = "00000000000000000071",
           Comparator = "EqualTo",
           LocaleValues = list(Country = "US"),
           RequiredToPreview = TRUE
      ),
      list(QualificationTypeId = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6",
           Comparator = "Exists",
           IntegerValues = 1,
           ActionsGuarded = 'Accept'
      )
  )
  GenerateQualificationRequirement(quals.list) -> qual.req
  expect_type(qual.req, "list")

})


test_that("GenerateQualificationRequirement all comparators", {

  # Gotta catch 'em all
  comparators <- c("<", "<=", ">", ">=", "=", "!=")

  for(i in 1:length(comparators)){
    comparator <- comparators[i]
    quals.list <- list(
      list(QualificationTypeId = "00000000000000000001",
           Comparator = comparator,
           LocaleValues = list(Country = "US"),
           RequiredToPreview = TRUE
      )
    )
    GenerateQualificationRequirement(quals.list) -> qual.req
    expect_type(qual.req, "list")
  }

})


test_that("GenerateQualificationRequirement errors", {

  # Wrong comparator for known qual type
  quals.list <- list(
    list(QualificationTypeId = "2ARFPLSP75KLA8M8DH1HTEQVJT3SY6",
         Comparator = "<",
         LocaleValues = list(Country = "US"),
         RequiredToPreview = TRUE
    )
  )
  try(GenerateQualificationRequirement(quals.list), TRUE) -> qual.req
  expect_s3_class(qual.req, "try-error")

  # Wrong comparator for known qual type
  quals.list <- list(
    list(QualificationTypeId = "00000000000000000071",
         Comparator = "<",
         LocaleValues = list(Country = "US"),
         RequiredToPreview = TRUE
    )
  )
  try(GenerateQualificationRequirement(quals.list), TRUE) -> qual.req
  expect_s3_class(qual.req, "try-error")


  # Cannot specify both RequiredToPreview and ActionsGuarded
  quals.list <- list(
    list(QualificationTypeId = "00000000000000000071",
         Comparator = "<",
         LocaleValues = list(Country = "US"),
         RequiredToPreview = TRUE,
         ActionsGuarded = 'Accept'
    )
  )
  try(GenerateQualificationRequirement(quals.list), TRUE) -> qual.req
  expect_s3_class(qual.req, "try-error")


  # Missing comparator
  quals.list <- list(
    list(QualificationTypeId = "00000000000000000071"
    )
  )
  try(GenerateQualificationRequirement(quals.list), TRUE) -> qual.req
  expect_s3_class(qual.req, "try-error")


  # Missing qual type
  quals.list <- list(
    list(
      )
  )
  try(GenerateQualificationRequirement(quals.list), TRUE) -> qual.req
  expect_s3_class(qual.req, "try-error")


  # LocaleValues not used
  quals.list <- list(
    list(QualificationTypeId = "00000000000000000001",
         Comparator = "Exists",
         LocaleValues = list(Country = "US"),
         RequiredToPreview = TRUE
    )
  )
  GenerateQualificationRequirement(quals.list) -> qual.req
  expect_type(qual.req, "list")


  # IntegerValues not used
  quals.list <- list(
    list(QualificationTypeId = "00000000000000000001",
         Comparator = "Exists",
         IntegerValues = 1,
         RequiredToPreview = TRUE
    )
  )
  GenerateQualificationRequirement(quals.list) -> qual.req
  expect_type(qual.req, "list")


  # IntegerValues missing but required
  quals.list <- list(
    list(QualificationTypeId = "00000000000000000001",
         Comparator = ">",
         RequiredToPreview = TRUE
    )
  )
  try(GenerateQualificationRequirement(quals.list), TRUE) -> qual.req
  expect_s3_class(qual.req, "try-error")


  # Invalid comparator
  quals.list <- list(
    list(QualificationTypeId = "00000000000000000001",
         Comparator = "!",
         RequiredToPreview = TRUE
    )
  )
  try(GenerateQualificationRequirement(quals.list), TRUE) -> qual.req
  expect_s3_class(qual.req, "try-error")

})







