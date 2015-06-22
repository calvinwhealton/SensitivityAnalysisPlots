# script to generate sensitivity plots
# with first- and total-order indices as circles
# and second-order indices as lines

# libraries----
library(RColorBrewer)

# setting working directory-----
setwd("/Users/calvinwhealton/GitHub/SAPlots")

## importing data from sensitivity analysis----
# importing first- and total-order indices
s1st <- read.table("S1ST_output.txt"
                   , sep=','
                   , header=TRUE)

# importing second-order indices
s2 <- read.table("S2_output.txt"
                   , sep=','
                   , header=FALSE)
s2_conf <- read.table("S2_conf_output.txt"
                   , sep=','
                   , header=FALSE)


## determining which indices are statistically significant----
# testing if it is outside of the 95% CI
s1st$s1_sig <- 0
s1st$s1_sig[which(abs(s1st$S1) - s1st$S1_conf > 0 )] <- 1

s1st$st_sig <- 0
s1st$st_sig[which(abs(s1st$ST) - s1st$ST_conf > 0 )] <- 1

s2_sig <- matrix(0,nrow(s2),ncol(s2))
s2_sig[which(abs(s2) - s2_conf > 0)] <- 1

## defining groups for the variables----
# defing indices for each group
group1_inds <- c(1,4,7,8)
group2_inds <- c(2,3,9)
group3_inds <- c(5,6,10)

# initializing variable for group name and filling-in values
s1st$gp_name <- NA
s1st$gp_name[group1_inds] <- c("group1")
s1st$gp_name[group2_inds] <- c("group2")
s1st$gp_name[group3_inds] <- c("group3")

## setting group color schemes----
# colors for three groups
gp_cols <- c("lightcoral","deepskyblue","green3")

# initializing group color column and then filling-in values
s1st$gp_col <- NA
s1st$gp_col[group1_inds] <- gp_cols[1]
s1st$gp_col[group2_inds] <- gp_cols[2]
s1st$gp_col[group3_inds] <- gp_cols[3]

## finding number of points to plot and locations----
# could be based on statistical significance or magnitude of indices
num_plot <- sum(s1st$st_sig)

# polar cooridantes angular-values of locations
angles <- 2*pi*seq(0,num_plot-1)/num_plot
radius <- 2

# assigning coordinates to varaibles based on groups----
s1st$rad <- radius
s1st$ang <- NA

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



