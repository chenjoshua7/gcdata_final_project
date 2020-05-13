library(dplyr)
library(reshape2)

#PART 1
## Getting the data:
getUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(getUrl,"dataset.zip")
unzip("dataset.zip")

## Storing
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
### Storing Test
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
### Storing Train
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Binding
test <- cbind(x_test, y_test, subject_test)
train <- cbind(x_train, y_train, subject_train)
complete <- rbind(test, train)

#PART 2
data <- complete %>% 
  select(subject, code, contains("mean"), contains("std"))
colnames(data)[2] <- "activities"


#PART 3:
data$activities <- activities[data$activities, 2]

#PART 4:
names <- features[wanted_features,2]
names <- gsub("-mean", "Mean", names)
names <- gsub("-std", "Std", names)
names <- gsub("-freq", "Freq", names)
names <- gsub('[-()]', '', names)
colnames(data) <- names

#PART 5:
data_melt <- melt(data, id = c("subject", "activities"))
final <- dcast(data_melt, subject + activities ~ variable, mean)
write.table(final, "final_data.txt", row.names = FALSE)