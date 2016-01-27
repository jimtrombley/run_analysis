#call DPLYR
library(dplyr)


# Merges train, test, and subject datasets
  x_train <- read.table("train/X_train.txt", header = FALSE)
  x_test <- read.table("test/X_test.txt", header = FALSE)
  y_train <- read.table("train/y_train.txt", header = FALSE)
  y_test <- read.table("test/y_test.txt", header = FALSE)
  subject_train <- read.table("train/subject_train.txt", header = FALSE)
  subject_test <- read.table("test/subject_test.txt", header = FALSE)
  x <- rbind(x_train, x_test)
  y <- rbind(y_train, y_test)
  s <- rbind(subject_train, subject_test)

# Extracts mean and standard deviation measurements columns from dataset
  features <- read.table("features.txt")
  names(features) <- c('feat_id', 'feat_name')
  index_features <- grep("?mean\\()*|?std\\()?", features$feat_name)
  x <- x[, index_features]
  names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))
 
# Assigns activity names to dataset
  activities <- read.table("activity_labels.txt")
  names(activities) <- c('act_id', 'act_name')
  y[, 1] = activities[y[, 1], 2]
  names(y) <- "Activity"
  names(s) <- "Subject"

# Combines data table by columns
  tidyDataSet <- cbind(s, y, x)
  
# Creates tidy data set with the average of each variable for each activity and subject
  p <- tidyDataSet[, 3:length(tidyDataSet)]
  tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
  names(tidyDataAVGSet)[1] <- "Subject"
  names(tidyDataAVGSet)[2] <- "Activity"# Created csv (tidy data set) in diretory
  write.table(tidyDataAVGSet, tidy-UCI-HAR-dataset-AVG.txt)
