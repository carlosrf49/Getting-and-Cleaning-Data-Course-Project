#This code does the following:
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Install the required libraries
library("plyr")
library("data.table")

#Read the file with the variables for dataset
columnsnames<-read.table("./UCI HAR Dataset/features.txt",sep="")

#Read data set in test folder and apply column names
testset<-read.table("./UCI HAR Dataset/test/x_test.txt",sep="")
colnames(testset)<-columnsnames$V2

#Read data set in train folder and apply column names
trainset<-read.table("./UCI HAR Dataset/train/x_train.txt",sep="")
colnames(trainset)<-columnsnames$V2

#Merge data set in test and train folders
mergeset<-rbind(testset,trainset)

#Takes only the meassurement wanted and save it in new data frame
meassurementsWanted <- grep(".*mean.*|.*std.*", columnsnames[,2]) 
setmeassurementsWanted<-mergeset[,meassurementsWanted]

#Read activity labels and activities data in train and test folder
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",sep="")
testactivities<-read.table("./UCI HAR Dataset/test/y_test.txt",sep="")
trainactivities<-read.table("./UCI HAR Dataset/train/y_train.txt",sep="")

#Merge both activities data frames
mergeactivities<-rbind(testactivities,trainactivities)

#Assign activity labels to the data frame
activitieslabelledjoined<-join(mergeactivities,activity_labels)

#Read subject labels and subjects data in train and test folder
testsubject<-read.table("./UCI HAR Dataset/test/subject_test.txt",sep="")
trainsubject<-read.table("./UCI HAR Dataset/train/subject_train.txt",sep="")

#Merge both subject data frames
subjectmerge<-rbind(testsubject,trainsubject)

#Combine subject data fram, activity data frame and data sets
finalData<-cbind(subjectmerge,activitieslabelledjoined[,2],setmeassurementsWanted)

#Apply variable names
colnames(finalData)<-c("Subject","Activity Label",colnames(setmeassurementsWanted))

#Create new data table to calculate means
dataTable<-data.table(finalData)

#Calculate mean by Subject and Activities and save it into new data frame
summarizeAllData<-data.frame(dataTable[,lapply(.SD, mean, na.rm=TRUE), by=c("Activity Label","Subject") ])

#Create tidy data set
write.table(summarizeAllData, "tidy data set.txt", row.names = FALSE, quote = FALSE)