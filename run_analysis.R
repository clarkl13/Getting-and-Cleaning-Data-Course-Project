##Getting and Cleaning Data Assignment
##Created 6/5/2018
##========================================================================================

#Read in all data for project-----------------------------------------------------------

x_test <- read.table("./test/X_test.txt", header = FALSE)
y_test <- read.table("./test/y_test.txt", header = FALSE) 
x_train <- read.table("./train/X_train.txt", header = FALSE)
y_train <- read.table("./train/y_train.txt", header = FALSE)
subject_train <- read.table("./train/subject_train.txt", header = FALSE)
subject_test <- read.table("./test/subject_test.txt", header = FALSE)
features <- read.table("./features.txt", header = FALSE)
activity_labels <- read.table("./activity_labels.txt", header = FALSE)

#Merge data together--------------------------------------------------------------------

#Add column headers (feature type), activity type, & Subject ID to test data 
all_test <- x_test
colnames(all_test) <- features$V2
all_test$data_type <- "test data"
all_test$subject_id <- subject_test$V1
all_test$activity_type <- ifelse(y_test$V1 == "1", "walking",
                                 ifelse(y_test$V1 == "2", "walking_upstairs",
                                        ifelse(y_test$V1 == "3", "walking_downstairs",
                                               ifelse(y_test$V1 == "4", "sitting",
                                                      ifelse(y_test$V1 == "5", "standing", "laying")))))

#Add activity type and subject id to train data
all_train <- x_train
colnames(all_train) <- features$V2
all_train$data_type <- "train data"
all_train$subject_id <- subject_train$V1
all_train$activity_type <- ifelse(y_train$V1 == "1", "walking",
                                 ifelse(y_train$V1 == "2", "walking_upstairs",
                                        ifelse(y_train$V1 == "3", "walking_downstairs",
                                               ifelse(y_train$V1 == "4", "sitting",
                                                      ifelse(y_train$V1 == "5", "standing", "laying")))))

#merge test & train data
all_data <- rbind(all_test, all_train)

#Extract Mean & St. Dev
mean_sd_data <- all_data[ , c(1:6, 562:564)] 

#Create new data set with the average of each variable for each activity and each subject
mean_sd_data <- mean_sd_data[c(-7)]
tidy_data <- aggregate(. ~subject_id + activity_type, mean_sd_data, mean)

#Write output data to file
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)
