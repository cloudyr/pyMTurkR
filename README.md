# pyMTurkR: An R Package to Interface with the MTurk Requester API <img src="https://raw.githubusercontent.com/cloudyr/pyMTurkR/master/assets/hex-pyMTurkR.png" align="right" width="200" />

<!-- badges: start -->
[![travis-ci](https://travis-ci.org/cloudyr/pyMTurkR.svg?branch=master)](https://travis-ci.org/cloudyr/pyMTurkR?branch=master)
[![Codecov test coverage](https://codecov.io/gh/cloudyr/pyMTurkR/branch/master/graph/badge.svg)](https://codecov.io/gh/cloudyr/pyMTurkR?branch=master)
![version](https://img.shields.io/badge/version-1.0-blue.svg)
![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)
![downloads](https://img.shields.io/badge/downloads-142-brightgreen)
<!-- badges: end -->

**pyMTurkR** is an R package that allows you to interface with MTurk's Requester API. 

pyMTurkR provides access to the latest Amazon Mechanical Turk (<a href='https://www.mturk.com'>MTurk</a>) Requester API (<a href="https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_CreateHITOperation.html">version '2017-01-17'</a>), using `reticulate` to wrap the `boto3` SDK for Python. pyMTurkR is a replacement for the now obsolete [MTurkR](https://github.com/cloudyr/MTurkR).

Using this package, you can perform operations like: creating HITs, updating HITs, creating custom Qualifications, reviewing submitted Assignments, approving/rejecting Assignments, sending bonus payments to Workers, sending messages to Workers, blocking/unblocking Workers, and many more. See the [pyMTurkR documentation](assets/pyMTurkR.pdf) for a full list of operations available.


## Why make this?

pyMTurkR was created because on June 1, 2019 Amazon [deprecated the MTurk API (version '2014-08-15')](https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI-legacy/Welcome.html) that MTurkR was using, rendering it obsolete. This package was created to maintain MTurk access for R users while migrating to the new MTurk API (version '2017-01-17').

pyMTurkR is not a native R language package. It uses [`reticulate`](https://rstudio.github.io/reticulate) to import and wrap the [`boto3`](https://aws.amazon.com/sdk-for-python) module for Python. Cross-language dependency is not necessarily a bad thing, and from the user perspective there is probably no difference, besides a few extra installation steps. Welcome to the wonderful world of R-python interoperability.


# Installation

## 1. Install `python` and `pip`

1.1. Install `python 2` (>= 2.7) or `python 3` (>= 3.3) ([download page](https://www.python.org/downloads))

1.2. Install `pip` for `python` 

 - Windows users: [see "Installing with get-pip.py" here](https://pip.pypa.io/en/stable/installing)
 - Mac users: run `sudo easy_install pip` to install pip

1.3. Install `reticulate` for R

```
install.packages("reticulate")
```

1.4. Check that `reticulate` can now find `python`. You may have to restart RStudio.

```
reticulate::py_config()
```

1.5. Check that `pip` can be found

```
system("pip --version")
```

## 2. Install `boto3`

2.1. Find the default `python` path that `reticulate` is using

```
reticulate::py_config()
```

Take note of the path in the first line (e.g., "/usr/bin/python").

2.2. Find the path that the system `pip` command is using

```
system("pip --version")
```

For example, in "pip 18.0 from /usr/local/lib/python2.7/site-packages/pip" the `python` path is "/usr/local/lib/python2.7"). If the path here does not match the py_config() path, then you may need to manually set the path using `use_python()`.

```
reticulate::use_python("/usr/local/lib/python2.7", required = TRUE)
```

You may have to restart RStudio before setting the path if you have run other `reticulate` operations.

2.3. Install `boto3` using `pip`

```
system("pip install boto3")
```

Or alternatively, run this command in the system terminal (`sudo pip install boto3` for Mac users).

2.4. Check if you can now import boto3. You may have to restart RStudio.

```
reticulate::import("boto3")
```

For additional install options, [see "Installing Python Packages" in the `reticulate` docs](https://rstudio.github.io/reticulate/articles/python_packages.html).


## 3. Install `pyMTurkR`

3.1. Finally, you can install `pyMTurkR`.

```
devtools::install_github("cloudyr/pyMTurkR")
```


# Usage

Before using the package, you will need to retrieve your "Access" and "Secret Access" keys from Amazon Web Services (AWS). [See "Understanding and Getting Your Security Credentials"](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html).

## Set AWS keys

The Access and Secret Access keys should be set as environment variables in R prior to running any API operations.

```R
Sys.setenv(AWS_ACCESS_KEY_ID = "MY_ACCESS_KEY")
Sys.setenv(AWS_SECRET_ACCESS_KEY = "MY_SECRET_ACCESS_KEY")
```

## Set environment (Sandbox or Live)

pyMTurkR will run in "sandbox" mode by default. It is good practice to test any new methods, procedures, or code in the sandbox first before going live. To change this setting and use the live environment, set `pyMTurkR.sandbox` to `FALSE`.

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

# Changelog

For development updates see the [changelog](https://github.com/cloudyr/pyMTurkR/blob/master/CHANGELOG.md).

# Package maintainer / author

pyMTurkR is written and maintained by [Tyler Burleigh](https://tylerburleigh.com).

<a href="https://twitter.com/intent/follow?screen_name=tylerburleigh"><img src="https://img.shields.io/twitter/follow/tylerburleigh?style=social&logo=twitter" alt="follow on Twitter"></a>

## Additional credits

pyMTurkR borrows code from MTurkR, written by [Thomas J. Leeper](https://thomasleeper.com). pyMTurkR's logo borrows elements from Amazon, R, and python logos; the "three people" element is thanks to Muammark / Freepik.
