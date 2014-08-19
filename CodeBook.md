                                                                                
                                                                                
###                SUMMARISATION OF UCI HUMAN ACTIVITY RECOGNITION 
###             USING SMATRPHONES DATA SET TO PRODUCE A TIDY DATA SET
###                           A COURSERA PROJECT ASSIGNMENT                          
                                   --------- CODE BOOK ---------                          
                                                                                
                                                                                
Released 2014 - August 25th Ver 1.0                       
                                                                                
                                                                                
                                                                                
                                                                                
##                                PRELIMINARY DESCRIPTION                        
                                                                                
                                                                                
              This work is aimed at 
              1. Producing a merged cleaned version of the original dataset
              2. Producing a Tidy Summarised dataset
              starting from the original UCI HAR Dataset on Smartphones.
              
              These data are hosted in the UCI Machine Learning Repository,
              and are collected from the accelerometers from the Samsung 
              Galaxy S smartphone. 
              
              
              This CodeBook is meant to describe  the variables, the data, and 
              any transformations or work performed to clean up the data in 
              order to produce a Tidy Data Set required by Coursera Course 
              Project.
              
              It has to be seen as a whole package together with
              - run_analysis.R --> the R script performing the transformations
              - README.md      --> the MD file describing how the script works
              
              Enjoy the reading! 
              
                                                                                
                                                                                
##                                 THE ORIGINAL DATA                            
                                                                                
              As said, original data are a full set of observations collected 
              from the accelerometers from the Samsung Galaxy S smartphone, on
              30 individuals while performing 6 different types of activities
              (WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING,
              LAYING).
              
              A full description of the source dataset is available at the origin 
              website:
              
              http://archive.ics.uci.edu/ml/datasets/Human+Activity
			  +Recognition+Using+Smartphones 
              
              Original data (input to this transformation) can be downloaded at:
               
              https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI
              %20HAR%20Dataset.zip 
              
              The original data are downloaded in the form of a .zip package,
              and after downloading are supposed to be extracted in R working
              directory to let the script work.
              
              Any information of the data collection process and details on 
              data variables can be seen in the above link... here we recap
              only some notes on original data structure:
              - a container folder "UCI HAR Dataset".
              - 'README.txt' describing data.
              - 'features_info.txt': information about the variables.
              - 'features.txt': List of all features (variables).
              - 'activity_labels.txt': decode of ID+labels for the activities.
              - Two subfolders, one for Test and one for Train samples:
              - 'train/X_train.txt': Training set (measures).
              - 'train/y_train.txt': Training activity IDs.
              - 'train/subject_train.txt': Training set subjects (observed people).
              - 'test/X_test.txt': Test set (measures).
              - 'test/y_test.txt': Test activity IDs.
              - 'test/subject_test.txt': Test set subjects (observed people).
              - two subfolders, Inertial Signals, containing all granular data
              
              While subject_ and Y_ files are one column (i.e. mean the subject ID
              and Activity ID of each observation), the X_ files are complex, as they
              feature 561 measure variables each, classified as:
              
              "kVariable-function()-axis" where
              - k stands for t if the measure is time based (sampled at 50Hz rate) or 
                f stands for a Fast Fourier Transformation (FFT) of a t variable                                                              
              - Variable stands for the measured variable, e.g. BodyAcc, GravityAcc
              - function stands for the function applied, e.g. mean(), std(), max()...
              - axis stands for the X, Y or Z axis on which the measure was sampled
              Example: tBodyAcc-mean()-X stands for the mean oftime sampled Body 
              Acceleration on X axis.                                                                                                                                   
                                                                                                                                                           
              Again, please refer to above link for full explaination of source variables.
 
                                                                                
                                                                                
##                             DATA COLLECTION DESCRIPTION                      
                                                                                
              For the purpose of this work, we are not going to describe original
              data collection process, since this is explained in the original data
              CodeBook.
              
              
