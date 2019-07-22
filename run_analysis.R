# Assuming the data has been downloaded and extracted, this file
# will read the data, merge it, extract only relevant subsets, label it
# and finally provide a tidy-data set to run further analysis on.

# Loadingh training and testing data
setwd("C:\\Users/nb21033/Desktop/course2/UCI HAR Dataset/")

#Reading all the file and storing the variable names.
testing_data = read.csv("test/X_test.txt", sep="", header=F)
testing_data[,562] = read.csv("test/Y_test.txt", sep="", header=F)
#reading Subject data
testing_data[,563] = read.csv("test/subject_test.txt", sep="", header=F)


#testing data
training_data = read.csv("train/X_train.txt", sep="", header=F)
training_data[,562] = read.csv("train/Y_train.txt", sep="", header=F)

#testing subject data
training_data[,563] = read.csv("train/subject_train.txt", sep="", header=F)



# Loading activity labels
actvtylabels = read.csv("activity_labels.txt", sep="", header=F)

# Loading all features
features = read.csv("features.txt", sep="", header=FALSE)
#directly updating the columns..
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# binding the training data and the test sets to create one data set.
data = rbind(training_data, testing_data)

# this will get us the measurements on the mean and standard deviation.
cols <- grep(".*Mean.*|.*Std.*", features[,2])


features <- features[cols,]

# adding the last two columns (subject and activity)
cols <- c(cols, 562, 563)

# removing the unwanted columns from data
data <- data[,cols]

# Add the column names (features) to data

colnames(data) <- c(features$V2, "Activity", "Subject")
colnames(data) <- tolower(colnames(data))

currentActivity = 1
for (currentActivityLabel in actvtylabels$V2) {
    data$activity <- gsub(currentActivity, currentActivityLabel, data$activity)
    currentActivity <- currentActivity + 1
}

data$activity <- as.factor(data$activity)
data$subject <- as.factor(data$subject)

tidy_data = aggregate(data, by=list(activity = data$activity, subject=data$subject), mean)

# Remove the subject and activity column, since a mean of those has no use
tidy_data[,90] = NULL
tidy_data[,89] = NULL

# Write tidy_data
write.table(tidy_data, "tidy_data.txt", sep="\t", row.names=FALSE)
