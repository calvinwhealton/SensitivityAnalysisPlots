# script to generate sensitivity plots
# with first- and total-order indices as circles
# and second-order indices as lines

# libraries----
library(RColorBrewer) # good color palettes
library(graphics)     # used when plotting polygons
library(plotrix)      # used when plotting circles

# setting working directory-----
setwd("/Users/calvinwhealton/GitHub/SensitivityAnalysisPlots")

# functions in other files
source('sigTests.R')
source('groupAssign.R')
source('plotRadSAinds.R')
source('evalPlotIndsRadCon.R')

#####################################################
# Example 1:
#   Single function call
#   Using significance criteria
#   Using minimum number of specified function arguments
#####################################################

## importing data from sensitivity analysis----
# see Python files for examples of how the input was saved to csv files

# importing first- and total-order indices with their confidence intervals
s1st_opt1 <- read.csv("S1ST_output.csv"
                     , sep=','
                     , header=TRUE
                     ,as.is=c(TRUE,rep(FALSE,4)))

# importing second-order indices with their confidence intervals
# both should be a k-by-k matrix with numbers in the upper triangular
# portion and nans elsewhere (k = number of parameters)
s2_opt1 <- read.csv("S2_output.csv"
                    , sep=','
                    , header=FALSE)

s2_conf_opt1 <- read.csv("S2_conf_output.csv"
                          , sep=','
                          , header=FALSE)

# defining lists of the variables for each group
name_list_opt1 <- list("group1" = c('x1', 'x4', 'x7', 'x8')
                       ,"group2" = c('x2', 'x3', 'x9')
                        ,"group3" = c('x5', 'x6', 'x10'))

## completing calculations of statistical significance
# and creating plot from single function call
# using all default values when possible
stst_opt1 <- evalPlotIndsRadCon(df=s1st_opt1                # data frame of S1 and ST indices (and confidence intervals if evaluating significance)
                                 ,dfs2=s2_opt1              # matrix/data frame of S2 indices
                                 ,dfs2Conf=s2_conf_opt1     # matrix/data frame of S2 indices confidence interval
                                 ,gpNameList=name_list_opt1 # list of variables names for each group
                                 )

#####################################################
# Example 2:
#   Single function call
#   Only plotting values greater than 0.02
#   Controlling output plot name and format (pdf, png)
#####################################################
## importing data from sensitivity analysis----
# see Python files for examples of how the input was saved to csv files

# importing first- and total-order indices with their confidence intervals
s1st_opt2 <- read.csv("S1ST_output.csv"
                      , sep=','
                      , header=TRUE
                      ,as.is=c(TRUE,rep(FALSE,4)))

# importing second-order indices with their confidence intervals
# both should be a k-by-k matrix with numbers in the upper triangular
# portion and nans elsewhere (k = number of parameters)
s2_opt2 <- read.csv("S2_output.csv"
                    , sep=','
                    , header=FALSE)

s2_conf_opt2 <- read.csv("S2_conf_output.csv"
                         , sep=','
                         , header=FALSE)

# defining lists of the variables for each group
name_list_opt2 <- list("group1" = c('x2', 'x4', 'x7', 'x10')
                       ,"group2" = c('x1', 'x5', 'x9')
                       ,"group3" = c('x3', 'x6', 'x8'))

## completing calculations of statistical significance
# and creating plot from single function call
# using all default values when possible
stst_opt2 <- evalPlotIndsRadCon(df=s1st_opt2               # data frame of S1 and ST indices (and confidence intervals if evaluating significance)
                                ,dfs2=s2_opt2              # matrix/data frame of S2 indices
                                ,dfs2Conf=s2_conf_opt2     # matrix/data frame of S2 indices confidence interval
                                ,gpNameList=name_list_opt2 # list of variables names for each group
                                ,s1stmeth='gtr'            # method for significance of S1 and ST
                                ,s1stgtr = 0.02            # threshold for significance of S1 and ST
                                ,s2meth = 'gtr'            # method for significance of S2
                                ,s2gtr = 0.02              # threshold for significance of S2
                                ,ptTitle = 'Example 2'     # title for plot
                                ,ptFileNm = 'exam2'        # name for file
                                ,ptType = 'PNG'            # type of file
                                ,ptRes=100                 # resolution for the plot
)

