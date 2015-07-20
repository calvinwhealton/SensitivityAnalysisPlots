# functions for testing statistical significance
# determines which indices to plot based on values

# function inputs are:
#   df = data frame with sensitivity indices (S1 and ST)
#         includes columns for S1, ST, S1_conf, and ST_conf
#   method = method of testing
#           'sig' is statistically significant with alpha
#           'gtr' is greater than a specified value
#   sigCri = significance criteria
#             'either' parameter is signficant if either S1 or ST is significant
#             'S1' parameter is significant if S1 (or S1 and ST) is significant
#             'ST' parameter is significant if ST (or S1 and ST) is significant

#####################################################
# function for testing significance of S1 and ST
# functions assume the confidence are for already defined type I error
stat_sig_s1st <- function(df
                     ,greater = 0.01
                     ,method='sig'
                     ,sigCri = 'either'){
  
  # initializing columns for the statistical significance of indices
  df$s1_sig <- 0
  df$st_sig <- 0
  df$sig <- 0
  
  # testing for statistical significance
  if(method == 'sig'){
    # testing for statistical significance using the confidence intervals
    df$s1_sig[which(abs(s1st$S1) - s1st$S1_conf > 0)] <- 1
    df$s1_sig[which(abs(s1st$ST) - s1st$ST_conf > 0)] <- 1
  }
  else if(method == 'gtr'){
    # finding indicies that are greater than the specified values
    df$s1_sig[which(abs(s1st$S1) > greater)] <- 1
    df$st_sig[which(abs(s1st$ST) > greater)] <- 1
  }
  else{
    print('Not a valid parameter for method')
  }
  
  # determining whether the parameter is signficiant
  if(sigCri == 'either'){
    for(i in 1:nrow(df)){
      df$sig[i] <- max(df$s1_sig[i],df$st_sig[i])
    }
  }
  else if(sigCri == 'S1'){
    df$sig <- df$s1_sig
  }
  else if(sigCri == 'ST'){
    df$sig <- df$st_sig
  }
  else{
    print('Not a valid parameter for SigCri')
  }
  
  # returned dataframe will have columns for the test of statistical significance
  return(df)
}

#####################################################
# function to test statistical significane of S2 indices
stat_sig_s2 <- function(dfs2
                          ,dfs2Conf
                          ,greater = 0.01
                          ,method='sig'){
   
  # initializing matrix to return values
  s2_sig <- matrix(0,nrow(s2),ncol(s2))
  
  # testing for statistical significance
  if(method == 'sig'){
    # testing for statistical significance using the confidence intervals
    s2_sig[which(abs(s2) - s2_conf > 0)] <- 1
  }
  else if(method == 'gtr'){
    # finding indicies that are greater than the specified values
    s2_sig[which(abs(s2) > greater)] <- 1
  }
  else{
    print('Not a valid parameter for method')
  }
  
  # returned dataframe will have columns for the test of statistical significance
  return(s2_sig)
}
