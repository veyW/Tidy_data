# download data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="z.zip")
unzip("z.zip")
#read files
train<- read.table("UCI HAR Dataset/train/X_train.txt")
test<-read.table("UCI HAR Dataset/test/X_test.txt")
train_labels<-read.table("UCI HAR Dataset/train/y_train.txt")
test_labels<-read.table("UCI HAR Dataset/test/y_test.txt")
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")
train_subj<-read.table("UCI HAR Dataset/train/subject_train.txt")
test_subj<-read.table("UCI HAR Dataset/test/subject_test.txt")

# merge test and trainin data
train_test<-rbind(train, test)
names(train_test)<-features$V2


# set meaningful features labels (variable names)
names(train_test)<-features$V2

# extract mean and standard deviation
indicator<-grepl(pattern="std()", names(train_test) ) | grepl(pattern="mean()", names(train_test) )
train_test<-train_test[,which(indicator)]

# set meaningful activity labels
train_test$activity<-c(train_labels$V1, test_labels$V1)
x<-character()
for ( i in 1:nrow(train_test)) {
  a<-train_test$activity[i]
  x<-c(x, as.character(activity$V2[a]))
}
train_test$activity<-x

# add subject information
train_test$subject<-c(train_subj$V1, test_subj$V1)

# calculate mean for every subject and activity
library(reshape2)
s_m<-melt(train_test, id=c("subject", "activity"))
tidy_dataset<-dcast(s_m, subject + activity ~ variable, mean, na.rm=T)
write.table(tidy_dataset, row.name=FALSE, file="tidy.txt")  
