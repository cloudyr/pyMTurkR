# R Client for the MTurk Requester API using the AWS SDK for Python (Boto3) #

**pyMTurkR** is a successor to [MTurkR](https://github.com/cloudyr/MTurkR), and a work in progress. pyMTurkR provides access to the Amazon Mechanical Turk [Amazon Mechanical Turk](https://requester.mturk.com) (MTurk) [Requester API](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html), by wrapping around the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python) [MTurk Client](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/mturk.html).

Because pyMTurkR uses Python, it requires some additional setup and configuration:

  1. Install Python 2 (>= 2.7) or Python 3 (>= 3.3) ([download page](https://www.python.org/downloads))
  2. Install `pip` for Python ([see "Installing with get-pip.py" here](https://pip.pypa.io/en/stable/installing))
  3. Use `pip` to install boto3 ([see "Installation" here](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#installation))
  
You'll also need to configure an AWS credentials file.

  1. Find your AWS credentials (Key and Secret Key) in the [IAM Console](https://console.aws.amazon.com/iam/home)
  2. Use [AWS CLI](http://aws.amazon.com/cli) to configure the credentials file, or manually create a credentials file ([see "Configuration" here](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#configuration))

## Why Make This? ##

pyMTurkR was started because Amazon decided to [deprecate the API](https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI-legacy/Welcome.html) that MTurkR was using (meaning MTurkR would stop working). The goal of this project is to create a package that functions in a way that will be familiar to MTurkR users, making the transition easier.

Unlike MTurkR, pyMTurkR is not a native R-language package. This is because it uses Python and the `boto3` module for Python. This is not necessarily a bad thing, and from the user perspective there is probably in most cases little difference. With recent developments in R, such as the [`reticulate`](https://rstudio.github.io/reticulate) package which this package depends on, R can interface with Python relatively seamlessly, and in the case of this package there shouldn't be any noticeable issues with speed or performance. 

Because this package relies on python and boto3, this might create some additional work for the user. Namely, in addition to updating R and the R packages that pyMTurkR depends on, there is the potential additional work of updating Python and the boto3 module, should those require updating in the future. 

For a deeper dive on issues related to dependencies, see ["Dependency Hell" on Wikipedia](https://en.wikipedia.org/wiki/Dependency_hell).

## Installation ##

The development version of pyMTurkR can be installed from this repo using `devtools`.

```R
library(devtools)
install_github("tylerburleigh/pyMTurkR")
```

## Usage ##

```R
library("pyMTurkR")
AccountBalance()
```

## Development Status ##

For development updates see the [Changelog](https://github.com/tylerburleigh/pyMTurkR/blob/master/CHANGELOG.md)

