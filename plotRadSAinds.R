# function for plotting the radial convergence plots
# function takes input data frame

plotRadCon <- function(df                   # dataframe with S1 and ST indices
                       ,s2                  # S2 indices
                       ,s2_sig              # S2 significance matrix
                       ,filename = 'plot'   # file name for the saved plot
                       ,plotType = 'EPS'    # plot type
                       ,plotS2 = TRUE       # whether to plot S2 indices
                       ,radSc = 2           # radius scaling of entire plot
                       ,scaling=1           # scaling factor for plot
                       ,widthSc = 0.5       # power used in scaling width, 0.5 is root, 1 is simple multiple
                       ,STthick = 0.05      # value used in determining the width of the ST circle
                       ,line_col ='gray48'  # color used for lines
                       ,st_col = 'black'    # color for total-order index circle
                       ,s1_col = 'gray48'   # color for first-order index disk(filled circle)
                       ,asp=1               # aspect ratio
                       ,varNameMult = 1.2   # location of variable name with respect to the plot radius
                       ,gpNameMult = 1.6    # location of the group name with respect to the plot radius
                       ,legLoc = 'topleft'  # legend location
                       ,legThick=c(0.1,0.5) # legend thickensses
                       ,legPos=1.9          # legend relative position
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
        # only plot second order when the two indices are significant
        if(s2_sig[j,i]*(df$sig[i]*df$sig[j]) == 1){
          
          # coordinates of the center line
          clx <- c(df$x_val[i],df$x_val[j])
          cly <- c(df$y_val[i],df$y_val[j])
          
          # calculating the angle of the center line
          # calculating tangent as opposite (difference in y) 
          # divided by adjacent (difference in x)
          clAngle1 <- atan((cly[2]-cly[1])/(clx[2]-clx[1]))
          
          # adding angle when both values are negative to make it on (-pi/2,3*pi/2)
          if(cly[2]-cly[1] < 0){
            clAngle1 <- clAngle1 + pi
          }
          
          # half width of the line
          line_hw <- scaling*(s2[j,i]^widthSc)/2
          
          # creating vector of polygon coordinates
          polyx <- rep(0,4)
          polyy <- rep(0,4)
          
          polyx[1] <- clx[1] - line_hw*sin(clAngle1)
          polyx[2] <- clx[1] + line_hw*sin(clAngle1)
          polyx[3] <- clx[2] + line_hw*sin(clAngle1)
          polyx[4] <- clx[2] - line_hw*sin(clAngle1)
          
          polyy[1] <- cly[1] + line_hw*cos(clAngle1)
          polyy[2] <- cly[1] - line_hw*cos(clAngle1)
          polyy[3] <- cly[2] - line_hw*cos(clAngle1)
          polyy[4] <- cly[2] + line_hw*cos(clAngle1)
          
          # making polygons
          polygon(polyx,polyy
                  ,density=200
                  ,border=NA
                  ,col=line_col)
        }
      }
    }
  }
  
  for(i in 1:nrow(df)){
    if(df$sig[i] == 1){
      
      # circle for total order index
      draw.circle(df$x_val[i]
                  ,df$y_val[i]
                  ,radius <- scaling*(df$ST[i]^widthSc)/2
                  ,nv=200
                  ,border=NA
                  ,col=st_col
                  )
      
      # white circle to make total-order an outline
      draw.circle(df$x_val[i]
                  ,df$y_val[i]
                  ,radius <- (1-STthick)*scaling*(df$ST[i]^widthSc)/2
                  ,nv=200
                  ,border=NA
                  ,col="white"
                  )
      
      # gray circle for first-order
      draw.circle(df$x_val[i]
                  ,df$y_val[i]
                  ,radius <- scaling*(df$S1[i]^widthSc)/2
                  ,nv=200
                  ,border=NA
                  ,col=s1_col
                  )   
    }
  }
  
  ## adding text to the plots
  # adding variable names
  for(i in 1:nrow(df)){
    if(is.na(df$ang[i]) == FALSE){
      text(varNameMult*df$rad[i]*cos(df$ang[i]), varNameMult*df$rad[i]*sin(df$ang[i])
           , df$ind[i]
           , col = df$gp_col[i]
           , srt = df$ang[i]*360/(2*pi)
           , adj = 0 
      )
    }
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
  
  ## adding legend
  if(legLoc == 'topleft'){
    xloc <- rep(-legPos*radSc ,length(legThick))
    yloc <- seq(legPos*radSc ,1*radSc ,by=-0.3*radSc )
  }
  else if(legLoc=='topright'){
    xloc <- rep(legPos*radSc ,length(legThick))
    yloc <- seq(legPos*radSc ,1*radSc ,by=-0.3*radSc )
  }
  else if(legLoc=='bottomleft'){
    xloc <- rep(-legPos*radSc ,length(legThick))
    yloc <- seq(-legPos*radSc ,-1*radSc ,by=0.3*radSc )
  }
  else{
    xloc <- rep(legPos*radSc ,length(legThick))
    yloc <- seq(-legPos*radSc ,-1*radSc ,by=0.3*radSc )
  }
  for(i in 1:length(xloc)){
    # gray circle for legend
    draw.circle(xloc[i]
                ,yloc[i]
                ,radius <- scaling*(legThick[i]^widthSc)/2
                ,nv=200
                ,border=NA
                ,col=s1_col
                )   
    text(xloc[i]*0.8,yloc[i]
         ,as.character(legThick[i])
         ,col=s1_col)
    }

  # closing plot if save to external file
  if(savePlot == TRUE){
    dev.off()
    print(paste('Plot saved to ',fname,sep=''))
  }
}
  
