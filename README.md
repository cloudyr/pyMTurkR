# R Client for the MTurk Requester API using the AWS SDK for Python (Boto3) #

![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)
![version](https://img.shields.io/badge/version-0.2.3-blue.svg)
![progress](https://img.shields.io/badge/progress-40%25-yellowgreen.svg)

**pyMTurkR** is a successor to [MTurkR](https://github.com/cloudyr/MTurkR), and a work in progress. pyMTurkR provides access to the Amazon Mechanical Turk [Amazon Mechanical Turk](https://requester.mturk.com) (MTurk) [Requester API](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI/Welcome.html), by wrapping around the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python) [MTurk Client](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/mturk.html).

Because pyMTurkR uses Python, it requires some additional setup and configuration:

  1. Install Python 2 (>= 2.7) or Python 3 (>= 3.3) ([download page](https://www.python.org/downloads))
  2. Install `pip` for Python ([see "Installing with get-pip.py" here](https://pip.pypa.io/en/stable/installing))
  3. Use `pip` to install boto3 ([see "Installation" here](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#installation))
  
In case you run into problems, see the Troubleshooting section at the end of this readme file.

## Why make this? ##

pyMTurkR was started because Amazon decided to [deprecate the API](https://docs.aws.amazon.com/AWSMechTurk/latest/AWSMturkAPI-legacy/Welcome.html) that MTurkR was using (meaning MTurkR would stop working). The goal of this project is to create a package that functions in a way that will be familiar to MTurkR users, making the transition easier.

Unlike MTurkR, pyMTurkR is not a native R-language package. This is because it uses Python and the `boto3` module for Python. This is not necessarily a bad thing, and from the user perspective there is probably in most cases little difference. With recent developments in R, such as the [`reticulate`](https://rstudio.github.io/reticulate) package which this package depends on, R can interface with Python relatively seamlessly, and in the case of this package there shouldn't be any noticeable issues with speed or performance. 

Because this package relies on python and boto3, this might create some additional work for the user. Namely, in addition to updating R and the R packages that pyMTurkR depends on, there is the potential additional work of updating Python and the boto3 module, should those require updating in the future. 

For a deeper dive on issues related to dependencies, see [Dependency Hell on Wikipedia](https://en.wikipedia.org/wiki/Dependency_hell).

## What can it do? ##

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
- GenerateQualificationRequirement()
- GenerateHITsFromTemplate()
- GenerateHTMLQuestion()
- GetAssignment()
- GetHIT()
- ExtendHIT()
- RegisterHITType()
- SearchHITs()

## Installation ##

The development version of pyMTurkR can be installed from this repo using `devtools`.

```R
library(devtools)
install_github("cloudyr/pyMTurkR")
```

## Usage ##

### Set AWS Access Key / Secret Access Keys ###

pyMTurkR will look for your AWS keys in two locations.

Keys can be set as R environment variables:

```R
Sys.setenv(AWS_ACCESS_KEY_ID = "my access key")
Sys.setenv(AWS_SECRET_ACCESS_KEY = "my secret key")
```

Or keys can be set in an AWS credentials file using the [AWS CLI](http://aws.amazon.com/cli) ([see "Configuration" here](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#configuration)).

### Set API Environment (sandbox or live) ##

By default, pyMTurkR will run in "sandbox" mode. To change this setting, the `pyMTurkR.sandbox` option must be set to `FALSE` before running any commands.

```R
R.utils::setOption("pyMTurkR.sandbox", FALSE)
getOption("pyMTurkR.sandbox") # Show current value (NULL if unset)
```

### Usage Examples ###

```R
library("pyMTurkR")
Sys.setenv(AWS_ACCESS_KEY_ID = "ABCD1234")
Sys.setenv(AWS_SECRET_ACCESS_KEY = "EFGH5678")
R.utils::setOption("pyMTurkR.sandbox", FALSE) # Run in live environment
AccountBalance()
```

## Help! I want to do [thing] but you haven't written that function yet! ##

Not all functions that existed in MTurkR or in the MTurk API have been written yet. However! Because this package is a wrapper to the `boto3` SDK, you also have the option to access those functions.

### Example ###

For example, in MTurkR if you wanted to add assignments to a HIT, you would use `ExtendHIT()`. But in pyMTurkR 0.1.8 that function had not yet been written. Instead, the user could access the `boto3` function that pyMTurkR would eventually wrap around, by doing the following:

```R
my_client <- GetClient()
my_client$create_additional_assignments_for_hit(
    HITId = 'myHITId',
    NumberOfAdditionalAssignments = as.integer(1)
)
```

See the [boto3 documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/mturk.html) for all functions that are available to access like this. This documentation is for python and there are some quirks about accessing these functions. For example, notice how `NumberOfAdditionalAssignments` was cast as an integer? Reticulated functions seem to be stricter than native R about parameter types.

## Development status ##

For development updates see the [Changelog](https://github.com/cloudyr/pyMTurkR/blob/master/CHANGELOG.md)

You can also follow [@py_mturk](https://twitter.com/py_turk) on Twitter for updates there.

## Troubleshooting ##

One of the issues you might encounter, especially if you maintain multiple installs of python on your system, is that when `reticulate` loads python it loads a version that you didn't install the `boto3` module into. 

After loading pyMTurkR, or manually loading `reticulate`, you can check the version and system path of the python install that it's using

```
> reticulate::py_config()

python:         C:\Users\tyler\AppData\Local\Programs\Python\Python37\\python.exe
libpython:      C:/Users/tyler/AppData/Local/Programs/Python/Python37/python37.dll
pythonhome:     C:\Users\tyler\AppData\Local\Programs\Python\Python37
version:        3.7.1 (v3.7.1:260ec2c36a, Oct 20 2018, 14:57:15) [MSC v.1915 64 bit (AMD64)]
Architecture:   64bit
numpy:          C:\Users\tyler\AppData\Roaming\Python\Python37\site-packages\numpy
numpy_version:  1.15.4

python versions found: 
 C:\Users\tyler\AppData\Local\Programs\Python\Python37\\python.exe
 C:\Python27\\python.exe
 C:\Python36\\python.exe
```

For example, here I see that it's using an install of python that's located in my users folder, and it found 3 different python installs in my system. 

If I try to load the boto3 module, `reticulate` might complain that it can't find it because it's pointing to a different install path.

This can be solved in one of two ways.

1. Change the python path: The python path can be manually changed after loading pyMTurkR, to specify an install that has the boto3 module. However, note that you will have to set this path at the very beginning of your script. There's a quirk in reticulate that doesn't allow it to be changed after python commands have been invoked.

```
library("pyMTurkR")
reticulate::use_python("C:\\Python36\\python.exe")
```

2. Install the boto3 module for the python it defaults to: You can install the boto3 module for whatever python install `reticulate` happens to be using by issuing a system command through the R console, with the same pip install code as before.

```
system("pip install boto3")
```

## Migration / Key API differences ##

For information about API differences, including new operations, or operations that were renamed or deprecated see the [MTurk Requester API Migration Guide](https://medium.com/@mechanicalturk/mturk-requester-api-migration-guide-3497398ba37f).
