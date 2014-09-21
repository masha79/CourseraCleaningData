library(plyr)
library(dplyr)

## path to the data set, subfolders names, files names
data_path = "UCI HAR Dataset\\"
subfolders = c("test\\","train\\")

labels_names_file="activity_labels.txt"
features_names_file="features.txt"

subject_files=c("subject_test.txt","subject_train.txt")
labels_files=c("y_test.txt","y_train.txt")
metrics_files=c("X_test.txt","X_train.txt")

## read labels names, and metrics names
features_names <- read.table(paste(data_path,features_names_file,sep=""), header=FALSE,stringsAsFactors=FALSE)
labels_names <- read.table(paste(data_path,labels_names_file,sep=""), header=FALSE)
names(labels_names) <- c("ActivityCode", "Activity")

##read both test, and train files with data 
test_subjects <- read.table(paste(data_path,subfolders[1],subject_files[1],sep=""), header=FALSE)
test_labels   <- read.table(paste(data_path,subfolders[1],labels_files[1],sep=""), header=FALSE)
test_metrics  <- read.table(paste(data_path,subfolders[1],metrics_files[1],sep=""), header=FALSE)

train_subjects <- read.table(paste(data_path,subfolders[2],subject_files[2],sep=""), header=FALSE)
train_labels   <- read.table(paste(data_path,subfolders[2],labels_files[2],sep=""), header=FALSE)
train_metrics  <- read.table(paste(data_path,subfolders[2],metrics_files[2],sep=""), header=FALSE)

## combine both train, and test data into a single data frame
all_subjects <- rbind(test_subjects,train_subjects)
all_labels <- rbind(test_labels,train_labels)

##create a logical vector 'mean_std_metrics' indicating if a measurements name contains mean() or std() 
## use subsetting by logical vector mean_std_metrics to take only measurements of means, and std deviation
are_means <- grepl("mean()",features_names[,2],fixed=TRUE) 
are_std <- grepl("std()",features_names[,2],fixed=TRUE)
mean_std_metrics <- are_means | are_std
all_metrics <- rbind(test_metrics[,mean_std_metrics],train_metrics[,mean_std_metrics])

##additionally process metrics names to make them easier to read
features <- sapply( features_names[,2][mean_std_metrics], function(x) sub("-mean()"," MEAN",x,fixed=TRUE))
features <- sapply( features, function(x) sub("-std()"," STD",x,fixed=TRUE))
features <- sapply( features, function(x) sub("BodyBody","Body",x,fixed=TRUE))
features <- sapply( features, function(x) sub("-X"," X",x,fixed=TRUE))
features <- sapply( features, function(x) sub("-Y"," Y",x,fixed=TRUE))
features <- sapply( features, function(x) sub("-Z"," Z",x,fixed=TRUE))

#put names to all combined data frames
names(all_metrics) <- as.character(features)
names(all_subjects) <- c("Subject")
names(all_labels) <- c("ActivityCode")

#employing factor data type change activity labels into activity labels
all_labels <- merge(all_labels,labels_names,by="ActivityCode")
all_labels <- data.frame("Activity"=as.character(all_labels[["Activity"]]),stringsAsFactors=FALSE)
#add columns with subjects, and lables into the same common data set
all_metrics <- cbind(all_subjects,all_labels,all_metrics)

#now calculate means using dplyr library
grouped_metrics <- group_by(all_metrics,Subject,Activity)
grouped_means <- summarise_each(grouped_metrics,funs(mean))
final_result <- ungroup(grouped_means)
final_result <- final_result[order(final_result$Subject,final_result$Activity),]

write.table(final_result,file="tidy_data.txt", row.name=FALSE)
