<img src="logo.png" alt="pyMTurkR logo" width="250" />

# An R package to interface with the MTurk requester API

![experimental](https://img.shields.io/badge/status-experimental-lightgrey.svg)
![version](https://img.shields.io/badge/version-0.5.7-blue.svg)
![downloads](https://img.shields.io/badge/downloads-52-brightgreen)

**pyMTurkR** is a replacement for the now obsolete [MTurkR](https://github.com/cloudyr/MTurkR). pyMTurkR provides access to the latest Amazon Mechanical Turk (MTurk) <https://www.mturk.com> Requester API (version '2017–01–17'), using `reticulate` to wrap the `boto3` SDK for Python.


## Why make this?

pyMTurkR was created because on June 1, 2019 Amazon [deprecated the MTurk API (version '2014-08-15')](https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI-legacy/Welcome.html) that MTurkR was using, rendering it obsolete. This package was created to maintain MTurk access for R users while migrating to the new MTurk API (version '2017–01–17').

pyMTurkR is not a native R language package. It uses [`reticulate`](https://rstudio.github.io/reticulate) to import and wrap the [`boto3`](https://aws.amazon.com/sdk-for-python) module for Python. Cross-language dependency is not necessarily a bad thing, and from the user perspective there is probably no difference, besides a few extra installation steps. Welcome to the wonderful world of R-python interoperability.


## What can it do?

This package provides access to the MTurk API operations ([see API reference for details](https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_ListWorkersWithQualificationTypeOperation.html)) and provides many convenience functions that make operations even easier. It has nearly 100% coverage of the original MTurkR functions.

See the [pyMTurkR documentation](pyMTurkR_0.5.7.pdf) for a full list of operations available.


# Installation

## Pre-package installation

Windows users should install [Anaconda](https://conda.io/projects/conda/en/latest/user-guide/install/windows.html).

1. Install the `reticulate` R package if you don't have it already

```
install.packages('reticulate')
```

2. Use reticulate to install python with the boto3 python library
 
```
reticulate::py_install("boto3")
```
  
3. Install the `pyMTurkR` package

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

![functions coded](https://img.shields.io/badge/functions_coded-100%25-brightgreen.svg)
![unit tests](https://img.shields.io/badge/unit_tests-0%25-red.svg)

This package is `experimental` because it has not been fully tested.

All of the functions have been written and unit tests are now in progress.

For development updates see the [changelog](https://github.com/cloudyr/pyMTurkR/blob/master/CHANGELOG.md).

# Package maintainer / author

This package is written and maintained by [Tyler Burleigh](https://www.tylerburleigh.com).

<a href="https://twitter.com/intent/follow?screen_name=tylerburleigh"><img src="https://img.shields.io/twitter/follow/tylerburleigh?style=social&logo=twitter" alt="follow on Twitter"></a>
