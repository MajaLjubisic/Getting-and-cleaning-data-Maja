# 
# You should create one R script called run_analysis.R that does the following.
# 


# Merges the training and the test sets to create one data set.



download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip",exdir=".")
file.rename("UCI HAR Dataset", "data")

x_train <- read.table("./data/train/X_train.txt")
y_train <- read.table("./data/train/y_train.txt")
subject_train <- read.table("./data/train/subject_train.txt")


x_test <- read.table("./data/test/X_test.txt")
y_test <- read.table("./data/test/y_test.txt")
subject_test <- read.table("./data/test/subject_test.txt")


features <- read.table('./data/features.txt')
activityLabels = read.table('./data/activity_labels.txt')


colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
merged <- rbind(merge_train, merge_test)
colNames <- colnames(merged)

# Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std <- (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) |  grepl("std.." , colNames) )

setForMeanAndStd <- merged[ , mean_and_std == TRUE]



# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.

setWithActivityNames <- merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)



# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

indTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
indTidySet <- indTidySet[order(indTidySet$subjectId, indTidySet$activityId),]
write.table(indTidySet, "independentTidySet.txt", row.name=FALSE)
