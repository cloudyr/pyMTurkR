# Changelog

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
