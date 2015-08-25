The following document outlines the general structure and requirements of the code to create the first-, second-, and total-order sensitivity indices plots. Please lok at LICENSE.md and README.md before using the code. Functions in the scripts should have the inputs defined in the comments on the same line. The outline of the code follows the script 'radialConvergeTest.R'.

Step 0: Writing Sensitivity Analysis Output

The script 'exampleFunctions.py' shows a basic example of how the results from a sensitivity analysis in Python performed using the SALib package (https://github.com/SALib/SALib) can be written to *.csv files. For a sensitivity analysis the key files are: summary of variables names, first- and total-order indices, and confidence of the indices; second-order indices in an upper triangular matrix form; and confidence of the second-order indices in an upper triangular matrix.

The sensitivity analysis must be written from Python so that R can read-in the files. I developed the code in R because I was more familar with R plots than Python plots, but I am currently working on a Python version of the function. Although it is a little troublesome, it does force you to save the output of your sensitivity analysis. Also, any sensitivity analysis formatted in the same way can be read-in to the R function, regardless of the software package used to generate the output.

Step 1: Reading-in Data

The first step is reading-in the data from a sensitivity analysis to R. The format for the sensitivity analysis output is based on the Python SALib package (https://github.com/SALib/SALib). This output is read-in to R as three variables, one for each file (described above). The one that contains the first- and total-order indices, names, etc., is the primary one used when creating the plots.

Step 2: Define Significance

If there are many variables it is probably best to plot only the "significant" ones (see scripts in 'sigTests.R'). There are two main methods of defining significance: sensitivity index is statistically greater than zero or the sensitivity index is above a threshold value. Testing if the sensitivity index is statistically greater than zero requires a confidence interval on the index. Defining significance as greater than a threshold allows selecting variables that had a total-order index greater than 0.01, for example.

You can manually define which indices are significant by adding a column 'sig' to the data frame with the first- and total-order indices. For instance, you could want variables that are statistically significant and greater than 0.01, which would take the output of the two main types of criteria to define significance.

Step 3: Grouping Variables

In the final plot the variables are assigned to groups. In the code each group must have a group name, a list of variables in the group (there are no checks for one variable being assigned to each group), and a group color. The function in 'groupAssign.R' takes the input data frame with first- and total-order indices and adds columns for the group name and the group color. These assignments of colors and names will be used in plotting.

Step 4: Plotting

The sensitivity analysis plots are done using the function in 'plotRadSAinds.R'. There are many graphical parameters, but the main ones are to control the dimensions of the plot and the relative size of the points. If the points look too bunched together then increase 'radSc' or decrease 'scaling'. There are options for automatically saving a *.eps file or displaying the results to the screen. I have plans to include more types of output images.

One important note is that the plot draws circles and rectangles, not lines and points. Use of circles and rectangles means that scaling should be exact compared to using lines and points.

The default value used when determining the relative size (width) of the circles and rectangles is based on the square root of the sensitivity index. The square root is used because circles are viewed as area, so if the total order index is twice the first-order the outside circle should have an area that is twice the inside circle (radius of outside is a factor of \sqrt{2} larger). This same scaling is preserved in the rectangle widths. If you want to change this to linear scaling (width proportional to the index) then change 'widthSc' to 1.
