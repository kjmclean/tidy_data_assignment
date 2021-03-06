# Codebook

## Background Information

Data were obtained from the "Human Activity Recognition Using Smartphones Data Set" generated by
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto at the Smart Lab Non Linear Complex Systems Laboratory in Genoa, Italy.  

The data were obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones on May 19th, 2014.

The data consists of measurements from a Samsung Galaxy S II smartphone's accelerometer and gyroscope worn on the waist of a subject while performing one of six activities (see below). 

Raw data were preprocessed by the Reyes-Ortiz *et. al.* in the following manner :

    "The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise
    filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128
    readings/window). The sensor acceleration signal, which has gravitational and body motion
    components, was separated using a Butterworth low-pass filter into body acceleration and
    gravity. The gravitational force is assumed to have only low frequency components,
    therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of
    features was obtained by calculating variables from the time and frequency domain."
    
The initial dataset consisted of 561 distinct "features" for each row of the dataset. Here,
this has been reduced down to only 66 features (for a given subject and activity), keeping only the summary statistics (mean and standard deviation) for each feature class. Furthermore, replciate measures (ie: distinct observations containing the same subject, activity, and feature categories) have been averaged into a single observation.

The resulting data set consists of 11880 observations each consisting of a unique subject x activity x feature combination. 
    

## Data Processing Details

All data manipulations and processing steps are contained in a single, annotated R script accompanying this file names "run_analysis.R".

The script is to be run from a working directory containing the unzipped **"UCI HAR Dataset"** folder. For the script to run properly, the "UCI HAR Dataset"" folder should be left exactly as provided by the authors.

Running this script requires the following four packages (and associated dependencies) in addition to base R:

1. dplyr
2. reshape2
3. data.table
4. magrittr

The script first reads the "test" dataset ("X_test.txt") into R as a dataframe. The (numeric) activity factor levels ("y_test.txt") are then read into R and bound as a column onto the "test" data. The subject encodings ("subject_test.txt") are then read into R and bound to dataset dataframe as another column. The result is a 2947 row x 563 column dataframe, consisting of a "subject" column, a "activity" column, and 561 unlabeled feature columns.

The exact same procedure is then applied to the "train" dataset, resulting in a 2947 row x 563 column dataframe with the same 563 columns as described above.

Since the **subject** factor levels do not overlap between the "test" and "train" data, the "train" dataframe is then appended to the "test" dataframe as rows, resulting in a long and wide dataframe named "large_df". The large_df dataframe has 10299 rows and the same 563 columns as detailed above.

At this point, the numeric levels of the **activity** column are replaced by descriptive names in the Reyes-Ortiz codebook using a gsub function (see **activity** below for level names). 

The 561 features columns remain unamed in large_df. The names of these columns were obtained from the "features.txt" in the UCI HAR Dataset file and read into R as a list of 561 elements named "col_labels". 

All parentheses were removed from these names using a gsub function as R does not allow parentheses in column names.

Two additional column labels, "subject" and "activity", were appended onto the "col_labels" list to serve as column names for the subject and activity columns of large_df. The col_labels list was then used to name all 563 columns of large_df.

Since our interest is only in the true mean and standard deviation summary columns of the dataset, the feature named "meanFreq" was renamed "mFreq" in in a new list called mod_col_labels.
The mod_col_labels list was then subsetted to contain only those column names containing the terms "mean" or "std" using a grep function, reducing the list length from 563 to 66 elements. The elements "subject" and "activity" were reappended to this list to make a list named "all_sub_labels" which contains the column names from all the columns of interest in the large_df dataframe.

The **all_sub_labels** list of column names was then used to subset the **large_df** dataframe to generate "sub_df", a 10299 row x 68 column dataframe, consisting of a **subject** column, an **activity** column, and 66 mean or standard deviation feature columns

To gerenate a tidy dataset, the wide sub_df (10299 x 68) dataframe was "melted" into a long  679734 row by 4 column datatable named **dt_melted**. The dt_melted datatable's 4 columns consist of a **subject** column, a **activity** column, a **feature** column (in which each of the 66 feature columns from sub_df have been converted into factor levels), and a **value** column which contains each numeric signal measurement.

The dplyr package was then used to generate a final tidy datatable by averaging all the replicate **subject** x **activity** x **feature** into mean values and saving the result in a datatable called **subj_act_feature_means**. The **subj_act_feature_means** datatable contains 11880 rows and 4 columns, representing the 11880 possible unique signal values for each of the possible **subject** x **activity** x **feature** combinations (30 x 6 x 66 = 11880).

The script saves a comma-separated text file of the final **subj_act_feature_means** datatable named **"tidy_dataset.csv"** in the working directory. 

Details of all the possible factor levels and descriptions are detailed below for the **tidy_dataset.csv** dataframe.

## Data Label Descriptions

