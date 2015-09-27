# Study Design
See the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) for details on the experiment and the data distributed. For our purposes this data is the "raw data".

# Code book

There are 180 observations (rows) of 66 variables (columns) in the tiny data set tiny_data.txt.

* The observations are all interactions (products) of 6 activities (walking, walking upstairs, walking downstairs, sitting, standing, laying) and 30 experimental subjects (1-30).
* The variables are means of raw data split over the two levels: activity and subject. The variables are normalized and bounded in the interval [-1, 1] so they are **dimensionless** and **without units**.

The raw data was transformed into the tidy data set as follows:

1. Three training sets were merged with three test sets with the same columns, that is, the data in X_train.txt with X_test.txt, Y_train.txt with Y_test.txt, and subject_train.txt with subject_test.txt. 
The resulting data sets were 10299 x 561, 10299 x 1, and 10299 x 1, respectively.
The three data sets, X, Y, and subject, each with 10299 rows, were merged into a data set 10299 x 563.
2. Only the desired columns of X were retained. These were numeric means and standard deviations of original time series and frequency domain data, a subset of the variables listed in features.txt. __Specifically, the variables selected were ones with both a mean and a corresponding standard deviation, not those additional variables referring to means.__ In other words, we retained the 66 variables whose names included the strings "mean()" and "std()".
3. The Y column contains integral data indicating a specific activity. Using the reference activity_labels.txt, these integers were converted to named strings as factor variables
4. The first 66 variable names (means and deviations) were slightly modified to be proper R names, namely dashes and parentheses were removed. The remaining 2 variables were named "activity" and "subject". The resulting properly labeled data set had 10299 rows and 68 columns.
5. Lastly, a tidy data set was created summarizing the data with average values of the 66 numeric variables. The averages were computed for all combinations of the 6 factors in "activity" and 30 factors in "subject", resulting in 180 averages of the 66 variables. The tidy data set is therefore 180 x 66 and stored in tiny_data.txt.