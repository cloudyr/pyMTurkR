approveall <-
  ApproveAllAssignments <-
  function(hit = NULL,
           hit.type = NULL,
           annotation = NULL,
           feedback = NULL,
           rejected = FALSE,
           status = NULL,
           verbose = getOption('pyMTurkR.verbose', TRUE)) {

    client <- GetClient() # Boto3 client

    # Validate feedback parameter
    if(!is.null(feedback)){
      if (length(feedback) > 1) {
        stop("Can only specify one feedback message; no assignments approved")
      } else if(nchar(feedback) > 1024) {
        stop(paste0("Feedback is too long (1024 char max); no assignments approved"))
      }
    }

    # Validate hit, hit.type. annotation parameters -- must have one
    if (all(is.null(hit), is.null(hit.type), is.null(annotation))) {
      stop("Must provide 'hit' xor 'hit.type' xor 'annotation'")
    } else if (!is.null(hit)) {
      assignments <- GetAssignments(hit = hit,
                                    status = status,
                                    verbose = verbose)$AssignmentId

    } else if (!is.null(hit.type)) {
      assignments <- GetAssignments(hit.type = hit.type,
                                    status = status,
                                    verbose = FALSE)$AssignmentId

    } else if (!is.null(annotation)) {
      assignments <- GetAssignments(annotation = annotation,
                                    status = status,
                                    verbose = FALSE)$AssignmentId

    }

    if (length(assignments) == 0) {
      return(emptydf(0, 3, c("AssignmentId", "Feedback", "Valid")))
    } else {
      request <- ApproveAssignments(assignments = assignments,
                                    rejected = rejected,
                                    feedback = feedback,
                                    verbose = verbose)
      return(request)
    }
  }