The final data set (tidy_dataset.csv) is a dataframe enocded as a comma separated text file.

The dataset contains 4 columns: 

1.  **subject** - 30 factor levels (numbers are encoded as characters)
2.  **activity** - 6 factor levels
3.  **feature** - 66 factor levels
4.  **signal** - 11880 numeric values

The 11880 rows represent the 11880 possible unique combinations of the three factor variables
(30 x 6 x 66 = 11880).

Below are more detailed explanations of the factors and their respective levels.

### subject -- 30 levels
Numbers 1 through 30 represent one of thirty individuals from which the independent measurements were obtained. 

### activity -- 6 levels
The following six levels represent the activities the subject was performing when the 
signal measurements were recorded.

1.  **walking** ............measurements taken while walking
2.  **upstairs**............measurements taken while walking upstairs
3.  **downstairs**........measurements taken while walking downstairs
4.  **standing**...........measurements taken while standing still
5.  **sitting**...............measurements taken while sitting 
6.  **laying**...............measurements taken while laying down

### feature -- 66 levels

1.  **tBodyAcc-mean-X** ..........time domain mean X axial body acceleration accelerometer signal.     
2.	**tBodyAcc-mean-Y** ..........time domain mean Y axial body acceleration accelerometer signal.
3.	**tBodyAcc-mean-Z** ..........time domain mean Z axial body acceleration accelerometer signal.
4.	**tBodyAcc-std-X**  .............time domain X axial body acceleration accelerometer signal standard deviation.
5.	**tBodyAcc-std-Y**............. time domain Y axial body acceleration accelerometer signal standard deviation.
6.	**tBodyAcc-std-Z**............. time domain Z axial body acceleration accelerometer signal standard deviation. 
7.	**tGravityAcc-mean-X** ...... time domain mean X axial gravity accelerometer acceleration signal 
8.	**tGravityAcc-mean-Y**....... time domain mean X axial gravity accelerometer acceleration signal
9.	**tGravityAcc-mean-Z**....... time domain mean Y axial gravity accelerometer acceleration signal 
10.	**tGravityAcc-std-X**.......... time domain X axial gravity accelerometer acceleration signal standard deviation.  
11.	**tGravityAcc-std-Y**...........time domain Y axial gravity accelerometer acceleration signal standard deviation.
12.	**tGravityAcc-std-Z**...........time domain Z axial gravity accelerometer acceleration signal standard deviation. 
13.	**tBodyAccJerk-mean-X**....time domain mean X axial body accelerometer acceleration and angular velocity (Jerk)  
14.	**tBodyAccJerk-mean-Y**....time domain mean Y axial body accelerometer acceleration and angular velocity (Jerk) 
15.	**tBodyAccJerk-mean-Z**....time domain mean Z axial body accelerometer acceleration and angular velocity (Jerk) 
16.	**tBodyAccJerk-std-X**.......time domain X axial body accelerometer acceleration and angular velocity (Jerk) standard deviation  
17.	**tBodyAccJerk-std-Y**.......time domain Y axial body accelerometer acceleration and angular velocity (Jerk) standard deviation  
18.	**tBodyAccJerk-std-Z**........time domain Z axial body accelerometer acceleration and angular velocity (Jerk) standard deviation  
19.	**tBodyGyro-mean-X**..........time domain mean X axial body gyroscope acceleration signal  
20.	**tBodyGyro-mean-Y**..........time domain mean Y axial body gyroscope acceleration signal   
21.	**tBodyGyro-mean-Z**..........time domain mean Z axial body gyroscope acceleration signal   
22.	**tBodyGyro-std-X**..............time domain X axial body gyroscope acceleration signal standard deviation  
23.	**tBodyGyro-std-Y**..............time domain Y axial body gyroscope acceleration signal standard deviation  
24.	**tBodyGyro-std-Z**..............time domain Z axial body gyroscope acceleration signal standard deviation  
25.	**tBodyGyroJerk-mean-X**....time domain mean X axial body gyroscope acceleration and angular velocity (Jerk)  
26.	**tBodyGyroJerk-mean-Y**....time domain mean Y axial body gyroscope acceleration and angular velocity (Jerk)  
27.	**tBodyGyroJerk-mean-Z**....time domain mean Z axial body gyroscope acceleration and angular velocity (Jerk)  
28.	**tBodyGyroJerk-std-X**.......time domain X axial body gyroscope acceleration and angular velocity (Jerk) signal standard deviation
29.	**tBodyGyroJerk-std-Y**.......time domain Y axial body gyroscope acceleration and angular velocity (Jerk) signal standard deviation
30.	**tBodyGyroJerk-std-Z**.......time domain Z axial body gyroscope acceleration and angular velocity (Jerk) signal standard deviation  
31.	**tBodyAccMag-mean**........time domain mean axial magnitude body accelerometer signal  
32.	**tBodyAccMag-std**............time domain axial magnitude body accelerometer signal standard deviation 
33.	**tGravityAccMag-mean**......time domain mean axial magnitude gravity accelerometer acceleration signal
34.	**tGravityAccMag-std**.........time domain axial magnitude gravity accelerometer acceleration signal standard deviation
35.	**tBodyAccJerkMag-mean**....time domain mean body accelerometer acceleration and angular velocity (Jerk) signal
36.	**tBodyAccJerkMag-std**.......time domain body accelerometer acceleration and angular velocity (Jerk) signal standard deviation
37.	**tBodyGyroMag-mean**........time domain mean axial magnitude body gyroscope acceleration signal  
38.	**tBodyGyroMag-std**...........time domain axial magnitude body gyroscope acceleration signal standard deviation
39.	**tBodyGyroJerkMag-mean**...time domain mean axial magnitude body gyroscope acceleration and angular velocity (Jerk) signal 
40.	**tBodyGyroJerkMag-std**......time domain axial magnitude body gyroscope acceleration and angular velocity (Jerk) signal standard deviation
41.	**fBodyAcc-mean-X**.............frequency domain mean X axial body accelerometer acceleration signal
42.	**fBodyAcc-mean-Y**.............frequency domain mean Y axial body accelerometer acceleration signal
43.	**fBodyAcc-mean-Z**.............frequency domain mean Z axial body accelerometer acceleration signal  
44.	**fBodyAcc-std-X**................frequency domain X axial body accelerometer acceleration signal standard deviation 
45.	**fBodyAcc-std-Y**................frequency domain Y axial body accelerometer acceleration signal standard deviation  
46.	**fBodyAcc-std-Z**................frequency domain Z axial body accelerometer acceleration signal standard deviation  
47.	**fBodyAccJerk-mean-X**......frequency domain mean X axial body accelerometer acceleration and angular velocity (Jerk) signal 
48.	**fBodyAccJerk-mean-Y**......frequency domain mean Y axial body accelerometer acceleration and angular velocity (Jerk) signal  
49.	**fBodyAccJerk-mean-Z**......frequency domain mean Z axial body accelerometer acceleration and angular velocity (Jerk) signal  
50.	**fBodyAccJerk-std-X**.........frequency domain X axial body accelerometer acceleration and angular velocity (Jerk) signal standard deviation 
51.	**fBodyAccJerk-std-Y**.........frequency domain X axial body accelerometer acceleration and angular velocity (Jerk) signal standard deviation  
52.	**fBodyAccJerk-std-Z**.........frequency domain X axial body accelerometer acceleration and angular velocity (Jerk) signal standard deviation    
53.	**fBodyGyro-mean-X**...........frequency domain mean X axial body gyroscope acceleration signal  
54.	**fBodyGyro-mean-Y**...........frequency domain mean Y axial body gyroscope acceleration signal  
55.	**fBodyGyro-mean-Z**...........frequency domain mean Z axial body gyroscope acceleration signal  
56.	**fBodyGyro-std-X**..............frequency domain X axial body gyroscope acceleration signal standard deviation 
57.	**fBodyGyro-std-Y**..............frequency domain Y axial body gyroscope acceleration signal standard deviation  
58.	**fBodyGyro-std-Z**..............frequency domain Z axial body gyroscope acceleration signal standard deviation
59.	**fBodyAccMag-mean**.........frequency domain mean axial magnitude body accelerometer acceleration signal  
60.	**fBodyAccMag-std**............frequency domain axial magnitude body accelerometer acceleration signal standard deviation  
61.	**fBodyBodyAccJerkMag-mean**..........frequency domain mean axial magnitude body accelerometer acceleration and angular velocity (Jerk) signal  
62.	**fBodyBodyAccJerkMag-std**.............frequency domain axial magnitude body accelerometer acceleration and angular velocity (Jerk) signal standard deviation  
63.	**fBodyBodyGyroMag-mean**..............frequency domain mean axial magnitude body accelerometer and gyroscope acceleration signal 
64.	**fBodyBodyGyroMag-std**.................frequency domain axial magnitude body accelerometer and gyroscope acceleration signal standard deviation  
65.	**fBodyBodyGyroJerkMag-mean**.......frequency domain mean axial magnitude body accelerometer and gyroscope acceleration and angular velocity (Jerk) signal  
66.	**fBodyBodyGyroJerkMag-std**..........frequency domain axial magnitude body accelerometer and gyroscope acceleration and angular velocity (Jerk) standard deviation signal. 

### signal -- 11880 values

The signal values are numeric values ranging from -1.0 to 1.0 that represent the averaged feature measurements. The initial dataset contained 679734 signal values across 30 subjects, 
6 activity levels, and 66 feature levels, meaning that each signal value is a mean of approximately 57 initial measurements. 

