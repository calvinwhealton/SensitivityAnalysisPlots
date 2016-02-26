# function to complete all significance and plotting
evalPlotIndsRadCon <- function(df                   # data frame of S1 and ST indices (and confidence intervals if evaluating significance)
                               ,dfs2                # matrix/data frame of S2 indices
                               ,dfs2Conf            # matrix/data frame of S2 indices confidence interval
                               ,gpNameList          # list of variables names for each group
                               ,gpColList=NULL      # list of colors for each group
                               ,s1stgtr=0.01        # criteria for significance of S1 and ST if using method 'gtr'
                               ,s1stmeth='sig'      # method for evaluating significant of S1 and ST
                               ,s1stsigCri='either' # method for determining plotting significance based on S1 and ST
                               ,s2meth='sig'      # method for evaluating significant S2 indices
                               ,s2gtr = 0.01        # threshold used when s2 method is gtr
                               ,ptTitle = ''        # title for plot
                               ,ptFileNm='plot'     # name for plot
                               ,ptType = 'EPS'      # type of file for plot
                               ,ptS2 = TRUE         # plot S2's
                               ,ptRadSc = 2         # radius scaling of entire plot
                               ,ptScCirc=1          # scaling factor for plot
                               ,ptCircSc = 0.5      # power used in scaling width, 0.5 is root, 1 is simple multiple
                               ,ptSTthick = 0.05    # value used in determining the width of the ST circle
                               ,ptLineCol ='gray48' # color used for lines
                               ,ptStcol = 'black'   # color for total-order index circle
                               ,ptS1col = 'gray48'  # color for first-order index disk(filled circle)
                               ,ptVarNmMult = 1.2   # location of variable name with respect to the plot radius
                               ,gpNmMult = 1.6      # location of the group name with respect to the plot radius
                               ,ptLegLoc = 'topleft'# legend location
                               ,ptLegTh=c(0.1,0.5)  # legend thickensses
                               ,ptLegPos=1.9        # relative location of legend
                               ,ptRes=300           # resolution for the plot file
                               ,ptQual=90           # quality of a JPG
  
){
  
  
  # evaluating the signficant points for plotting
  dfcalc <- stat_sig_s1st(df=df
                          ,greater = s1stgtr
                          ,method=s1stmeth
                          ,sigCri = s1stsigCri)
  
  # evaluating significant S2's
  dfs2plot <- stat_sig_s2(dfs2 = dfs2
                          ,dfs2Conf = dfs2Conf
                          ,method = s2meth
                          ,greater=s2gtr)
  
  # assigning group information
  dfcalc <- gp_name_col(name_list=gpNameList  
                        ,col_list=gpColList 
                        ,df=dfcalc)
  
  # plotting results
  plotRadCon(df=dfcalc
             ,s2=dfs2
             ,s2_sig=dfs2plot
             ,title=ptTitle
             ,filename = ptFileNm
             ,plotType = ptType
             ,plotS2 = ptS2
             ,radSc = ptRadSc
             ,scaling=ptScCirc
             ,widthSc = ptCircSc
             ,STthick = ptSTthick
             ,line_col = ptLineCol
             ,st_col = ptStcol
             ,s1_col = ptS1col
             ,varNameMult = ptVarNmMult
             ,gpNameMult = gpNmMult
             ,legLoc = ptLegLoc
             ,legThick = ptLegTh
             ,legPos=ptLegPos
             ,res = ptRes
             ,qual=ptQual)
  
  # returning data frame with calculations
  return(dfcalc)
}