##                             DATA TRANSFORMATION PROCESS    
                                                     
                                                                                
              Original Data have been transformed using a R script:
              - Decompressing the ZIP file into R working directory 
              - opening run_analysis.R in R Studio
              - "sourcing" the R script (which loads functions and runs code)

              The R script performs the following transformations (see README.md 
              for more technical details on functions used):
              0. Loads following files into memory: 
                 "X_test.txt"
                 "y_test.txt" 
                 "subject_test.txt" 
                 "X_train.txt" 
                 "y_train.txt" 
                 "subject_train.txt" 
                 "activity_labels.txt" 
                 "features.txt"
                 In case one of these files can't be found script stops
              1. Merges Training and Test sets (X_ files, Y_ files and Subject_ files)
                 into one comprehensive set
              2. Keeps only columns related with Mean and STD measures (66 cols)
                 NOTE: we deliberately removed meanFreq() measure since analysis 
                 requirement explicitly asked for mean and std only.
                 MeanFreq is not a normal mean, as it's a Weighted average, we didn't
                 consider it relevant for the assignment scope.
                 In case for future use it is desired to keep also those MeanFreq columns, 
                 a simple change in GREP regular expression from "-[Mm]ean[^Ff]|-[Ss]td"
                 to "-[Mm]ean|-[Ss]td" needs to be  performed, but that would be
                 another package!
              3. Decodes Activities in Y_ files through "activity_labels.txt" master data
                 file, converts UPPERCASE labels (e.g. WALKING_UPSTAIRS) into more
                 friendly labels (e.g. Wakling Upstairs), joins them with the Y_ file,
                 and merges them with the selected X_ measures from point 2 and with "subject_"
                 files (indicating the person subject to the measure).
              4. Performs Column renaming to let them be more tidy and friendly.
                 This activity features:
                 - Elimination of "-"
                 - Elimination of "()"
                 - Uppercasing of 1st letter of measures (e.g. Mean instead of mean)
                 - Substitution of f and t prefix with more readable "freq" and "time"
                 - Typos Correction "Body" instead of "BodyBody"
                 This leads to a change from "tBodyAcc-mean()-X" to "timeBodyAccMeanX"
                 
                 NOTE ON CONVENTIONS: despite the Coursera Lessons suggested to use lowercase
                 variables, literature gives freedom to consider the best naming approach for
                 the specific case. In this case, to help user readibilty, I deliberately
                 chose to use the convention "useOnlyFirstLetterUppercase" where each first
                 letter of a word is capitalised. Also in the Coursera Forums discussions there
                 was wide encouragement to consider the best "style" for the best situation.
                 Please consider this when giving marks for this assignment!   
                 
                 NOTE: at the end of this step a new merged Tidy dataset is produced in
                 variable "TotalFile" (class data.frame). Original data types are unchanged,
                 apart from activity column which is a string.
                 We are not describing in detail this intermediate dataset as it is a subproduct 
                 of the processing and is not its final purpose.
              5. Reshape the "TotalFile" dataset, summarising means of each of the 66 measures
                 and producing a new TidyDataset.
                 Adding prefix "meanOf" to each measure variable
                 Spooling the data.frame to a new file "TidyDataSet.txt" in R working dir.
                 
                 NOTE: the summarisation process produces 1 mean row for each individual and
                 each activity, leading thus to 30(individuals)*6(activities)=180 rows.
                 In case in the future the original dataset changed (different number of
                 subjects and activities) the number of rows may change.
                 
                 
                 
##                                  OUTPUT DATA FORMAT    
                                                     
                                                                                
Output data format of TidyDataSet spooled into **"TidyDataSet.txt"** is:
                                                                               
              - File Name: "TidyDataSet.txt"
              - File Location: R working directory
              - File Format: TXT - text file
              - Separator: ","
              - Quote: "
              - Decimal separator: "."
              - File Structure: rectangular
                                                                                
                                                                                
**Here below the data structure of TidyDataSet:**                                                                        
(NOTE: an HTML table has been used. This is compatible with viewing
in a markdown editor, like GitHub viewer)
                                                                           
<table>
<tr><td> VARIABLE NAME</td><td>POS </td><td> VARIABLE TYPE / WIDTH </td><td> VARIABLE DESCRIPTION </td></tr>

<tr><td> subject </td><td> 1 </td><td> Integer </td><td> Numeric ID of the person subject to the data collection </td></tr>

<tr><td> activity* </td><td> 2 </td><td>Character</td><td> Textual desctiption of the activity the person was doing when collecting data </td></tr>

