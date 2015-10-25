# Getting-and-Cleaning-Data
repo for 3rd Data Science course

Robert Piazza 

2015-10-24

The script run_analysis grab the six test and train files as well as the informational files from the UCI Dataset.
First it binds row-wise the subjects, activity indicators and feature data. 
Then it takes the feature data and renames the variables with the names from the features file
Next it operates on the activity indicators and replaces the numbers witha activity labels
After this has been done, it column binds the three sets into the final data set.
Using the dplyr package, it splits the final data set by subject and activity then applies the mean function to each variable and puts it all back together again. 
It outputs this into the file Summary_group

