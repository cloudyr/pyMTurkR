.onLoad <- function(libname, pkgname){
  if (is.null(getOption("pyMTurkR.sandbox"))) {
      options(pyMTurkR.sandbox = TRUE)     # sandbox logical
  }
  if (is.null(getOption("pyMTurkR.verbose"))) {
      options(pyMTurkR.verbose = TRUE)      # print logical
  }
  pyMTurkR <<- new.env()
}