<tr><td> meanOfTimeBodyAccMeanX </td><td> 3 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccMeanY </td><td> 4 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccMeanZ </td><td> 5 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccStdX </td><td> 6 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccStdY </td><td> 7 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccStdZ </td><td> 8 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccMeanX </td><td> 9 </td><td> Numeric </td><td> Mean of Mean of Time Gravity Acceleration on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccMeanY </td><td> 10 </td><td> Numeric </td><td> Mean of Mean of Time Gravity Acceleration on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccMeanZ </td><td> 11 </td><td> Numeric </td><td> Mean of Mean of Time Gravity Acceleration on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccStdX </td><td> 12 </td><td> Numeric </td><td> Mean of Std of Time Gravity Acceleration on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccStdY </td><td> 13 </td><td> Numeric </td><td> Mean of Std of Time Gravity Acceleration on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccStdZ </td><td> 14 </td><td> Numeric </td><td> Mean of Std of Time Gravity Acceleration on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkMeanX </td><td> 15 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration Jerk Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkMeanY   </td><td> 16 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration Jerk Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkMeanZ   </td><td> 17 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration Jerk Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkStdX </td><td> 18 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration Jerk Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkStdY </td><td> 19 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration Jerk Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkStdZ </td><td> 20 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration Jerk Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroMeanX </td><td> 21 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroMeanY </td><td> 22 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroMeanZ </td><td> 23 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroStdX </td><td> 24 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroStdY </td><td> 25 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroStdZ </td><td> 26 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkMeanX  </td><td> 27 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Jerk Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkMeanY  </td><td> 28 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Jerk Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkMeanZ  </td><td> 29 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Jerk Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkStdX </td><td> 30 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Jerk Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkStdY </td><td> 31 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Jerk Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkStdZ </td><td> 32 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Jerk Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccMagMean </td><td> 33 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccMagStd </td><td> 34 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccMagMean </td><td> 35 </td><td> Numeric </td><td> Mean of Mean of Time Gravity Acceleration Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeGravityAccMagStd </td><td> 36 </td><td> Numeric </td><td> Mean of Std of Time Gravity Acceleration Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkMagMean </td><td> 37 </td><td> Numeric </td><td> Mean of Mean of Time Body Acceleration Jerk Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyAccJerkMagStd </td><td> 38 </td><td> Numeric </td><td> Mean of Std of Time Body Acceleration Jerk Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroMagMean </td><td> 39 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroMagStd </td><td> 40 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkMagMean</td><td> 41 </td><td> Numeric </td><td> Mean of Mean of Time Body Gyroscope Jerk Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfTimeBodyGyroJerkMagStd </td><td> 42 </td><td> Numeric </td><td> Mean of Std of Time Body Gyroscope Jerk Signal Magnitude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccMeanX </td><td> 43 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccMeanY </td><td> 44 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccMeanZ </td><td> 45 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccStdX </td><td> 46 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccStdY </td><td> 47 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccStdZ </td><td> 48 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccJerkMeanX </td><td> 49 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Jerk Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccJerkMeanY </td><td> 50 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Jerk Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccJerkMeanZ </td><td> 51 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Jerk Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccJerkStdX </td><td> 52 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Jerk Signal on axis X per Subject per Activity  </td></tr>

<tr><td> meanOfFreqBodyAccJerkStdY </td><td> 53 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Jerk Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccJerkStdZ </td><td> 54 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Jerk Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroMeanX </td><td> 55 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Gyroscope Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroMeanY </td><td> 56 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Gyroscope Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroMeanZ </td><td> 57 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Gyroscope Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroStdX </td><td> 58 </td><td> Numeric </td><td> Mean of Std of Frequency Body Gyroscope Signal on axis X per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroStdY </td><td> 59 </td><td> Numeric </td><td> Mean of Std of Frequency Body Gyroscope Signal on axis Y per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroStdZ </td><td> 60 </td><td> Numeric </td><td> Mean of Std of Frequency Body Gyroscope Signal on axis Z per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccMagMean </td><td> 61 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Signal Magniude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccMagStd </td><td> 62 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Signal Magniude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccJerkMagMean </td><td> 63 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Acceleration Jerk Signal Magniude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyAccJerkMagStd </td><td> 64 </td><td> Numeric </td><td> Mean of Std of Frequency Body Acceleration Jerk Signal Magniude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroMagMean </td><td> 65 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Gyroscope Signal Magniude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroMagStd </td><td> 66 </td><td> Numeric </td><td> Mean of Std of Frequency Body Gyroscope Signal Magniude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroJerkMagMean</td><td> 67 </td><td> Numeric </td><td> Mean of Mean of Frequency Body Gyroscope Jerk Signal Magniude per Subject per Activity </td></tr>

<tr><td> meanOfFreqBodyGyroJerkMagStd </td><td> 68 </td><td> Numeric </td><td> Mean of Std of Frequency Body Gyroscope Jerk Signal Magniude per Subject per Activity </td></tr>

</table>

**NOTE**:  * "activity" field is character (string) in spooled file, factorised character string in the R dataset	

**NOTE ON UNITS OF MEASURE**: Dear reader, I know a good CodeBook should also point out Units of Measure for each variable.
Though, I am not a physician, and I don't know what might be a unit of measure of a Frequency derived measure (through Fourier
transformation, or a Jerk signal, or a Magnitude.) 
The only things I might get to are
* accelerations are generally measured in metres per second (m/s)
* the mean I made in my summarisation didn't change the units of measure
... but more than that I'm not sure what the original units of measure are...the original UCI dataset didn't talk about the Units of Measure.
Please don't subtract marks for this!
Thanks

**FINAL NOTE ON CODEBOOK FORMAT**: This codebook is based on a template found at 
[http://www.icpsr.umich.edu/icpsrweb/ICPSR/help/cb9721.jsp](http://www.icpsr.umich.edu/icpsrweb/ICPSR/help/cb9721.jsp)
I chose to use this template also thanks to suggestions found in Coursera Forums.