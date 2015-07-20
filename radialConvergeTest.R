# script to generate sensitivity plots
# with first- and total-order indices as circles
# and second-order indices as lines

# libraries----
library(RColorBrewer)

# setting working directory-----
setwd("/Users/calvinwhealton/GitHub/SAPlots")

# functions in other files
source('sigTests.R')
source('groupAssign.R')
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
s1st1 <- stat_sig_s1st(s1st1
                      ,method="sig"
                      ,sigCri='either')

# S1 & ST: using greater than a given value
s1st2 <- stat_sig_s1st(s1st2
                      ,method="gtr"
                      ,greater=0.01
                      ,sigCri='either')

# S2: using the confidence intervals
s2_sig1 <- stat_sig_s2(s2
                       ,s2_conf
                       ,method='sig')

# S2: using greater than a given value
s2_sig2 <- stat_sig_s2(s2
                       ,s2_conf
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

## finding number of points to plot and locations----

# coordinates in polar
s1st$ang[group1_inds] <- angles[1:length(group1_inds)]
s1st$ang[group2_inds] <- angles[(length(group1_inds)+1):(length(group1_inds)+length(group2_inds))]
s1st$ang[group3_inds] <- angles[(length(group1_inds)+length(group2_inds)+1):(length(group1_inds)+length(group2_inds)+length(group3_inds))]

# coordinates in cartesian
s1st$x_val <- s1st$rad*cos(s1st$ang)
s1st$y_val <- s1st$rad*sin(s1st$ang)

## plotting results----

# colors and scales used in plots
scaling <- 5 # scaling of the circiles
line_scaling <- 10*scaling

line_col <- "gray48"

tot_col <- "black"
s1_col <- "gray48"




# initial plot is empty
plot(NA
     , NA
     , xlim = c(-4,4)
     , ylim = c(-4,4)
     , xaxt = 'n'
     , yaxt = 'n'
     , xlab = ''
     , ylab = ''
     , asp=1)

# plotting all lines that were significant
for(i in 1:nrow(s1st)){
  for(j in 1:nrow(s1st)){
    if(s2_sig[j,i] == 1){
      lines(c(s1st$x_val[i],s1st$x_val[j])
            , c(s1st$y_val[i],s1st$y_val[j])
            , col=line_col
            , lwd = line_scaling*sqrt(s2[j,i])
            , lty=1)
    }
  }
}

# plotting the total-order indices
points(s1st$x_val
       , s1st$y_val
       , col = tot_col
       , pch = 19
       , cex = scaling*sqrt(s1st$ST))
# plotting the total-order indices
points(s1st$x_val
       , s1st$y_val
       , col = "white"
       , pch = 19
       , cex = scaling*sqrt(s1st$ST)*0.95)

# plotting the total-order indices
# plotting the total-order indices
points(s1st$x_val
       , s1st$y_val
       , col = s1_col
       , pch = 19
       , cex = scaling*sqrt(s1st$S1)*s1st$s1_sig)

for(i in 1:nrow(s1st)){
  text(1.2*s1st$rad[i]*cos(s1st$ang[i]), 1.2*s1st$rad[i]*sin(s1st$ang[i])
       , s1st$ind[i]
       , col = s1st$gp_col[i]
       , srt = s1st$ang[i]*360/(2*pi)
       , adj = 0
       )
}



