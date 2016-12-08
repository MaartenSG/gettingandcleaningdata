**CodeBook for the Getting and Cleaning Data course Project**

*Data:*

The dataset.zip contains mobility measurement data of 30 subjects who are divided in a training and a test set. 
Both training and test dataset contain files with:
- raw accelerometer data (in the Inertial signals folders)
- a processed dataset (X_train.txt and X_test.txt
- record labels for the activity (y_train.txt and y_test.txt)
- record labels for the subject (subject_train.txt and subject_test.txt)

In addition there are files with:
- description of the dataset and explanation of the variables.
- variable labels
- activity descriptions

*Project part 1: merge train and test sets*

I’ll use the processed datasets (X_*.txt) with the labels to generate a combined dataset.
See run.analysis.R for exact R code
- read datasets into R
- check number of records are the same in the train files and in the test files
- add a column ‘subset’ to keep the information if records come from train or test set
- combine the subject, activity and subset labels with the data as columns
- combine train and test by rows
- add column names (use features.txt)

*Project part 2: Extract mean and sd related measurements


