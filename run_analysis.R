## Coursera Getting and Cleaning Data Course Project
## -------------------------------------------------
# ASSIGNMENT
# You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Download data if necessary (set working directory first!!)
if (!file.exists("./UCI\ HAR\ Dataset")){
    print("No data directory exists.")
    if (!file.exists("getdata-projectfiles-UCI\ HAR\ Dataset.zip")) {
        print("Downloading data zipfile.")
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,
                      destfile = "getdata-projectfiles-UCI\ HAR\ Dataset.zip",
                      method = "curl")
    }
    print("Uncompressing data file.")
    unzip("getdata-projectfiles-UCI\ HAR\ Dataset.zip")
}

## Step 1
# There are 6 datasets of interest. We merge them in 5 steps.
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses = c("numeric"))
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", colClasses = c("numeric"))
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", colClasses = c("numeric"))
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", colClasses = c("numeric"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", colClasses = c("numeric"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", colClasses = c("numeric"))

# Merge train and test data for each of 3 types X, Y, and subject
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
subject <- rbind(subject_train, subject_test)

# Merge into 1 data.frame
merged_df <- cbind(X, Y, subject)

print(dim(merged_df)) # Expect 10299 x 563

# Remove unneeded raw data frames from memory
rm(X_train, Y_train, subject_train, X_test, Y_test, subject_test, X, Y, subject)

## Step 2
# Find features involving mean or std
features <- read.table("UCI HAR Dataset/features.txt",
                       colClasses = c("numeric", "character"))
indices <- grepl("mean\\(|std\\(", features[,2])
print(features[indices,]) # expect 66 features

meanstd_df <- merged_df[,indices]

## Step 3
# Replace Y column with strings from activity_labels.txt

## Step 4

## Step 5