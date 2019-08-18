# R Client for the MTurk Requester API

![experimental](https://img.shields.io/badge/stability-experimental-lightgrey.svg)
![version](https://img.shields.io/badge/version-0.5.7-blue.svg)
![functions coded](https://img.shields.io/badge/functions_coded-100%25-brightgreen.svg)
![unit tests](https://img.shields.io/badge/unit_tests-0%25-red.svg)
![downloads](https://img.shields.io/badge/downloads-52-9cf)

<a href="https://twitter.com/intent/follow?screen_name=tylerburleigh"><img src="https://img.shields.io/twitter/follow/tylerburleigh?style=social&logo=twitter" alt="follow on Twitter"></a>


**pyMTurkR** is a replacement for the now obsolete [MTurkR](https://github.com/cloudyr/MTurkR). pyMTurkR provides access to the latest Amazon Mechanical Turk (MTurk) <https://www.mturk.com> Requester API (version '2017–01–17'), using `reticulate` to wrap the `boto3` SDK for Python.

Because pyMTurkR uses Python, it requires some Python setup:

  1. Install Python 2 (>= 2.7) or Python 3 (>= 3.3) ([download page](https://www.python.org/downloads))
  2. Install `pip` for Python ([see "Installing with get-pip.py" here](https://pip.pypa.io/en/stable/installing))
  3. Use `pip` to install boto3 ([see "Installation" here](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#installation))
  
In case you run into problems, see the Troubleshooting section at the end of this readme file.

## Why make this?

pyMTurkR was started because Amazon decided to [deprecate the API](https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI-legacy/Welcome.html) that MTurkR was using (meaning MTurkR would stop working). The goal of this project is to create a package that functions in a way that will be familiar to MTurkR users, making the transition easier.

Unlike MTurkR, pyMTurkR is not purely a native R-language package. Instead, it uses [`reticulate`](https://rstudio.github.io/reticulate) to import the [`boto3`](https://aws.amazon.com/sdk-for-python) module for Python. Having a cross-language dependency is not necessarily a bad thing and from the user perspective there is probably no difference, besides the extra install steps mentioned above.

## What can it do?

The following verbs have been implemented so far:

- AccountBalance()
- ApproveAssignment()
- ApproveAllAssignments()
- AssignQualification()
- BlockWorker()
- ContactWorker()
- CreateHIT()
- CreateQualificationType()
- DisableHIT()
- DisposeHIT()
- DisposeQualificationType()
- DeleteHIT()
- ExpireHIT()
- ExtendHIT()
- GenerateAssignmentReviewPolicy()
- GenerateExternalQuestion()
- GenerateQualificationRequirement()
- GenerateHITsFromTemplate()
- GenerateHITReviewPolicy()
- GenerateHTMLQuestion()
- GenerateNotification()
- GetAssignment()
- GetBlockedWorkers()
- GetBonuses()
- GetHIT()
- GetHITsForQualificationType()
- GetQualificationRequests()
- GetQualificationType()
- GetQualifications()
- GetQualificationScore()
- GetReviewableHITs()
- GetReviewResultsForHIT()
- GrantBonus()
- GrantQualification()
- HITStatus()
- RegisterHITType()
- RejectAssignment()
- RejectQualification()
- RevokeQualification()
- SearchHITs()
- SearchQualificationTypes()
- SendTestEventNotification()
- SetHITAsReviewing()
- SetHITTypeNotification()
- UnblockWorker()
- UpdateQualificationScore()
- UpdateQualificationType()

# Installation

## Pre-package installation

Windows users should install [https://conda.io/projects/conda/en/latest/user-guide/install/windows.html](Anaconda) before the following steps.

1. Install the `reticulate` R package if you don't have it already

```
install.packages('reticulate')
```

2. Use reticulate to install python with the boto3 python library
 
```
reticulate::py_install("boto3")
```
  
### Package installation

```R
devtools::install_github("cloudyr/pyMTurkR")
```


# Usage

## Set AWS keys

AWS keys can be set as environment variables

```R
Sys.setenv(AWS_ACCESS_KEY_ID = "my access key")
Sys.setenv(AWS_SECRET_ACCESS_KEY = "my secret key")
```

## Set environment (Sandbox or Live)

pyMTurkR will run in "sandbox" mode by default. To change this, set `pyMTurkR.sandbox` to `FALSE`.

```R
options(pyMTurkR.sandbox = FALSE)
```


## Examples

```R
library("pyMTurkR")
Sys.setenv(AWS_ACCESS_KEY_ID = "ABCD1234")
Sys.setenv(AWS_SECRET_ACCESS_KEY = "EFGH5678")
options(pyMTurkR.sandbox = FALSE)
AccountBalance()
```

# Development status

For development updates see the [Changelog](https://github.com/cloudyr/pyMTurkR/blob/master/CHANGELOG.md)

