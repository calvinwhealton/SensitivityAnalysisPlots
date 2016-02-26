This repository contains code for displaying results of sensitivity analysis, specifically plots that have first-, second-, and total-order indices. Example plots are given in: "exam2.eps", "exam2.pdg", "exam2.png", "exam3.eps", and "plot.eps". The file "radialConvergeTest.R" provides examples of calling the function. Please read the licence before using the code.

This code is designed to generate plots that show the results of sensitivity analysis by showing first-, total- and second-order indices at the same time. The plots are structured so that each variable has a location on the edge of a circle. At this location the first-order index and the total-order index are plotted, with the first-order index being a filled circle and the total-order index being a "halo" around it. The second-order indices are plotted as connecting lines between the points. The width of all of the plotting element (lines, points) are proportional to the sensitivity index. Examples of similar plots can be seen in Butler et al (2014), although these were not generated with this code.

There are many many options for determining what points will be plotted or adjusting the plot. The code is designed to have default parameters that are reasonably specified so the output looks acceptable. The input data to this code was output from the Python package 'SALib' (https://github.com/SALib/SALib), but other sensitivity output formatted in this manner could also be used. Depending on the type of sensitivity output not all methods of selecting significant parameters may apply.

My intent is that the code can be easily hacked or changed by users if the current code does not allow the desired output. It is difficult to code all of the possible variants of the plot, but at least the code should be documented well enough so that if someone wants to add, remove, or restructure elements they can do it fairly easily.

More details about the code and general structure are in 'DOCUMENTATION.md'.

References:

Butler, M.P., P.M. Reed, K. Fisher-Vanden, K. Keller, T. Wagener (2014). Inaction and climate stabilization uncertainties lead to severe economic risks. _Climactic Change 127_:463-474
