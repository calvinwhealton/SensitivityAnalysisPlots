# functions for substituting group information into dataframe

# function for assigning group name and color to group
gp_name_col <- function(name_list       # list of variables names for each group
                        ,col_list=NULL  # list of colors for each group
                        ,df             # data frame of values with ind as the variable name
                        ){
  
  # initializing columns
  df$gp_name <- NA # group name
  df$gp_col <- NA  # group colors
  
  # checking for the same variable names
  n1 <- sort(names(name_list))
  if(is.null(col_list) == TRUE){
    n2 <- n1
  }else{
    n2 <- sort(names(col_list))
  }
  
  if(is.null(col_list)){
    print('Group color list not defined, using default')
    assignCol <- TRUE
  }else if(length(setdiff(n1,n2)) != 0){
    print('Group names do not match across the two lists')
    assignCol <- FALSE
  }else{
    assignCol <- TRUE
  }
  
  # loop over the variables in each group and assign group name
  for(i in 1:length(n1)){
    
    # extracting the variable names for the given element
    var_names <- unlist(name_list[names(name_list)[i]])
    
    # loop over the values in each list
    for(j in 1:length(var_names)){
      # substituting group name in for the variable
      df$gp_name[which(df$ind %in% var_names[j])] <- names(name_list)[i]
    }
  }
  
  # loop over the group names and assign the color
  if(assignCol == TRUE){
    if(is.null(col_list)==TRUE){
      colorsGps <- brewer.pal(length(names(name_list)),'Set1')
      for(i in 1:length(names(name_list))){
        df$gp_col[which(df$gp_name %in% unlist(names(name_list))[i])] <- colorsGps[i]
      }
    }else{
      for(i in 1:length(names(col_list))){
        df$gp_col[which(df$gp_name %in% unlist(names(name_list))[i])] <- unlist(col_list[names(col_list)[i]])
      }
    }
  }
  
  # returning data frame with additional columns
  return(df)
}