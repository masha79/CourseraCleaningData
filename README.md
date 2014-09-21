CourseraCleaningData
====================

######run_analysis.R

This script processes Human Activity Recognition Using Smartphones Data Set (1) 

Description of this data collection can be found here: 

  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data is downloaded from here:

  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
  
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012



######Prerequisites:

Downloaded archive is extracted to the script file location, and working sirectory is set to the source file location



######Scripts steps

1. Original data set archive is extracted into two subfolders - "test", and "train"
2. Scipts reads measurements files from both subfolders, and combines them into a single data set using rbind function
3. Activity labels, and subjects ids located under the same folders are also attached to the same data set
4. Only those mesurements that are means, and standard deviations are taken from the original data set - measurements names are checked to contain std() and mean()
5. factor data type is employed to transform activity labels to label names
6. 'dplyr' library's 'group_by', and 'summarise_each' functions are used to derive mean values of records aggregated by subject, and activity 