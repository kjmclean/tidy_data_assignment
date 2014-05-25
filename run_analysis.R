library(dplyr)
library(reshape2)
library(magrittr)
library(data.table)
#load test dataframe ("X_test.txt"), add activity ("y_test.txt") and subject 
#("subject_test.txt") columns to dataframe.
setwd("UCI HAR Dataset/test/")
X_test_df            <- read.table("X_test.txt")
y_test_df            <- read.table("y_test.txt")
names(y_test_df)     <- c("activity")
y_test_df[,1]        <- as.character(y_test_df[,1])
subj_test_df         <- read.table("subject_test.txt")
names(subj_test_df)  <- c("subject")
XY_test_df           <- cbind(y_test_df, X_test_df)
XYsub_test_df        <- cbind(subj_test_df, XY_test_df)

#load train dataframe ("X_train.txt"), add activity ("y_train.txt") and subject 
#("subject_train.txt") columns to dataframe.
setwd("../train/")
X_train_df           <- read.table("X_train.txt")
y_train_df           <- read.table("y_train.txt")
names(y_train_df)    <- c("activity")
y_train_df[,1]       <- as.character(y_train_df[,1])
subj_train_df        <- read.table("subject_train.txt")
names(subj_train_df) <- c("subject")
XY_train_df          <- cbind(y_train_df, X_train_df)
XYsub_train_df       <- cbind(subj_train_df, XY_train_df)

#combine test and train data into single large dataframe
large_df     <- rbind(XYsub_test_df, XYsub_train_df)

#rename "activity" levels with descriptive names
large_df[,2] <- gsub("1", "walking", large_df[,2])
large_df[,2] <- gsub("2", "upstairs", large_df[,2])
large_df[,2] <- gsub("3", "downstairs", large_df[,2])
large_df[,2] <- gsub("4", "sitting", large_df[,2])
large_df[,2] <- gsub("5", "standing", large_df[,2])
large_df[,2] <- gsub("6", "laying", large_df[,2])

#add the "features" data as column names to the large data set
setwd("../")
col_labels      <- read.table("features.txt") 
col_labels      <- as.character(col_labels[,2]) 
col_labels      <- gsub("[\\(\\)]", "", col_labels) #remove parentheses from feature names 
col_labels      <- append(c("subject", "activity"), col_labels )
names(large_df) <- col_labels

#rename "meanFreq" feature to "mFreq" so it is not grep'd along with "mean" and "std" columns
mod_col_labels  <- gsub("meanFreq", "mFreq", col_labels)
#define a subset of col_labels vector that contains only those features containing
#the regex "mean" or "std".
sub_labels      <- subset(mod_col_labels, grepl("mean", mod_col_labels) | grepl("std", mod_col_labels))
all_sub_labels  <- append(c("subject", "activity"), sub_labels)
#subset large_df using the only "subject", "activity", and all "mean" and "std" columns 
sub_df          <- large_df[, all_sub_labels]

#sub_df "melted" into a 'long' tidy datatable "dt_melted"
melted_sub_df     <- melt(sub_df, id = c("subject", "activity"))
dt_melted         <- data.table(melted_sub_df)
setnames(dt_melted, "variable", "feature")
dt_melted$subject <- as.character(dt_melted$subject)
dt_melted         <- dt_melted[order(subject, activity, feature)]

#create a "tidy" dataset consisting of a mean signal value for each subject/activity/feature
#combination. This reduces the dataset from 679734 rows down to 11880 rows (30 subjects x 
# 6 activity levels x 66 feature levels = 11880 means)
subj_act_feature_means <-
                        dt_melted %>% group_by(subject, activity, feature) %>%
                             summarise(mean(value))

setnames(subj_act_feature_means, c("subject", "activity", "feature", "mean(value)"),
         c("subject", "activity", "feature", "signal"))

#write "tidy dataset" dataframe as a csv file in the working directory
write.csv(subj_act_feature_means, "../tidy_dataset.csv", row.names = FALSE)

