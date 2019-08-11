.onLoad <- function(libname, pkgname){
    if (is.null(getOption("pyMTurkR.sandbox"))) {
        options(pyMTurkR.sandbox = FALSE)     # sandbox logical
    }
    if (is.null(getOption("pyMTurkR.verbose"))) {
        options(pyMTurkR.verbose = TRUE)      # print logical
    }
    if (is.null(getOption("pyMTurkR.logdir"))) {
        options(pyMTurkR.logdir = getwd())    # pyMTurkRlog.tsv directory
    }
    if (is.null(getOption("pyMTurkR.test"))) {
        options(pyMTurkR.test = FALSE)        # validation.test logical
    }
}
