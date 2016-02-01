##Download Files##
allfiles<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(allfiles, destfile="allfiles.zip", method="curl")
##Unzip Files##
unzip("allfiles.zip", exdir = "./")
setwd(paste(getwd(),"/UCI HAR Dataset",sep=""))
##Assign and Read Files##
variablenames=read.table("features.txt")
xtest=read.table("test/X_test.txt")
ytest=read.table("test/y_test.txt")
subtest=read.table("test/subject_test.txt")
xtrain=read.table("train/X_train.txt")
ytrain=read.table("train/y_train.txt")
subtrain=read.table("train/subject_train.txt")
activities=read.table("activity_labels.txt")
##Add Column Names to Data Sets##
tvariablenames<-t(variablenames)
tvariablenames2<-tvariablenames[-1,]
colnames(xtest)<-tvariablenames2
colnames(xtrain)<-tvariablenames2
##Part 1: Merge Test Set##
testdata<-cbind(subtest,ytest,xtest)
##Part 1: Merge Training Set##
traindata<-cbind(subtrain,ytrain,xtrain)
##Part 1: Merge Test Set and Training Set##
alldata<-rbind(testdata,traindata)
names(alldata)[1]<-"subject"
names(alldata)[2]<-"activity"
##Part 2: Remove all variables except mean and standard dev##
MeanStdData<-alldata[, grep("subject|activity|mean\\(\\)|std\\(\\)", colnames(alldata))]
##Part 3:Rename Acitivies from index to actual descriptive titles##
MeanStdData$activity[MeanStdData$activity == 1]<-"walking"
MeanStdData$activity[MeanStdData$activity == 2]<-"walking_upstairs"
MeanStdData$activity[MeanStdData$activity == 3]<-"walking_downstairs"
MeanStdData$activity[MeanStdData$activity == 4]<-"sitting"
MeanStdData$activity[MeanStdData$activity == 5]<-"standing"
MeanStdData$activity[MeanStdData$activity == 6]<-"laying"
##Part of Part 4 has already been done in lines 17-20##
##Part 4:Clean up column names##
colnames(MeanStdData)<-sub("*-"," ", colnames(MeanStdData))
colnames(MeanStdData)<-sub("^t","Time ", colnames(MeanStdData))
colnames(MeanStdData)<-sub("^f","Frequency ", colnames(MeanStdData))
colnames(MeanStdData)<-sub("\\(\\)","", colnames(MeanStdData))
colnames(MeanStdData)<-sub("* ","", colnames(MeanStdData))
colnames(MeanStdData)<-sub("* ","", colnames(MeanStdData))
##Part 5:Create new data set and find the average per each variable for each activity and each subject##
Meandata<-aggregate(MeanStdData[, 3:68], list(MeanStdData$subject,MeanStdData$activity), mean)
colnames(Meandata)[1]<-"Subject"
colnames(Meandata)[2]<-"Activity"
##View Data Set##
View(Meandata)
#Write Data Set##
write.table(Meandata, file="CleaningDataMeansFile.txt", row.names=FALSE)
