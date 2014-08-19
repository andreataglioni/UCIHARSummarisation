                                                                                
                                                                                
###                SUMMARISATION OF UCI HUMAN ACTIVITY RECOGNITION 
###             USING SMATRPHONES DATA SET TO PRODUCE A TIDY DATA SET
###                           A COURSERA PROJECT ASSIGNMENT                          
                                --------- README FILE ---------                          
                                                                                
                                                                                
Released 2014 - August 25th Ver 1.0                       
                                                                                
                                                                                
                                                                                
                                                                                
##                                PRELIMINARY DESCRIPTION                        
                                                                                
                                                                                
              This work is aimed at 
              1. Producing a merged cleaned version of the original dataset
              2. Producing a Tidy Summarised dataset
              starting from the original UCI HAR Dataset on Smartphones.
              
              Please see all description related to the dataset and to the 
              transformations in the CodeBook.md file.
                            
              This README.md file is meant to describe how the R script 
              nemad run_analysis.R, contained in the present REPO works,
              which function does it contain, and how they are connected.
              By reading this readme file, the reader will be able to reproduce
              the analysis on the source data downloaded from UCI to get
              the output (summarised tidy dataset) in file "TidyDataSet.txt".
              
              This file has to be seen as a whole package together with
              - run_analysis.R --> the R script performing the transformations
              - CodeBook.md    --> the Code Book file describing variables and 
                                   transformaiton process
              
              Enjoy the reading! 
                                                                                             
                                                                                
##                                 HOW THE SCRIPT IS MADE                            
                                                                                
The script is written in: **R 3.1.0 - Platform: x86_64-w64-mingw32/x64 (64-bit)**
              
              The script is made up of three parts:
              
              1. Function openDataFile --> reads a file and puts its content 
              into a data_frame. If it does not exists simply returns FALSE
              This function is called to load all the 8 files which are needed
              to perform the processing.
              
              2. Function capitaliseFirstLetters --> reads a string and converts
              it into a cleaned string with Capital letters for each word
              (words in original string are expected to be separated by '_')
              E.g. inputing "my_original_string" the function returns 
              "myOriginalString"
              
              3. Script body not contained in a function, which performs all the 
              operational steps from the source files to the output file.
              
              NOTE: I decided not to structure more this script into more functions
              since I think this is a pretty operational and non reusable script, so
              I encapsulated into functions only the self-containing reusable logics
              to load files or to capitalise first letters.
              
              NOTE: each single step in the run_analysis.R is widely commented and 
              during execution user will be accompanied by a set of "messages" which 
              tell him at which phase the user is going through and the final result
              of the specific phase.
              
              In the appendix of this file, I attached a sample of a successful run
              and a sample of non successful run.
              
              
