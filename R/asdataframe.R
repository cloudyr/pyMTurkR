# HITs

as.data.frame.HITs <- function(hits) {

  HITs <- emptydf(length(hits), 19, c("HITId", "HITTypeId", "HITGroupId",
                                         "CreationTime", "Title", "Description", "Keywords", "HITStatus",
                                         "MaxAssignments", "Amount", "AutoApprovalDelayInSeconds",
                                         "Expiration", "AssignmentDurationInSeconds",
                                         "HITReviewStatus", "RequesterAnnotation", "NumberOfAssignmentsPending",
                                         "NumberOfAssignmentsAvailable", "NumberOfAssignmentsCompleted",
                                         "Question"))
  for (i in 1:length(hits)) {

    hit <- hits[[i]]
    HITs[i, 1] <- hit$HITId
    HITs[i, 2] <- hit$HITTypeId
    HITs[i, 3] <- hit$HITGroupId
    HITs[i, 4] <- reticulate::py_to_r(hit$CreationTime)
    HITs[i, 5] <- hit$Title
    HITs[i, 6] <- hit$Description
    if (!is.null(hit$Keywords)) {
      HITs[i, 7] <- hit$Keywords
    }
    HITs[i, 8] <- hit$HITStatus
    HITs[i, 9] <- hit$MaxAssignments
    if (!is.null(hit$Reward)) {
      HITs[i, 10] <- hit$Reward
    }
    HITs[i, 11] <- hit$AutoApprovalDelayInSeconds
    HITs[i, 12] <- reticulate::py_to_r(hit$Expiration)
    HITs[i, 13] <- hit$AssignmentDurationInSeconds
    HITs[i, 14] <- hit$HITReviewStatus
    if (!is.null(hit$RequesterAnnotation)) {
      HITs[i, 15] <- hit$RequesterAnnotation
    }
    HITs[i, 16] <- hit$NumberOfAssignmentsPending
    HITs[i, 17] <- hit$NumberOfAssignmentsAvailable
    HITs[i, 18] <- hit$NumberOfAssignmentsCompleted
    HITs[i, 19] <- hit$Question
  }

  return(HITs)
}



# QUALIFICATION STRUCTURES

as.data.frame.QualificationRequirements <- function(hits, sandbox = TRUE, profile = 'default') {

  return.quals <- emptydf(nrow = 0, ncol = 5,
                   c("HITId", "QualificationTypeId", "Name", "Comparator", "Value"))

  for (i in 1:length(hits)) {

    hit <- hits[[i]]
    hitid <- hit$HITId
    quals <- hit$QualificationRequirements

    Quals <- emptydf(length(quals), 5, c('HITId', 'QualificationTypeId', 'Name', 'Comparator', 'Value'))

    if(length(quals) > 0) {

      for (k in 1:length(quals)) {

          qual <- quals[[k]]
          # Get name
          client <- GetClient(sandbox, profile) # Boto3 client
          qual.lookup <- client$get_qualification_type(QualificationTypeId = qual$QualificationTypeId)

          Quals[k, 1] <- hitid
          Quals[k, 2] <- qual$QualificationTypeId
          Quals[k, 3] <- qual.lookup$QualificationType$Name
          Quals[k, 4] <- qual$Comparator
          Quals[k, 5] <- qual$Value
      }
    } else {
      Quals[1, 1] <- hitid
    }
    return.quals <- rbind(Quals, return.quals)

  }

  return(return.quals)

}

