# script to generate sensitivity plots
# with first- and total-order indices as circles
# and second-order indices as lines

# libraries----
library(RColorBrewer) # good color palettes
library(graphics)     # used when plotting polygons
library(plotrix)      # used when plotting circles

# setting working directory-----
setwd("/Users/calvinwhealton/GitHub/SAPlots")

# functions in other files
source('sigTests.R')
source('groupAssign.R')
source('plotRadSAinds.R')

## importing data from sensitivity analysis----
# importing first- and total-order indices
s1st1 <- read.csv("S1ST_output.csv"
                   , sep=','
                   , header=TRUE
                   ,as.is=c(TRUE,rep(FALSE,4)))

s1st2 <- read.csv("S1ST_output.csv"
                  , sep=','
                  , header=TRUE
                  ,as.is=c(TRUE,rep(FALSE,4)))

# importing second-order indices
s21 <- read.csv("S2_output.csv"
                   , sep=','
                   , header=FALSE)
s22 <- read.csv("S2_output.csv"
                  , sep=','
                  , header=FALSE)
s2_conf1 <- read.csv("S2_conf_output.csv"
                   , sep=','
                   , header=FALSE)
s2_conf2 <- read.csv("S2_conf_output.csv"
                      , sep=','
                      , header=FALSE)

## determining which indices are statistically significant----
# S1 & ST: using the confidence intervals
s1st1 <- stat_sig_s1st(df=s1st1
                       ,method="sig"
                       ,sigCri='either')

# S1 & ST: using greater than a given value
s1st2 <- stat_sig_s1st(df=s1st2
                       ,method="gtr"
                       ,greater=0.01
                       ,sigCri='either')

# S2: using the confidence intervals
s2_sig1 <- stat_sig_s2(s21
                       ,s2_conf1
                       ,method='sig')

# S2: using greater than a given value
s2_sig2 <- stat_sig_s2(s22
                       ,s2_conf1
                       ,greater=0.01
                       ,method='gtr')

## defining groups for the variables and the color schemes----
# defining lists of the variables for each group
name_list1 <- list("group1" = c('x1', 'x4', 'x7', 'x8')
                   ,"group2" = c('x2', 'x3', 'x9')
                   ,"group3" = c('x5', 'x6', 'x10'))

name_list2 <- list("group1" = c('x2', 'x4', 'x7', 'x10')
                   ,"group2" = c('x1', 'x5', 'x9')
                   ,"group3" = c('x3', 'x6', 'x8'))

# defining color schemes
colScheme1 <- brewer.pal(length(names(name_list1)),'Set1')
colScheme2 <- c("lightcoral","deepskyblue","green3")

# defining list of colors for each group
col_list1 <- list("group1" = colScheme1[1]
                  ,"group2" = colScheme1[2]
                  ,"group3"=colScheme1[3])

col_list2 <- list("group1" = colScheme2[1]
                  ,"group2" = colScheme2[2]
                  ,"group3"=colScheme2[3])

# using function to assign variables and colors based on group
s1st1 <- gp_name_col(name_list1
                     , col_list1
                     ,s1st1)
s1st2 <- gp_name_col(name_list2
                     , col_list2
                     ,s1st2)

# plotting results
plotRadCon(df=s1st1
           ,s2=s21    
           ,s2_sig=s2_sig1
           ,filename = '' 
           ,plotType = ''
           )
plotRadCon(df=s1st2
           ,s2=s22   
           ,s2_sig=s2_sig2
           ,filename = 'example2' 
           ,plotType = 'EPS'
           ,title='Example Plot')




