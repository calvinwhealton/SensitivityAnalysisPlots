# function for plotting the radial convergence plots
# function takes input data frame

plotRadCon <- function(df                   # dataframe with S1 and ST indices
                       ,s2                  # S2 indices
                       ,s2_sig              # S2 significance matrix
                       ,filename = 'plot'   # file name for the saved plot
                       ,plotType = 'EPS'    # plot type
                       ,plotS2 = TRUE       # whether to plot S2 indices
                       ,radSc = 2           # radius scaling of entire plot
                       ,scaling=5           # scaling factor for plot
                       ,widthSc = 0.5       # power used in scaling width, 0.5 is root, 1 is simple multiple
                       ,STthick = 0.05      # value used in determining the width of the ST circle
                       ,line_sc_mult=10     # multiplier of scaling for the line width
                       ,line_col ='gray48'  # color used for lines
                       ,st_col = 'black'    # color for total-order index circle
                       ,s1_col = 'gray48'   # color for first-order index disk(filled circle)
                       ,asp=1               # aspect ratio
                       ,varNameMult = 1.2   # location of variable name with respect to the plot radius
                       ,gpNameMult = 1.6    # location of the group name with respect to the plot radius
                       ){
  
  # finding number of points to plot
  num_plot <- sum(df$sig)
  
  # polar cooridantes angular-values of locations
  angles <- radSc*pi*seq(0,num_plot-1)/num_plot
  
  # assigning coordinates to varaibles based on groups
  df$rad <- radSc
  df$ang <- NA 
  
  ## coordinates in polar for each variable
  # finding number of groups with a significant variable
  sig_gps <- unique(df$gp_name[which(df$sig %in% 1)])
  
  # initializing vector to hold the number of significant variables for each group
  num_sig_gp <- rep(0,length(sig_gps))
  
  # counter used for indexing the values in the angle vector
  counter <- 0
  
  for(i in 1:length(sig_gps)){
    # indices of variables in group and significant
    sig_in_gp <- intersect(which(df$gp_name %in% sig_gps[i]),which(df$sig %in% 1))
    
    # taking sequential values in the angles vector
    df$ang[sig_in_gp] <- angles[seq(counter+1,counter+length(sig_in_gp),1)]
    
    # indexing counter
    counter <- counter + length(sig_in_gp)
    
    # vector for counting number of statistically signficant variables in the applicable groups
    num_sig_gp[i] <- length(sig_in_gp)
  }

  ## converting to Cartesian coordinates
  df$x_val <- df$rad*cos(df$ang)
  df$y_val <- df$rad*sin(df$ang)
  
  # colors and scales used in plots
  line_scaling <- line_sc_mult*scaling
  
  ## file set-up storage
  if(plotType == 'EPS'){
    fname <- paste(filename,'.eps',sep='')
    savePlot <- TRUE
    setEPS()
    postscript(fname)
  }
#   else if(plotType == 'JPG'){
#     fname <- paste(filename,'.jpg',sep='')
#     savePlot <- TRUE
#     jpeg(file=fname)
#   }
#   else if(plotType == 'TIFF'){
#     fname <- paste(filename,'.tiff',sep='')
#     savePlot <- TRUE
#     tiff(file=fname)
#   }
#   else if(plotType == 'PDF'){
#     fname <- paste(filename,'.pdf',sep='')
#     savePlot <- TRUE
#     pdf(file=fname)
#   }
#   else if(plotType == 'PNG'){
#     fname <- paste(filename,'.png',sep='')
#     savePlot <- TRUE
#     png(file=fname)
#   }
#   else if(plotType == 'BMP'){
#     fname <- paste(filename,'.bmp',sep='')
#     savePlot <- TRUE
#     bmp(file=fname)
#   }
  else{
    print('Plot not automatically saved')
    savePlot <- FALSE
    
  }
  ## plotting
  # initial plot is empty
  plot(NA
       , NA
       , xlim = c(-2*radSc,2*radSc)
       , ylim = c(-2*radSc,2*radSc)
       , xaxt = 'n'
       , yaxt = 'n'
       , xlab = ''
       , ylab = ''
       , asp=asp)
  
  # plotting all lines that were significant----
  if(plotS2 == TRUE){
    for(i in 1:nrow(s2_sig)){
      for(j in 1:nrow(s2_sig)){
        if(s2_sig[j,i] == 1){
          lines(c(df$x_val[i],df$x_val[j])
                , c(df$y_val[i],df$y_val[j])
                , col=line_col
                , lwd = line_scaling*((s2[j,i])^widthSc)
                , lty=1
          )
        }
      }
    }
  }
  
  
  # plotting the total-order indices
  # plotting outer circle as a solid point
  points(df$x_val
         , df$y_val
         , col = st_col
         , pch = 19
         , cex = scaling*((df$ST)^widthSc)
         )
  # plotting the total-order indices inner white circle to make outline
  points(df$x_val
         , df$y_val
         , col = "white"
         , pch = 19
         , cex = scaling*(((df$ST)*(1-STthick))^widthSc)
         )
  
  # plotting first-order indices
  points(df$x_val
         , df$y_val
         , col = s1_col
         , pch = 19
         , cex = scaling*sqrt(df$S1^widthSc)*s1st$s1_sig
         )
  
  ## adding text to the plots
  # adding variable names
  for(i in 1:nrow(df)){
    text(varNameMult*df$rad[i]*cos(df$ang[i]), varNameMult*df$rad[i]*sin(df$ang[i])
         , df$ind[i]
         , col = df$gp_col[i]
         , srt = df$ang[i]*360/(2*pi)
         , adj = 0 
    )
  }
  
  # adding group names
  counter <- 0
  for(i in 1:length(num_sig_gp)){
    
    angle_gp <- mean(angles[seq(counter+1,counter+num_sig_gp[i],1)])
    
    counter <- counter + num_sig_gp[i]
    
    text(gpNameMult*radSc*cos(angle_gp), gpNameMult*radSc*sin(angle_gp)
         , sig_gps[i]
         , col = df$gp_col[which(df$gp_name %in% sig_gps[i])[i]]
         , srt =  angle_gp*360/(2*pi) - 90
         , adj = 0.5 # for centering
    )
  }
  
  # closing plot if save to external file
  if(savePlot == TRUE){
    dev.off()
    print(paste('Plot saved to ',fname,sep=''))
  }
}
  
