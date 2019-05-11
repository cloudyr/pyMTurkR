This folder contains old and new documentation files.

Old documentation is contained in the two subfolders prefixed by "old".

	- old_Rd contains the original files
	- old_R contains the files converted to R format (mainly because I don't want to work in LaTeX :)
	
New documentation files are the .Rd files in the root of this folder.	

The goal is to have this documentation updated and then integrated into the function files in the R/ folder. For an example, see R/AccountBalance.R. This will allow roxygen2 to generate the new .Rd files.