stst_opt2 <- evalPlotIndsRadCon(df=s1st_opt2               # data frame of S1 and ST indices (and confidence intervals if evaluating significance)
                                ,dfs2=s2_opt2              # matrix/data frame of S2 indices
                                ,dfs2Conf=s2_conf_opt2     # matrix/data frame of S2 indices confidence interval
                                ,gpNameList=name_list_opt2 # list of variables names for each group
                                ,s1stmeth='gtr'            # method for significance of S1 and ST
                                ,s1stgtr = 0.02            # threshold for significance of S1 and ST
                                ,s2meth = 'gtr'            # method for significance of S2
                                ,s2gtr = 0.02              # threshold for significance of S2
                                ,ptTitle = 'Example 2'     # title for plot
                                ,ptFileNm = 'exam2'        # name for file
                                ,ptType = 'PDF'            # type of file
)

stst_opt2 <- evalPlotIndsRadCon(df=s1st_opt2               # data frame of S1 and ST indices (and confidence intervals if evaluating significance)
                                ,dfs2=s2_opt2              # matrix/data frame of S2 indices
                                ,dfs2Conf=s2_conf_opt2     # matrix/data frame of S2 indices confidence interval
                                ,gpNameList=name_list_opt2 # list of variables names for each group
                                ,s1stmeth='gtr'            # method for significance of S1 and ST
                                ,s1stgtr = 0.02            # threshold for significance of S1 and ST
                                ,s2meth = 'gtr'            # method for significance of S2
                                ,s2gtr = 0.02              # threshold for significance of S2
                                ,ptTitle = 'Example 2'     # title for plot
                                ,ptFileNm = 'exam2'        # name for file
                                ,ptType = 'EPS'            # type of file
)


#####################################################
# Example 3:
#   Single function call
#   Plotting all values
#   Changing color scheme from default
#####################################################
## importing data from sensitivity analysis----
# see Python files for examples of how the input was saved to csv files

# importing first- and total-order indices with their confidence intervals
s1st_opt3 <- read.csv("S1ST_output.csv"
                      , sep=','
                      , header=TRUE
                      ,as.is=c(TRUE,rep(FALSE,4)))

# importing second-order indices with their confidence intervals
# both should be a k-by-k matrix with numbers in the upper triangular
# portion and nans elsewhere (k = number of parameters)
s2_opt3 <- read.csv("S2_output.csv"
                    , sep=','
                    , header=FALSE)

s2_conf_opt3 <- read.csv("S2_conf_output.csv"
                         , sep=','
                         , header=FALSE)

# defining lists of the variables for each group
name_list_opt3 <- list("group1" = c('x2', 'x4', 'x7', 'x10')
                       ,"group2" = c('x1', 'x5', 'x9')
                       ,"group3" = c('x3', 'x6', 'x8'))

# defining colors for the groups
color_list_opt3 <- list("group1"='deeppink'
                         ,"group2" = "goldenrod1"
                         ,"group3"="mediumvioletred")

## completing calculations of statistical significance
# and creating plot from single function call
# using all default values when possible
stst_opt2 <- evalPlotIndsRadCon(df=s1st_opt2                # data frame of S1 and ST indices (and confidence intervals if evaluating significance)
                                ,dfs2=s2_opt2               # matrix/data frame of S2 indices
                                ,dfs2Conf=s2_conf_opt2      # matrix/data frame of S2 indices confidence interval
                                ,gpNameList=name_list_opt2  # list of variables names for each group
                                ,gpColList =color_list_opt3 # color list
                                ,ptTitle = 'Example 3'      # title for plot
                                ,ptFileNm = 'exam3'         # name for file
                                ,ptType = 'EPS'             # type of file
                                ,ptRes=100                  # resolution for the plot
)
