# CodeBook for the Getting and Cleaning Data course Project

The course project goal is to tidy and process a messy dataset.
Tidy data principles as used in this project,
- One observation per row
- Each column represents a variable or measure or characteristic
- Each type of observational unit forms a table
- Column names are descriptive names of variables
- See Wickham’s pdf at http://vita.had.co.nz/papers/tidy-data.pdf


**The Data:**

The dataset.zip contains mobility measurement data of 30 subjects who are divided in a training and a test set. 
Both training and test dataset contain files with:
- raw accelerometer data (in the Inertial signals folders, not needed for the assignment)
- a processed dataset with measurement mean and standard deviation data (X_train.txt and X_test.txt)
- record labels for the activity within train and test (y_train.txt and y_test.txt)
- record labels for the subject within train and test (subject_train.txt and subject_test.txt)

In addition there are files with:
- description of the dataset (README.txt) 
- explanation of the variables (feature_info.txt) read this for a complete overview of the variables
- variable labels (feature.txt)
- activity descriptions (activity_labels.txt)

**Project step 1: merge the train and test sets**

I’ll use the processed datasets (X_*.txt) with the labels to generate a combined dataset.
See run.analysis.R for exact R code
- read datasets into R
- check number of records are the same in the files for train and in the files for test
- add a column ‘subset’ to keep the information if records come from train or test set. This is not important for this assignment but probably is important in future analysis.
- combine the subject, activity and subset labels with the measurement data originating from the X_*.txt files
- combine train and test data by rows as they should have the same number of columns
- add column names (use features.txt) and handle duplicate column names by adding the column number to the column names.

**Project step 2: Extract mean and sd related measurements**

Fairly straightforward, use the combined dataset and select the id columns and the columns with -mean and -std in their name
- use dplyr pipe structure with select to select the subject and activity id columns and the columns that match -mean or -std
- remove columns that contain meanFreq
- remove unwanted characters like - and ( and ) and trailing numbers from column names using gsub()
- bring into the dplyr data structure with tbl_df for easy printing

**Project step 3: Add activities descriptions to the dataset**

Use the activity descriptions in the activity_labels.txt file and match them to the activity_id in the dataset
- read activity_labels.txt and name columns
- left_join dataset with activity_labels using their common id
- optionally the columns can be reordered to move the new activity column next to activity_id column


**Project step 4: Add variable labels**

Already done during the previous project steps 1-3

**Project part 5: export a tidy dataset with the average variable for each activity and subject**

The dataset created in previous steps is still quite wide with 66 columns that describe measurements. There are several variable types which are still present in the variables. For example 3D directions (X, Y and Z) or domain (time, frequency) or sensor(acc, gyro) or signal (body, gravity). However, as not every column measurement has a time and a frequency domain for example, tidying up (using melt() or gather() would introduce lots of NA values. 

The only variable type that is complete (there is an observation for every variable) is calculation (mean, std). Every measurement has a mean and a std calculated. In theory this variable type could be split out into a ‘calculation’ column. However looking at the end result this would not be very helpful. In addition this appears not to be part of the assignment.

- use group_by on the dataset from step 4 to assign grouping on activity followed by subject
- use summarise_at to calculate the average (mean) of each variable for each activity and each subject
- then write the table to the project directory

- the R script contains example code of how to extract the calculation variable type and both the calculation and domain variable types from (a subset of) the dataset.



