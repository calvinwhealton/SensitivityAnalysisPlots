The following document outlines the general structure and requirements of the code to create the first-, second-, and total-order sensitivity indices plots. Please look at LICENSE.md and README.md before using the code. Look at 'example1.pdf' and 'example2.pdf' to determine if this code will generate the type of plot that you want.

Functions in the scripts should have the inputs defined in the comments on the same line. The outline of the code follows the script 'radialConvergeTest.R'. I tried to heavily comment the code when necessary and make it approachable for users who have some familiarity with the plotting functions in R. If you have problems please check the example script and input files before contacting me or creating an issue.

Step 0: Libraries and Working Directories
-----
Make sure that the following libraries are installed.

`RColorBrewer` https://cran.r-project.org/web/packages/RColorBrewer/

`graphics` https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/00Index.html

`plotrix` https://cran.r-project.org/web/packages/plotrix/index.html

Also, the sensitivity analysis output should be in the same working directory as the code. Set the working directory to this location. This will be the location where the plots are saved. (Note: you can change the working directory in the code depending on whether you are loading the functions, data, or saving output.)

Step 1: Writing Sensitivity Analysis Output
------

The script 'exampleFunctions.py' shows a basic example of how the results from a sensitivity analysis in Python performed using the SALib package (https://github.com/SALib/SALib) can be written to *.csv files. For a sensitivity analysis the key files are: summary of variables names, first- and total-order indices, and confidence of the indices; second-order indices in an upper triangular matrix form, and confidence of the second-order indices in an upper triangular matrix.

The sensitivity analysis written in this form so that R can read-in the files. The example input is given in: "S1ST_output.csv", "S2_output.csv", "S2_conf_output.csv".

# Step 2: Reading-in Data
------

The first step is reading-in the data from a sensitivity analysis to R. The format for the sensitivity analysis output is based on the Python SALib package (https://github.com/SALib/SALib). This output is read-in to R as three variables, one for each file (described above). The one that contains the first- and total-order indices, names, etc., is the primary one used when creating the plots. There are two other matrices, one with the second-order indices and one with the confidence intervals for the second-order indices.

Example files are: "S1ST_output.csv", "S2_output.csv", "S2_conf_output.csv".

# Step 3: Defining Groups
------

Groups of variables need to be defined as a list in R. See the examples in the code.


# Step 4: Plot Results
------
The newest implementation of the code uses a single function call that determines which variables to plot and plots all of the variables. There are ~27 inputs to this function, but only four are required. The required inputs are the three data files read-in from the sensitivity analysis input and the list of group names.

A first set of optional inputs is related to the significance criteria. The points plotted can be based on whether the first- or total-order, or both first- and total-order indices are significant. The ways of evaluating the significance are based on confidence intervals for the index or being above a threshold. Similar options are available for assessing the second-order indices.

The next major set of inputs is related to the graphical output. There are several parameters that can be changed including colors, relative size of points, legend values, and output format. The plot draws circles and rectangles, not lines and points. Use of circles and rectangles means that scaling should be exact compared to using lines and points, which often have a minimum size.

The default value used when determining the relative size (width) of the circles and rectangles is based on the square root of the sensitivity index. The square root is used because circles are viewed as area, so if the total order index is twice the first-order the outside circle should have an area that is twice the inside circle (radius of outside is a factor of \sqrt{2} larger). This same scaling is preserved in the rectangle widths. If you want to change this to linear scaling (width proportional to the index) then change 'widthSc' to 1.

# Step 5: Feedback
------

If you find the funcions useful or have suggestions about how they can be improved, please let me know. I appreciate the beta testers who are willing to find ways for me to make the code more useful and user-friendly. If you have other functions that would be useful (formatting of sensitivity analysis from other packages into the desired format or fancy graphical effects) please let me know and I will add you as a collaborator.

## Detailed Function Documentation
------
`evalPlotIndsRadCon()`
------

**_Inputs_**:

**df**: data frame with the S1's, ST's, names of variables, and confidence intervals if using `s1stmeth = 'sig'`.

**dfs2**: data frame/matrix with S2 values in upper triangular form. Values are assumed in the same order as the S1's and ST's.

**dfs2Conf**: data frame/matrix with S2 confidence interval values in upper triangular form. Values are assumed in the same order as the S1'

**gpNameList**: list with groups. The list is composed of group names with a vector of variables assigned to each. An example entry in the list would be `'group1' = c('x1','x2','x3')`, which would be interpreted as the group "group1" is composed of variables "x1", "x2", and "x3".

**gpColList**: list of colors for each group. Default `col_list = NULL` implies that a Color Brewer palette will be used. User-specified entries should be of the form `'group1'='deepskyblue'`, which means that "group1" would be assigned a color of "deepskyblue".

**s1stgtr**: used as threshold for evaluating significant indices when `s1stmeth ='gtr'`. Default `s1stgtr=0.01`, so all indices that are greater than 0.01 will be considered significant.

**s1stmeth**: method for evaluating significance of indices. Default option is `s1stmeth='sig'` for index must be statistically significant based on the confidence intervals. Other option is `s1stmeth='gtr'` for index must be greater than a value to be significant.

**s1stsigCri**: parameter for controling whether when a variable is significant for plotting. Default `s1stsigCri='either'` so that if either the first- or total-order index is significant the variable will be plotted. If `s1stsigCri='S1'` then only varibles with significant first-order indices will be plotted. If `s1stsigCri='ST'` then only variables with significant total-order indices will be plotted. If `s1stsigCri='both'` then both the first- and total-order indices must be significant for the variable to be plotted.

**s2meth**: method for evaluating significance of indices. Default option is `s2meth ='sig'` for index must be statistically significant based on the confidence intervals. Other option is `s2meth ='gtr'` for index must be greater (absolute value greater) than a value to be significant.

**s2gtr**: used as threshold for evaluating significant indices when `s2gtr ='gtr'`. Default `s2gtr =0.01`, so all indices that are greater than 0.01 will be considered significant.

**ptTitle**: title for the plot. Default is `ptTitle = ''` for no title.

**ptFileNm**: file name for the saved plot. Default `ptFileNm = 'plot'`. Do not include the file extension.

**ptType**: format for saving the plot. Default `ptType = 'EPS'`. Other options include 'PNG' and 'PDF'.

**ptS2**: should second-order indices be plotted (connecting lines). Default `ptS2 = TRUE'`.

**ptRadSc**: radius scaling of plot. Default `ptRadSc = 2`. Increasing `ptRadSc` will increase the spacing between points.

**ptScCirc**: scaling factor applied to individual circle and line sizes. Default `ptScCirc = 1`. Increasing `ptScCirc` will cause the points and lines to become wider, so closter together.

**ptCircSc**: power used when scaling the width of circles and lines. Default `ptCircSc = 0.5` for square root, so area of the circles is proportional to the index. If `ptCircSc = 1` then the diameter of the circules would be proportional to the index.

**ptSTthick**: value used to assign thickness of the total-order sensitivity index circle. Default `ptSTthick = 0.05`. Increasing `ptSTthick` makes the  total-order index circles thicker.

**ptLineCol**: color for the lines. Default `ptLineCol = 'gray48'`.

**ptStcol**: color for the total-order index ring. Default `ptStcol = 'black'`.

**ptS1col**: color for the first-order index circile. Default `ptS1col = 'gray48'`.

**ptVarNmMult**: location of the variable name with respect to the radius of the plot. Default `ptVarNmMult = 1.2`. Increasing the value will move the names farther away from the circles.

**gpNmMult**: location of the group name with respect to the radius of the plot. Default `gpNmMult = 1.6`. Increasing the value will move the names farther away from the circles.

**ptLegLoc**: legend location. Default `ptLegLoc = 'topleft'`. Other options are 'bottomright', 'bottomleft', and 'topright'.

**ptLegPos**: legend relative position. Default `ptLegPos = 1.9`.

**ptRes**: resolution of the plot for .png files. Default `ptRes=100`. If getting errors about figure margins change this parameter.

**ptQual**: quality of the jpeg file in % of the original. Default `ptQual = 90`. Currently not used because jpegs not generated.


`gp_name_col()`
------
Purpose: assign group information to all variables.

**_Inputs_**:

**name_list**: list with groups. The list is composed of group names with a vector of variables assigned to each. An example entry in the list would be `'group1' = c('x1','x2','x3')`, which would be interpreted as the group "group1" is composed of variables "x1", "x2", and "x3".

**col_list**: list of colors for each group. Default `col_list = NULL` implies that a Color Brewer palette will be used. User-specified entries should be of the form `'group1'='deepskyblue'`, which means that "group1" would be assigned a color of "deepskyblue".

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

**plotType**: format for saving the plot. Default `plotType = 'EPS'`. Other options include 'PNG' and 'PDF'.

**plotS2**: should second-order indices be plotted (connecting lines). Default `plotS2 = TRUE'`.

**radSc**: radius scaling of plot. Default `radSc = 2`. Increasing `radSc` will increase the spacing between points.

**scaling**: scaling factor applied to individual circle and line sizes. Default `scaling = 1`. Increasing `scaling` will cause the points and lines to become wider, so closter together.

**widthSc**: power used when scaling the width of circles and lines. Default `widthSc = 0.5` for square root, so area of the circles is proportional to the index. If `widthSc = 1` then the diameter of the circules would be proportional to the index.

**STthick**: value used to assign thickness of the total-order sensitivity index circle. Default `STthick = 0.05`. Increasing `STthick` makes the  total-order index circles thicker.

**line_col**: color for the lines. Default `line_col = 'gray48'`.

**st_col**: color for the total-order index ring. Default `st_col = 'black'`.

**s1_col**: color for the first-order index circile. Default `s1_col = 'gray48'`.

**varNameMult**: location of the variable name with respect to the radius of the plot. Default `varNameMult = 1.2`. Increasing the value will move the names farther away from the circles.

**gpNameMult**: location of the group name with respect to the radius of the plot. Default `gpNameMult = 1.6`. Increasing the value will move the names farther away from the circles.

**legLoc**: legend location. Default `legLoc = 'topleft'`. Other options are 'bottomright', 'bottomleft', and 'topright'.

**legPos**: legend relative position. Default `legPos = 1.9`.

**res**: resolution of the plot for .png files. Default `res=100`. If getting errors about figure margins change this parameter.

**quality**: quality of the jpeg file in % of the original. Default `quality = 90`. Currently not used because jpegs not generated.

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
