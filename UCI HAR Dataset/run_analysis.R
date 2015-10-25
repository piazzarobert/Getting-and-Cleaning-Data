#library
library(dplyr)
library(tidyr)

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('~/Dropbox/Coursera/1 Data Science Specialization/3 Get and Clean Data/Getting-and-Cleaning-Data/UCI HAR Dataset');

# Read in the data from files
x_test          <- read.table("./test/X_test.txt", header = FALSE)
y_test          <- read.table("./test/y_test.txt", header = FALSE)
subject_test    <- read.table("./test/subject_test.txt", header = FALSE)
x_train         <- read.table("./train/X_train.txt", header = FALSE)
y_train         <- read.table("./train/y_train.txt", header = FALSE)
subject_train   <- read.table("./train/subject_train.txt", header = FALSE)
features        <- read.table("./features.txt", stringsAsFactors = FALSE, header = FALSE)
activity_labels <- read.table("./activity_labels.txt", header = FALSE)

#merge the train and test data for features on top of each other
X_total <- rbind(x_train, x_test) 
rm(x_train, x_test)

#name the features appropriately
names(X_total) <- features[,2]

#do the same for the identifying data
y_total <- rbind(y_train, y_test) #merge the train and test data for activity labels on top of each other
rm(y_train, y_test)

#rename the variable so we can see what's being measured
names(y_total) <- "Activity" 

#replace all activity indexes with activity labels by using the fact that the activity index can just point to the index in activity labels and pull the label out in one step
y_total[, 1] <- activity_labels[y_total[,1],2] 

#merge the train and test data for subject identifier on top of each other
subject_total <- rbind(subject_train, subject_test) 

#name this variable
names(subject_total) <- "SubjectID" 

#pull out just the variables that matter to us, so only those with mean and standard deviation in their name are extracted
extracted_variables <- X_total[, grepl("(mean|std)\\(\\)", names(X_total))] 

XNames <- names(extracted_variables)
for (i in 1:length(XNames)) 
{
  XNames[i] <- gsub("\\()","",XNames[i])
  XNames[i] <- gsub("-","", XNames[i])
  XNames[i] <- gsub("^(t)","Time_",XNames[i])
  XNames[i] <- gsub("^(f)","Freq_",XNames[i])
  XNames[i] <- gsub("([Gg]ravity)","Gravity_",XNames[i])
  XNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body_",XNames[i])
  XNames[i] <- gsub("[Gg]yro","Gyro_",XNames[i])
  XNames[i] <- gsub("Mag","Magnitude_",XNames[i])
  XNames[i] <- gsub("Jerk","Jerk_",XNames[i])
  XNames[i] <- gsub("Acc","Acceleration_",XNames[i])
  XNames[i] <- gsub("std","StdDev",XNames[i])
  XNames[i] <- gsub("mean","Mean",XNames[i])
  
};

#we will be splitting all into a tall data set so those measurements without Jerk or Magnitude need to be told they don't have it
XNames[!grepl("Jerk", XNames)] <- gsub("Gyro_", "Gyro_NonJerk_", XNames[!grepl("Jerk", XNames)])
XNames[!grepl("Jerk", XNames)] <- gsub("Acceleration_", "Acceleration_NonJerk_", XNames[!grepl("Jerk", XNames)])

#now a measurement is either along a specific axis or is a magnitude
#we're going to find all variables that don't have magnitude in their name and replace the location where magnitude would normally go and insert the axis
for (i in 1:length(XNames)) 
{
    #if there's no magnitude in the name, we will do the operation
    if (!grepl("Magnitude",XNames[i]))
    {
    XNames[i] <- gsub("Jerk_", paste("Jerk_", substr(XNames[i],nchar(XNames[i]),nchar(XNames[i])),"_", sep = ""), XNames[i])  
    #now that we've inserted the axis variable, remove it from the end
    XNames[i] <- gsub("[XYZ]$","", XNames[i])
    }
}

#rename all with the new more descriptive names
names(extracted_variables) <- XNames

#combine all the variables into a bigger data set
wide_data <- cbind(Observation = row.names(extracted_variables), subject_total,y_total,extracted_variables)

#This is a little out of order but we'll use the wide dataset to creat the summary table before creating the tidy data
#Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Summarizing the data_tidy table to include just the mean of each variable for each activity and each subject
Summary_group <- group_by(wide_data[,2:69],SubjectID,Activity) %>% summarise_each(funs(mean))

# Export the tidyData set 
write.table(Summary_group, './Summary_group.txt',row.names=FALSE,sep='\t')

#turn into a long data set
long_data <- gather(data = wide_data, Measurement, Value, -Observation, -SubjectID, -Activity)

#seperate into columns all the unique variables
tidy_data <- separate(long_data, Measurement, into = c("Dimension", "Source", "Type", "Jerk", "Direction", "Measurement"), sep = "_", extra = "merge")

#turn all the characters in the variables to factors
for (i in 4:9) 
  {
  
  tidy_data[,i] <- as.factor(tidy_data[,i])
 
  }

#we now have a tidy data set with all character as factors, each column as one variable and one unique observation per row


