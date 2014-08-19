## Code written for R 3.1.0 - Platform: x86_64-w64-mingw32/x64 (64-bit)
##
## See README.md for instructions on how scripts work
## See output TidyDataSet.txt for script output file
## See CodeBook.md for the CodeBook MarkDown file
##
## The following scripts perform transformations of 
## Human Activity Recognition Using Smartphones Data Set
## from UCI Machine Learning Repository
## described at link
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using
## +Smartphones
## downloaded from 
## https://d396qusza40orc.cloudfront.net/
## getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## List of transformations:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each
## measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. Creates a second, independent tidy data set with the average of each 
## variable for each activity and
## each subject.


## openDataFile function reads a file and puts its content 
## into a data_frame. If it does not exists simply returns FALSE
##
## Args:
##   filename: The File Name to be looked for
##   path: The path where file is supposed to be located
##   optcontainerfolder: (optional) a possible subpath under "path" where file
##                       could be (algorythm searches in path and if not found
##                       in optcontainerfolder/path)
## Returns:
##   file contents (data.frame) or NULL

openDataFile <- function(filename, path = "./", optcontainerfolder="") {
        msgstring <- paste0("Chasing \"",filename,"\" in \"",path,"\"")
        message(msgstring, appendLF = FALSE)
        completepath <- paste0(path, "/", filename)
        if(file.exists(completepath)) {
                message("...found!", appendLF = FALSE)
                message(" Import...", appendLF = FALSE)
                a <- read.table(completepath, header=FALSE)
                message("OK!")
                a
        } else if (optcontainerfolder != "") {
                message("...oops! Trying subpath... ")
                openDataFile(filename, paste0(optcontainerfolder,"/",path))
        } else {
                message(" ... not found!")
        } 
}

## capitaliseFirstLetters function reads a string and converts it
## into a cleaned string with Capital letters for each word
## (words in original string are expected to be separated by '_')
## Args:
##   x: The original string, e.g. "my_original_string"
##
## Returns:
##   the cleaned and properly cased string, e.g. "myOriginalString"

capitaliseFirstLetters <- function(x) {
        s <- strsplit(x, "_")[[1]]
        paste(toupper(substring(s, 1, 1)), tolower(substring(s, 2)),
              sep = "", collapse = " ")
}


## Here operational code starts, which calls other functions

## Operation 0: Load files
## Loading files passing to the function an optional subfolder
## "UCI HAR Dataset/" just in case user decompressed them with 
## the container directory. If not, loading files under ./

message("-------- 0 - FILES IMPORT -------------")
## Load Test Files
XTestFile <- openDataFile("X_test.txt","test", "UCI HAR Dataset")
YTestFile <- openDataFile("y_test.txt","test", "UCI HAR Dataset")
SbjTestFile <- openDataFile("subject_test.txt","test", "UCI HAR Dataset")

## Load Train Files
XTrainFile <- openDataFile("X_train.txt","train", "UCI HAR Dataset")
YTrainFile <- openDataFile("y_train.txt","train", "UCI HAR Dataset")
SbjTrainFile <- openDataFile("subject_train.txt","train", "UCI HAR Dataset")

## Load Transcod files
actlabelFile <- openDataFile("activity_labels.txt",".", "UCI HAR Dataset")
featuresFile <- openDataFile("features.txt",".", "UCI HAR Dataset")

