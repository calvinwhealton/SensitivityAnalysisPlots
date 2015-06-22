# -*- coding: utf-8 -*-
"""
Created on Tue Jun  2 08:00:41 2015

@author: calvinwhealton

general functions to test sensitivity
"""

import numpy as np
from SALib.sample import saltelli
from SALib.analyze import sobol
from SALib.test_functions import Ishigami
import numpy as np
import pandas as pd
import csv

def sampleFunc1 (values):
    
    # function similar to the Ishigami function but with more arguements
    y = np.sin(values[:,1]*np.pi) \
        + 4.*(np.sin(values[:,2]*np.pi)**2) \
        + (values[:,3]**4)*np.sin(values[:,1]*np.pi) \
        + values[:,0]*(values[:,1]**2)*values[:,3] \
        + 4.*values[:,4]*np.cos(values[:,5]*np.pi) \
        + np.cos(values[:,6]*np.pi)*np.sin(values[:,7]) \
        + 3.*values[:,8] \
        + 4.*values[:,9]
        
    return y

problem = {
  'num_vars': 10, 
  'names': ['x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'x8', 'x9', 'x10'], 
  'bounds': [[-3.14159265359, 3.14159265359], 
             [-3.14159265359, 3.14159265359], 
             [0,1],
             [-2,1],
             [-1,1],
             [-3,0],
             [0,3],
             [-2,2],
             [-0.5,0.5],
             [-3,3]]
}



param_values = saltelli.sample(problem, 50000, calc_second_order=True)

Y = sampleFunc1(param_values)

Si = sobol.analyze(problem, Y, print_to_console=False)

SA = {"S1" : pd.Series(Si["S1"], index=problem['names']),
      "S1_conf" : pd.Series(Si["S1_conf"], index=problem['names']),
      "ST" : pd.Series(Si["ST"], index=problem['names']),
      "ST_conf" : pd.Series(Si["ST_conf"], index=problem['names'])
      }
      
SA_df = pd.DataFrame(SA)

SA_df.to_csv("S1ST_output.txt",index_label='ind', sep=',')
np.savetxt("S2_output.txt",Si["S2"], delimiter=',')
np.savetxt("S2_conf_output.txt",Si["S2_conf"], delimiter=',')