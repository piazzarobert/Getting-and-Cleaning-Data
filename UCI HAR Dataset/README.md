# Getting-and-Cleaning-Data
repo for 3rd Data Science course

Robert Piazza 

2015-10-25

#load libraries

#set working directory to the location where the UCI HAR Dataset was unzipped

# Read in the data from files

#merge the train and test data for features on top of each other

#name the features appropriately

#do the same for the identifying data

#rename the variable so we can see what's being measured

#replace all activity indexes with activity labels by using the fact that the activity index can just point to the index in activity labels and pull the label out in one step

#merge the train and test data for subject identifier on top of each other

#name this variable

#pull out just the variables that matter to us, so only those with mean and standard deviation in their name are extracted

#name all the variables into something more descriptive and add a "_" for a separator to be used later.

#we will be splitting all into a tall data set so those measurements without Jerk or Magnitude need to be told they don't have it

#now a measurement is either along a specific axis or is a magnitude
#we're going to find all variables that don't have magnitude in their name and replace the location where magnitude would normally go and insert the axis

#rename all with the new more descriptive names

#combine all the variables into a bigger data set

#This is a little out of order but we'll use the wide dataset to creat the summary table before creating the tidy data
#Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Summarizing the data_tidy table to include just the mean of each variable for each activity and each subject

# Export the tidy_data set 

#turn into a long data set

#seperate into columns all the unique variables

#turn all the characters in the variables to factors

#we now have a tidy data set with all character as factors, each column as one variable and one unique observation per row

