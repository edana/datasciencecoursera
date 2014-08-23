#Read the data
filelist = list.files(path = c("./test","./train"), pattern = "*.txt", full.names = TRUE)
activity = read.table("activity_labels.txt")
features = read.table("features.txt")
subject_test = read.table(filelist[1])
X_test = read.table(filelist[2])
y_test = read.table(filelist[3])
subject_train = read.table(filelist[4])
X_train = read.table(filelist[5])
y_train = read.table(filelist[6])
colnames(X_test) = features$V2
colnames(X_train) = features$V2

#Merges the training and the test sets to create one data set.
all_test = cbind(X_test, subject = subject_test$V1, activity =  y_test$V1)
all_train = cbind(X_train, subject = subject_train$V1, activity = y_train$V1)
all_data <- rbind(all_test,all_train)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
newNames <- as.character(features$V2[grep("mean|std", features$V2)])
newNames <- c(newNames, "subject", "activity")
sel_data <- all_data[,newNames]

#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
names1 <- colnames(sel_data)
colnames(sel_data) <- gsub("\\(","", gsub("\\)", "", gsub("-","_",names1)))

#Creates a second, independent tidy data set with the average of each variable for each 
#activity and each subject.
install.packages("reshape")
library(reshape)
mean_data <- aggregate(sel_data[1:79], by = sel_data[c("subject","activity")], FUN = mean)
#Write the short format
out_data <- melt(mean_data, id = c("subject", "activity"))

#Write the output
write.table(out_data, file = "output.txt", row.name=FALSE)
