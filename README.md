Tidy Data Assignment
====================

ll data manipulations and processing steps are contained in a single, annotated R script accompanying this file names **"run_analysis.R"**.

The script is to be run from a working directory containing the unzipped **"UCI HAR Dataset"** folder. For the script to run properly, the "UCI HAR Dataset"" folder should be left exactly as provided by the authors.

Running this script requires the following four packages (and associated dependencies) in addition to base R:

1. dplyr
2. reshape2
3. data.table
4. magrittr

The script reads the UCI HAR Dataset, subsets and summarizes the data, and saves a comma-separated text file of the final 11880 row x 4 column dataframe as a file named **"tidy_dataset.csv"** in the working directory. 

Details of the UCI HAR Dataset and all data manipulations, as well as details of all the possible factor levels and descriptions of the final dataframe are provided in the accompanying **codebook.md** markdown file.
