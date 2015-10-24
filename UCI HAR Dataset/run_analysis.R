#library
library(dplyr)

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('~/Dropbox/Coursera/1 Data Science Specialization/3 Get and Clean Data/UCI HAR Dataset');

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
extracted_variables <- X_total[, c(grep("mean", names(X_total)), grep("std", names(X_total)))] 

XNames <- names(extracted_variables)
for (i in 1:length(XNames)) 
{
  XNames[i] <- gsub("\\()","",XNames[i])
  XNames[i] <- gsub("-std$","StdDev",XNames[i])
  XNames[i] <- gsub("-mean","Mean",XNames[i])
  XNames[i] <- gsub("^(t)","time",XNames[i])
  XNames[i] <- gsub("^(f)","freq",XNames[i])
  XNames[i] <- gsub("([Gg]ravity)","Gravity",XNames[i])
  XNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",XNames[i])
  XNames[i] <- gsub("[Gg]yro","Gyro",XNames[i])
  XNames[i] <- gsub("AccMag","AccMagnitude",XNames[i])
  XNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",XNames[i])
  XNames[i] <- gsub("JerkMag","JerkMagnitude",XNames[i])
  XNames[i] <- gsub("GyroMag","GyroMagnitude",XNames[i])
  XNames[i] <- gsub("Acc","Acceleration",XNames[i]) 
};

#rename all with the new more descriptive names
names(extracted_variables) <- XNames

#combine all the variables into a bigger data set
Final_Data <- cbind(subject_total,y_total,extracted_variables)

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Summarizing the Final_Data table to include just the mean of each variable for each activity and each subject
Summary_group <- group_by(Final_Data,SubjectID,Activity) %>% summarise_each(funs(mean))

# Export the tidyData set 
write.table(Summary_group, './Summary_group.txt',row.names=FALSE,sep='\t')

