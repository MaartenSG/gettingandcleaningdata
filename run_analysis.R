# This script contains the R code for the final project of the
# getting and Cleaning Data course. 
# Full description of the dataset, variables, transformations and adjustments 
# to the data and reasoning behind it can be found in the CodeBook.md document. 


# download dataset
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl, destfile="dataset.zip", method="curl")

#unzip file outside R

#set working directory to whereever the UCI HAR dataset folder is located
setwd("~/coursera/Getting\ and\ Cleaning\ Data/project/")

#load data, process and combine train and test sets
train <- read.table("./UCI\ HAR\ Dataset/train/X_train.txt")
activity.train <- read.table("./UCI\ HAR\ Dataset/train/y_train.txt")
subject.train <- read.table("./UCI\ HAR\ Dataset/train/subject_train.txt")

test <- read.table("./UCI\ HAR\ Dataset/test/X_test.txt")
activity.test <- read.table("./UCI\ HAR\ Dataset/test/y_test.txt")
subject.test <- read.table("./UCI\ HAR\ Dataset/test/subject_test.txt")

varnames <- read.table("./UCI\ HAR\ Dataset/features.txt", stringsAsFactors=FALSE)
#some variable names are duplicated, add the index number to the varnames to make them unique
vn <- paste(varnames[,2], varnames[,1], sep="-") 

#check data structures
dim(train)
dim(test)
dim(activity.train)
dim(activity.test)
dim(subject.train)
dim(subject.test)

#identical number of records in the training data and in the test data
#use dplyr bind_cols to bind columns together for the training and test set


library(dplyr)
activity.train <- mutate(activity.train, subset = "train")
train <- bind_cols(subject.train, activity.train,train)

activity.test <- mutate(activity.test, subset = "test")
test <- bind_cols(subject.test, activity.test,test)

data <- rbind(train,test)
colnames(data) <- c("subj_id", "activity_id", "subset", vn)

#---------------------------------------
# extract mean and sd related measurements
# use dplyr select

datas <- data %>% select(subj_id:subset, matches(".-mean.|.-std.")) %>% 
		select(-contains("meanFreq")) %>% tbl_df()

# remove garbage from column names
names(datas) <- gsub("-|\\(|\\)|[0-9]+$", "", names(datas))
names(datas) <- sub("BodyBody", "Body", names(datas))

#---------------------------------------
# add activity descriptions

actdesc <- read.table("./UCI\ HAR\ Dataset/activity_labels.txt")
colnames(actdesc) <- c("activity_id", "activity")

datad <- datas %>% left_join(actdesc) %>% 
		select(subj_id, activity_id, activity, subset: fBodyGyroJerkMagstd)

#--------------------------------
# step 5: summarize with mean of each variable by activity and subject

datad <- group_by(datad, activity, subj_id)
td <- summarize_at(datad, vars(tBodyAccmeanX:fBodyGyroJerkMagstd), mean)

#td <- group_by(td, activity)
#td2 <- summarize_at(td, vars(tBodyAccmeanX:fBodyGyroJerkMagstd), mean)

write.table(td, "tidy_dataset.txt", row.name=FALSE)

#----------------------------------------------------------------------------------
# the following are examples of how to extract variable types from this dataset
# it is not necessarily part of the assignment but it is a good exercise

library(tidyr)
# add this row to uniquely identify observations later with spread
datad <- mutate(as.data.frame(datad), row= 1:nrow(datad)) 

# example of how to extract the calculation variable type from a subset of dataset variables
# resulting data is correct but does not allow for easy interpretation

td2 <- as.data.frame(datad) %>% select(row, activity, subj_id, tBodyAccmeanX: tBodyAccstdZ) %>%
	gather(key, value, -activity, -subj_id, -row) %>%
	mutate(measure = sub("mean|std","",key)) %>%
	extract(key, "calc", "(mean|std)") %>%
	spread(measure,value) %>%
	group_by(activity, subj_id, calc) %>%
	summarize_at(vars(tBodyAccX:tBodyAccZ), mean)

# example of how to extract the calculation and domain variable types from a subset of dataset variables
# resulting data is correct but now introduces many NA values

td3 <- as.data.frame(datad) %>% select(row, activity, subj_id, tBodyAccmeanX: tBodyAccstdZ, fBodyGyroMagmean, fBodyGyroMagstd) %>%
	gather(key, value, -activity, -subj_id, -row) %>%
	mutate(measure = sub("mean|std","",key)) %>%
	extract(key, "calc", "(mean|std)") %>%
	extract(measure, c("domain","measure"), "(^t|^f)(.+)") %>%
	spread(measure,value) %>%
	group_by(activity, subj_id, calc) %>%
	summarize_at(vars(tBodyAccX:tBodyAccZ), mean)


