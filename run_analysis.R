## Load both datasets ##
test <- read.table("X_test.txt")
train <- read.table("X_train.txt")
rm(trainact,testact)

## Label the columns based on features file
features  <- read.table("features.txt", colClasses = "character")
features_vector <- features$V2
features_vector <- tolower(features_vector)
features_vector <- gsub("\\()","",features_vector)
features_vector <- gsub("-","",features_vector)
names(test) <- features_vector
names(train) <- features_vector

## Extract only the mean and standard deviation per measurement
colselectmean <- grep("mean",names(train))
colselectstd <- grep("std",names(train))
columns_to_keep <- c(colselectmean, colselectstd)
train = select(train, all_of(columns_to_keep))
colselectmean <- grep("mean",names(test))
colselectstd <- grep("std",names(test))
columns_to_keep <- c(colselectmean, colselectstd)
test = select(test, all_of(columns_to_keep))
rm("colselectstd","colselectmean")

## Add activity label column 
testact <- read.table("y_test.txt")
trainact <- read.table("y_train.txt")
names(testact) <- "activitylabel"
names(trainact) <- "activitylabel"
test <- cbind(test, testact)
train <- cbind(train, trainact)

## Label the activities in the data set
train$activitylabel <- sub("1","walking",train$activitylabel)
train$activitylabel <- sub("2","walking_upstairs",train$activitylabel)
train$activitylabel <- sub("3","walking_downstairs",train$activitylabel)
train$activitylabel <- sub("4","sitting",train$activitylabel)
train$activitylabel <- sub("5","standing",train$activitylabel)
train$activitylabel <- sub("6","laying",train$activitylabel)

test$activitylabel <- sub("1","walking",test$activitylabel)
test$activitylabel <- sub("2","walking_upstairs",test$activitylabel)
test$activitylabel <- sub("3","walking_downstairs",test$activitylabel)
test$activitylabel <- sub("4","sitting",test$activitylabel)
test$activitylabel <- sub("5","standing",test$activitylabel)
test$activitylabel <- sub("6","laying",test$activitylabel)

## Add subject column to both the datasets
testsub <- read.table("subject_test.txt")
trainsub <- read.table("subject_train.txt")
names(testsub) <- "subject"
names(trainsub) <- "subject"
test <- cbind(test, testsub)
train <- cbind(train, trainsub)
rm("trainsub","testsub")

## Merge the both datasets
merged = merge(test, train, all=TRUE) 

## Export the tidy dataset
write.table(merged, "tidyset.txt", row.names = FALSE)

## Find average values for subject and activity

library(plyr)
library(dplyr)

act <- merged %>% 
  group_by(activitylabel,subject) %>% 
  summarise_each(funs(mean))

## Export the tidy grouped dataset
write.table(merged, "tidyset_grouped.txt", row.names = FALSE)