## Check whether all files could be found
if (class(XTestFile) == "NULL" || class(YTestFile) == "NULL" ||
        class(SbjTestFile) == "NULL" || class(actlabelFile) == "NULL" ||
        class(featuresFile) == "NULL") {
        ## If not, then aborts with a KO message
        message("Some File not found in reasonable paths! Can't proceed")
} else  {
        ## If yes, then proceeds with the script
        message("All Files found... can proceed...")        

        ## Operation 1: merge test and training sets
        message("-------- 1 - MERGE DATASETS -------------")
        message("Merging the training and test datasets...", appendLF = FALSE)
        ## row-binding the Train and Test datasets
        TotalXFile <- rbind(XTrainFile, XTestFile)
        TotalYFile <- rbind(YTrainFile, YTestFile)
        TotalSbjFile <- rbind(SbjTrainFile, SbjTestFile)
        message(" complete!")
                
        ## Operation 2: taking the average of each column
        message("-------- 2 - EXTRACT MEANS AND STD -------------")
        message("Extracting variables of interest only (mean, std) ...",
                appendLF = FALSE)
        ## taking the names of the features from the fetures file
        names(TotalXFile) = featuresFile[,2]
        ## Subsetting measure columns
        ## Below regular expression goes for uppercase and lowercase Mean and 
        ## Std words and also esplicitly excludes via [^Ff] the meanFreq() 
        ## measures
        SelectedXFile = TotalXFile[,grep("-[Mm]ean[^Ff]|-[Ss]td", 
                                         featuresFile[,2])]
        message(" complete!")

        ## Oper. 3: Uses descriptive analytics to name activities in Y dataset
        message("-------- 3 - NAME ACTIVITIES -------------")
        message("Decoding activities label via activities ID ...", 
                appendLF = FALSE)
        library("plyr")
        ## Converting activities desctiption from UPPERCASE to better format 
        ## through function capitaliseFirstLetters
        actlabelFile[,2]=sapply(as.character(actlabelFile[,2]),
                                capitaliseFirstLetters)
        ## doing the merge through Join function which does not reorder data
        DecodedYFile <- join(TotalYFile,actlabelFile,type="left")
        message(" complete!")
        message("Merging measures,Activity Label and Subject columns...", 
                appendLF = FALSE)
        ## column-binding Subject, Activities and Measures values
        TotalFile <- cbind(TotalSbjFile,DecodedYFile[,2], SelectedXFile)
        message(" complete!")        

        ## Oper. 4: Appropriately label dataset with descriptive variable names
        message("-------- 4 - LABEL DATASET -------------")
        message("Applying column names transformations...", appendLF = FALSE)
        ## renaming subject and activity columns
        names(TotalFile)[1] <- "subject"
        names(TotalFile)[2] <- "activity"
        ## massively renaming other measure columns through gsub and regular
        ## expressions
        names(TotalFile) <- gsub("-","", names(TotalFile))
        names(TotalFile) <- gsub("\\(\\)","", names(TotalFile))
        ## Note, I prefer not to lowercase the words because names are very long
        ## and uppercasing initials helps readibility
        names(TotalFile) <- gsub("mean","Mean", names(TotalFile))
        names(TotalFile) <- gsub("std","Std", names(TotalFile))
        names(TotalFile) <- gsub("fBody","freqBody", names(TotalFile))
        names(TotalFile) <- gsub("tBody","timeBody", names(TotalFile))
        names(TotalFile) <- gsub("fGrav","freqGrav", names(TotalFile))
        names(TotalFile) <- gsub("tGrav","timeGrav", names(TotalFile))
        names(TotalFile) <- gsub("BodyBody","Body", names(TotalFile))
        message(" complete!")       
        
        ## NOTE: TotalFile is the original data merged, transformed and with
        ## Tidy names and format. Now proceeding to create a second dataset
        ## for summarisation
        
        ## Operation 5: Create second independant dataset with means of measures
        message("-------- 5 - CREATE MEANS DATASET -------------")
        message("Creating summarisation dataset with Means...", appendLF=FALSE)

        ## Using melt + dcast (seen in class lessons) to easily do mean of 
        ## measures
        library(reshape2)
        MeltFile <- melt(TotalFile, id=c("subject","activity"))
        TidyDataset <- dcast(MeltFile, subject + activity ~ variable, mean)
        ## doing some final renaming
        names(TidyDataset) <- gsub("time","meanOfTime", names(TidyDataset))
        names(TidyDataset) <- gsub("freq","meanOfFreq", names(TidyDataset))
        message(" complete!")        
        message(paste0("Writing file '",getwd(),"/TidyDataSet.txt' ..."), 
                appendLF = FALSE)
        write.table(TidyDataset,"./TidyDataSet.txt",sep = ",",row.names = FALSE)
        message(" complete!")        
}
