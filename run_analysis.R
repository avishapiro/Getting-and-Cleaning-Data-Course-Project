## Coursera Getting and Cleaning Data Course Project
## -------------------------------------------------
# ASSIGNMENT
# You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## -------------------------------------------------


## Step 0 ------------------------------------------------- ##
# Download data if necessary (set working directory first!!)
print("Checking for raw data...")
if (!file.exists("./UCI\ HAR\ Dataset")){
    print("No raw data directory exists.")
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
print("Raw data is ready for processing.")

## Step 1 ------------------------------------------------- ##
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

# print(dim(merged_df)) # Expect 10299 x 563

# Remove unneeded raw data frames from memory
rm(X_train, Y_train, subject_train, X_test, Y_test, subject_test, X, Y, subject)

print("Step 1 finished")

## Step 2 ------------------------------------------------- ##
# Extract features involving mean or std
features <- read.table("UCI HAR Dataset/features.txt",
                       colClasses = c("numeric", "character"))
indices <- grepl("mean\\(|std\\(", features[,2])
# print(features[indices,]) # expect 66 features

meanstd_df <- merged_df[,indices]

# Remove unneeded data.frame
rm(merged_df)

print("Step 2 finished")

## Step 3 ------------------------------------------------- ##
# Replace Y column integers with strings from activity_labels.txt

f <- function(d) {
    if (d==1) return("walking")
    if (d==2) return("walking upstairs")
    if (d==3) return("walking downstairs")
    if (d==4) return("sitting")
    if (d==5) return("standing")
    if (d==6) return("laying")
}

desc_activity_df <- meanstd_df
desc_activity_df[, "V1.1"] <- as.factor(sapply(meanstd_df[, "V1.1"], f))

# Remove unneeded data.frame
rm(meanstd_df)

print("Step 3 finished")

## Step 4 ------------------------------------------------- ##
# Label the features with proper, descriptive R names
feature_names <- gsub("\\(\\)", "", features[indices, 2])
feature_names <- gsub("-", "", feature_names)
feature_names <- gsub("mean", "Mean", feature_names)
feature_names <- gsub("std", "Std", feature_names)
feature_names <- gsub("Acc", "Accelerometer", feature_names)
feature_names <- gsub("Gyro", "Gyrometer", feature_names)
feature_names <- gsub("Mag", "Magnitude", feature_names)
names(desc_activity_df) <- c(feature_names, "activity", "subject")
clean_df <- desc_activity_df

# Remove unneeded data.frame
rm(desc_activity_df, features)

print("Step 4 finished")

## Step 5 ------------------------------------------------- ##
# Create tidy summary data set
s <- split(clean_df[, !names(clean_df) %in% c("activity", "subject")],
           list(clean_df$activity, clean_df$subject))
tidy_df <- data.frame(t(data.frame(lapply(s, colMeans))))

# Remove unneeded data.frame
rm(s)

# Save tidy data set to file
write.table(tidy_df, file = "tidy_data.txt", row.names = FALSE)

print("Step 5 finished")
print("Tidy data set has been written to tidy_data.txt.")

## End of script ------------------------------------------------- ##