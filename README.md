# Getting and Cleaning Data course Project
*By Maarten Sollewijn Gelpke*

The goal of this project is to prepare tidy data that can be used for later analysis.
The original dataset results from a mobility experiment where movements are measured using the accelerometer and gyroscope functionality from a mobile phone. Mobility is measured for 30 volunteers during 6 different activities.

The complete dataset was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and was unzipped and placed in an appropriate directory for local analysis.

This repo contains 4 files required for the assignment
- **CodeBook.md** contains the description of the data, the variables in the data and the data  processing steps. Processing of the mobility dataset to obtain the tidy dataset was done via the following steps:
..1. Merge the train and test sets
..2. Extract mean and sd related measurements
..3. Add activities descriptions to the dataset
..4. Add variable labels
..5. Export a tidy dataset with the variable average for each activity and subject combination
- **run_analysis.R** contains the actual R code which was used in the data processing
- **tidy_dataset.csv** is the resulting dataset. 
- **README.md** is the current readme file


