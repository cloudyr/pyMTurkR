# Changelog

## [0.2.0] - 2019-06-01
### Added
- ExtendHIT()
### Changed
Small bug fix for GetHIT()

## [0.1.9] - 2019-05-31
### Added
- GetHIT()

## [0.1.8] - 2019-05-31
### Changed
- User can now set access keys using more familiar environment variables
	Sys.setenv(AWS_ACCESS_KEY_ID = "my access key")
	Sys.setenv(AWS_SECRET_ACCESS_KEY = "my secret key")
- User can now set sandbox parameter as option
	R.utils::setOption("pyMTurkR.sandbox", TRUE)
- User can now set AWS profile parameter as option (most users won't need to do this)
	R.utils::setOption("pyMTurkR.profile", TRUE)

## [0.1.7] - 2019-05-27
### Added
- ApproveAllAssignments()

## [0.1.6] - 2019-05-26
### Added
- GetAssignment()

## [0.1.5] - 2019-05-25
### Added
- CreateHIT()
- ContactWorker()

## [0.1.4] - 2019-05-18
### Added
- RegisterHITType()
- ChangeHITType()

## [0.1.3] - 2019-05-16
### Added
- SearchHITs()

## [0.1.2] - 2019-05-14
### Added
- BlockWorker()

## [0.1.1] - 2019-05-12
### Added
- AssignQualification()
- CreateQualificationType()

## [0.1.0] - 2019-05-11
### Added
- Initialized repo with R package ingredients
- Wrote several functions
  - client(): The core client function, creates an MTurk Client using the AWS SDK for Python (Boto3)
  - AccountBalance(): Retrieve MTurk account balance
  - ApproveAssignment(): Approve Assignment(s)