##                                 HOW TO RUN THE SCRIPT
              
              - Download the Original UCI data (input to this transformation) at:
               
              https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI
              %20HAR%20Dataset.zip 
              
              - The original data are downloaded in the form of a .zip package,
              and after downloading are supposed to be extracted in R working
              directory to let the script work. (you can extract them with
              or without the "UCI HAR Dataset" containing folder.
                                                                                
              - open run_analysis.R in R Studio

              - press "source" button on the whole R script 
               (by doing this R Studio loads functions and runs code)

              - Look at the spool messages in the R Studio console to see progress
              
              - In case of success (messages say complete to steps 1..5) you will
              find a file named "TidyDataSet.txt" in the R working directory (and 
              a data.frame named TidyDataSet in memory in R).


##                                 HOW THE SCRIPT IS MADE OF
##               (SOME TECHNICAL INSIGHT INTO FUNCITONS USED AND SCRIPT STEPS)

The R script BODY (i.e. all the code after the two functions), performs the following activities:

              0. Loads needed original files into memory by calling function "openDataFile". 
                 Files loaded: "X_test.txt", "y_test.txt", "subject_test.txt", 
                 "X_train.txt", "y_train.txt", "subject_train.txt", 
                 "activity_labels.txt", "features.txt"                 
                 In case one of these files can't be found script stops with a KO message.
                 In case all files loaded, proceeds with steps 1..5.
                 
              1. Merges Training and Test sets (X_ files, Y_ files and Subject_ files)
                 into one comprehensive set using the rbind() function.
                 
              2. Keeps only columns related with Mean and STD measures (66 cols) using
                 grep() function with a regular expression:
                                    "-[Mm]ean[^Ff]|-[Ss]td"
                 which stands for searching
                 * either a string "-mean" or "-Mean" not followed by a F or f
                 * or a string "-std" or "-Std"
                 
                 NOTE: we deliberately removed meanFreq() measure since analysis 
                 requirement explicitly asked for mean and std only.
                 In case for future use it is desired to keep also those columns, 
                 a simple change in GREP regular expression from "-[Mm]ean[^Ff]|-[Ss]td"
                 to "-[Mm]ean|-[Ss]td" needs to be  performed, but that would be
                 another package!
                 
              3. Decodes Activities in Y_ files through "activity_labels.txt" master data
                 file, converts UPPERCASE labels (e.g. WALKING_UPSTAIRS) into more
                 friendly labels (e.g. Wakling Upstairs) by applying the function 
                 capitaliseFirstLetters to all the activity_labels dataset through sapply(). 
                 
                 Then, merges the new cleaned activity labels with the activities file related
                 to the sample (Y_ file) through a join() function.
                 Finally column-merges activity data, selected X_ measures (from point 2) 
                 and "subject_" files (indicating the person subject to the measure) through
                 cbind().
              4. Performs through gsub() Column renaming to let them be more tidy and friendly.
                 This activity features:
                 - Elimination of "-"
                 - Elimination of "()"
                 - Uppercasing of 1st letter of measures (e.g. Mean instead of mean)
                 - Substitution of f and t prefix with more readable "freq" and "time"
                 - Typos Correction "Body" instead of "BodyBody"
                 This leads to a change from "tBodyAcc-mean()-X" to "timeBodyAccMeanX"
                 NOTE: at the end of this step a new merged Tidy dataset is produced in
                 variable "TotalFile" (class data.frame).
              5. Reshape the "TotalFile" dataset, summarising means of each of the 66 measures
                 and producing a new TidyDataset, through
                 - melt() by "subject" and "activity"
                 - dcast() applying to all variables function mean()
                 - some measure label renaming via gsub() 
                   (add prefix "meanOf" to each measure variable)
                 - spooling the data.frame to a new file "TidyDataSet.txt" in R working dir
                   with write.table() function.
                 
                               
FUNCTION "openDataFile"               
              
              As said, this function reads a file and puts its content 
              into a data_frame. If it does not exists simply returns FALSE

              Args:
              filename: The File Name to be looked for
              path: The path where file is supposed to be located
              optcontainerfolder: (optional) a possible subpath under "path" 
                                  where file could be (algorythm searches in
                                  path and if not found in optcontainerfolder/path)
              Returns: file contents (data.frame) or NULL
              
              This function has the only purpose of checking whether the file exists
              through the file.exists() function, and then to load it through 
              read.table().
              The peculiarity of this function is that it checks for the file in 
              a path (parameter) and if it does not exists in that path, makes a 
              second attempt in another path obtained prefixing a containing folder 
              (optcontainingfolder/path). I've done this since the Assignment didn't
              specify whether the user should decompress original data with or without
              the containing folder and I wanted the script to be flexible!


FUNCTION "capitaliseFirstLetters"               

              As said, this function converts input string putting them in lowercase
              with capital first letter for each word

              Args: x: The original string, e.g. "my_original_string"
              Returns: the cleaned and properly cased string, e.g. "myOriginalString"

							I used this function as I wanted to give a better aspect to Activity Labels
							and I found it on the internet already done, so why not leaving it intact?              
                                                                             
                                                                                
##                                EXAMPLE OUTPUT RUNS    

**A successful run should give a result similar to the following one:**

              > source('C:/Coursera/3-Getting and Cleaning Data/Course Project/run_analysis.R')
              -------- 0 - FILES IMPORT -------------
              Chasing "X_test.txt" in "test"...oops! Trying subpath... 
              Chasing "X_test.txt" in "UCI HAR Dataset/test"...found! Import...OK!
              Chasing "y_test.txt" in "test"...oops! Trying subpath... 
              Chasing "y_test.txt" in "UCI HAR Dataset/test"...found! Import...OK!
              Chasing "subject_test.txt" in "test"...oops! Trying subpath... 
              Chasing "subject_test.txt" in "UCI HAR Dataset/test"...found! Import...OK!
              Chasing "X_train.txt" in "train"...oops! Trying subpath... 
              Chasing "X_train.txt" in "UCI HAR Dataset/train"...found! Import...OK!
              Chasing "y_train.txt" in "train"...oops! Trying subpath... 
              Chasing "y_train.txt" in "UCI HAR Dataset/train"...found! Import...OK!
              Chasing "subject_train.txt" in "train"...oops! Trying subpath... 
              Chasing "subject_train.txt" in "UCI HAR Dataset/train"...found! Import...OK!
              Chasing "activity_labels.txt" in "."...oops! Trying subpath... 
              Chasing "activity_labels.txt" in "UCI HAR Dataset/."...found! Import...OK!
              Chasing "features.txt" in "."...oops! Trying subpath... 
              Chasing "features.txt" in "UCI HAR Dataset/."...found! Import...OK!
              All Files found... can proceed...
              -------- 1 - MERGE DATASETS -------------
              Merging the training and test datasets... complete!
              -------- 2 - EXTRACT MEANS AND STD -------------
              Extracting variables of interest only (mean, std) ... complete!
              -------- 3 - NAME ACTIVITIES -------------
              Decoding activities label via activities ID ...Joining by: V1 complete!
              Merging measures,Activity Label and Subject columns... complete!
              -------- 4 - LABEL DATASET -------------
              Applying column names transformations... complete!
              -------- 5 - CREATE MEANS DATASET -------------
              Creating summarisation dataset with Means... complete!
              Writing file 'C:/Coursera/3-Getting and Cleaning Data/Course Project/TidyDataSet.txt' ... complete!
              > 
              
              
**An unsuccessful run should give a result similar to the following one:**

              
              > source('C:/Progetti/_Big Data/Coursera/3-Getting and Cleaning Data/Course Project/run_analysis.R')
              -------- 0 - FILES IMPORT -------------
              Chasing "X_test.txt" in "test"...oops! Trying subpath... 
              Chasing "X_test.txt" in "UCI HAR Dataset/test" ... not found!
              Chasing "y_test.txt" in "test"...oops! Trying subpath... 
              Chasing "y_test.txt" in "UCI HAR Dataset/test" ... not found!
              Chasing "subject_test.txt" in "test"...oops! Trying subpath... 
              Chasing "subject_test.txt" in "UCI HAR Dataset/test" ... not found!
              Chasing "X_train.txt" in "train"...oops! Trying subpath... 
              Chasing "X_train.txt" in "UCI HAR Dataset/train" ... not found!
              Chasing "y_train.txt" in "train"...oops! Trying subpath... 
              Chasing "y_train.txt" in "UCI HAR Dataset/train" ... not found!
              Chasing "subject_train.txt" in "train"...oops! Trying subpath... 
              Chasing "subject_train.txt" in "UCI HAR Dataset/train" ... not found!
              Chasing "activity_labels.txt" in "."...oops! Trying subpath... 
              Chasing "activity_labels.txt" in "UCI HAR Dataset/." ... not found!
              Chasing "features.txt" in "."...oops! Trying subpath... 
              Chasing "features.txt" in "UCI HAR Dataset/." ... not found!
              Some File not found in reasonable paths! Can't proceed
              >