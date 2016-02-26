The following document outlines the general structure and requirements of the code to create the first-, second-, and total-order sensitivity indices plots. Please lok at LICENSE.md and README.md before using the code. Look at 'example1.pdf' and 'example2.pdf' to determine if this code will generate the type of plot that you want.

Functions in the scripts should have the inputs defined in the comments on the same line. The outline of the code follows the script 'radialConvergeTest.R'. I tried to heavily comment the code when necessary and make it approachable for users who have some familiarity with the plotting functions in R. If you have problems please check the example script and input files before contacting me or creating an issue.

Step 0: Writing Sensitivity Analysis Output
------

The script 'exampleFunctions.py' shows a basic example of how the results from a sensitivity analysis in Python performed using the SALib package (https://github.com/SALib/SALib) can be written to *.csv files. For a sensitivity analysis the key files are: summary of variables names, first- and total-order indices, and confidence of the indices; second-order indices in an upper triangular matrix form; and confidence of the second-order indices in an upper triangular matrix.

The sensitivity analysis must be written from Python so that R can read-in the files. I developed the code in R because I was more familar with R plots than Python plots, but I am currently working on a Python version of the function. Although it is a little troublesome, it does force you to save the output of your sensitivity analysis. Also, any sensitivity analysis formatted in the same way can be read-in to the R function, regardless of the software package used to generate the output.

# Step 1: Reading-in Data
------

The first step is reading-in the data from a sensitivity analysis to R. The format for the sensitivity analysis output is based on the Python SALib package (https://github.com/SALib/SALib). This output is read-in to R as three variables, one for each file (described above). The one that contains the first- and total-order indices, names, etc., is the primary one used when creating the plots.

# Step 2: Define Significance
------

If there are many variables it is probably best to plot only the "significant" ones (see scripts in 'sigTests.R'). There are two main methods of defining significance: sensitivity index is statistically greater than zero or the sensitivity index is above a threshold value. Testing if the sensitivity index is statistically greater than zero requires a confidence interval on the index. Defining significance as greater than a threshold allows selecting variables that had a total-order index greater than 0.01, for example.

You can manually define which indices are significant by adding a column 'sig' to the data frame with the first- and total-order indices. For instance, you could want variables that are statistically significant and greater than 0.01, which would take the output of the two main types of criteria to define significance.

#Step 3: Grouping Variables
------

In the final plot the variables are assigned to groups. In the code each group must have a group name, a list of variables in the group (there are no checks for one variable being assigned to each group), and a group color. The function in 'groupAssign.R' takes the input data frame with first- and total-order indices and adds columns for the group name and the group color. These assignments of colors and names will be used in plotting.

# Step 4: Plotting
------

The sensitivity analysis plots are done using the function in 'plotRadSAinds.R'. There are many graphical parameters, but the main ones are to control the dimensions of the plot and the relative size of the points. If the points look too bunched together then increase 'radSc' or decrease 'scaling'. There are options for automatically saving a *.eps file or displaying the results to the screen. I have plans to include more types of output images.

One important note is that the plot draws circles and rectangles, not lines and points. Use of circles and rectangles means that scaling should be exact compared to using lines and points.

The default value used when determining the relative size (width) of the circles and rectangles is based on the square root of the sensitivity index. The square root is used because circles are viewed as area, so if the total order index is twice the first-order the outside circle should have an area that is twice the inside circle (radius of outside is a factor of \sqrt{2} larger). This same scaling is preserved in the rectangle widths. If you want to change this to linear scaling (width proportional to the index) then change 'widthSc' to 1.

# Step 5: Feedback
------

If you find the funcions useful or have suggestions about how they can be improved, please let me know. I appreciate the beta testers who are willing to find ways for me to make the code more useful and user-friendly. If you have other functions that would be useful (formatting of sensitivity analysis from other packages into the desired format or fancy graphical effects) please let me know and I will add you as a collaborator.

## Detailed Function Documentation
------

`gp_name_col()`
------
Purpose: assign group information to all variables.

**_Inputs_**:

**name_list**: list with groups. The list is composed of group names with a vector of variables assigned to each. An example entry in the list would be `'group1' = c('x1','x2','x3')`, which would be interpreted as the group "group1" is composed of variables "x1", "x2", and "x3".

**col_list**: list of colors for each group. Entries should be of the form `'group1'='deepskyblue'`, which means that "group1" would be assigned a color of "deepskyblue".

**df**: data frame with the first- and total-order indices, and the name of the input varaibles.

**_Output_**:

**df**: input data frame with columns added for group name and group color.

`plotRadCon()`
------
Purpose: create radial convergence plot.

**_Inputs_**:

**df**: data frame that has already been processed through `gp_name_col()` and `stat_sig_s1st()`.

**s2**: second-order indices. An upper-triangular matrix. See example files.

**s2_sig**: second-order indices significance matrix. This is the result of running `stat_sig_s2()` on the second-order indices matrix.

**title**: title for the plot. Default is '' for no title.

**filename**: file name for the saved plot. Default `filename = 'plot'`. Do not include the file extension.

**plotType**: format for saving the plot. Default `plotType = 'EPS'`.

**plotS2**: should second-order indices be plotted (connecting lines). Default `plotS2 = TRUE'`.

**radSc**: radius scaling of plot. Default `radSc = 2`. Increasing `radSc` will increase the spacing between points.

**scaling**: scaling factor applied to individual circle and line sizes. Default `scaling = 1`. Increasing `scaling` will cause the points and lines to become wider, so closter together.

**widthSc**: power used when scaling the width of circles and lines. Default `widthSc = 0.5` for square root, so area of the circles is proportional to the index. If `widthSc = 1` then the diameter of the circules would be proportional to the index.

**STthick**: value used to assign thickness of the total-order sensitivity index circle. Default `STthick = 0.05`. Increasing `STthick` makes the  total-order index circles thicker.

**line_col**: color for the lines. Default `line_col = 'gray48'`.

**st_col**: color for the total-order index ring. Default `st_col = 'black'`.

**s1_col**: color for the first-order index circile. Default `s1_col = 'gray48'`.

**asp**: aspect ratio of the plot.

**varNameMult**: location of the variable name with respect to the radius of the plot. Default `varNameMult = 1.2`. Increasing the value will move the names farther away from the circles.

**gpNameMult**: location of the group name with respect to the radius of the plot. Default `gpNameMult = 1.6`. Increasing the value will move the names farther away from the circles.

**legLoc**: legend location. Default `legLoc = 'topleft'`. Other options are 'bottomright', 'bottomleft', and 'topright'.

**legPos**: legend relative position. Default `legPos = 1.9`.

`stat_sig_s1st()`

**_Output_**:

Plot of the first-, total-, and second-order indices for the variables that were determined to be "significant". The plot could be automatically saved to the current working directory.
------
Purpose: determine which inputs are significant for plotting based on first- and/or total-order indices.

**_Inputs_**:

**df**: data frame with first- and total-order indices. If `method='gtr'`, the confidence intervals for the first- and total-order indices are not needed. 

**greater**: used as threshold for evaluating significant indices when `method='gtr'`. Default `greater=0.01`, so all indices that are greater than 0.01 will be considered significant.

**method**: method for evaluating significance of indices. Default option is `method='sig'` for index must be statistically significant based on the confidence intervals. Other option is `method='gtr'` for index must be greater than a value to be significant.

**sigCri**: parameter for controling whether when a variable is significant for plotting. Default `sigCri='either'` so that if either the first- or total-order index is significant the variable will be plotted. If `sigCri='S1'` then only varibles with significant first-order indices will be plotted. If `sigCri='ST'` then only variables with significant total-order indices will be plotted. If `sigCri='both'` then both the first- and total-order indices must be significant for the variable to be plotted.

**_Output_**:

**df**: input data frame with columns added for significance of first-order, total-order, and plotting.

`stat_sig_s2()`
------

Purpose: determine which second-order indices are significant for plotting.

**_Inputs_**:

**dfs2**: matrix or data frame with the second-order indices. The matrix should be upper triangular. The entries should be in the same order as the first-order and total-order indices are listed.

**dfs2Conf**: matrix or data frame with the confidence interval second-order indices. The matrix should be upper triangular. The entries should be in the same order as the first-order and total-order indices are listed.

**greater**: used as threshold for evaluating significant indices when `method='gtr'`. Default `greater=0.01`, so all indices that are greater than 0.01 will be considered significant.

**method**: method for evaluating significance of indices. Default option is `method='sig'` for index must be statistically significant based on the confidence intervals. Other option is `method='gtr'` for index must be greater (absolute value greater) than a value to be significant.

**_Output_**:

**s2_sig**: matrix of 0's and 1's indicating which of the second-order indices are significant for plotting.
