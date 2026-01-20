# CompressedSensing
A student project about compressed sensing.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=JKammeier/CompressedSensing)

# File Overview
- [CS_demo.m](./CS_demo.m): currently the main script of the project
- [printNorms.m](./printNorms.m): a utility to print norms of a vector to the console
- [showImages.m](./showImages.m): creates a figure to show before/after images
- [showResults.m](./showResults.m): loads and shows results from a .mat file
  - change the the filename at the beginning of the script to load your own .mat file
- [results_example.mat](./results_example.mat): An example of results from running the demo

# Requirements
- A current version of Matlab
- One L1-optimization tool
  - *recommended:* The [l1-magic](https://candes.su.domains/software/l1magic/index.html) collection of matlab routines to solve convex optimization problems
  - The [cvx](https://cvxr.com/cvx/) library to solve the convex optimization problem


# Known issues
- In the current implementation $s$ does not appear to be sparse after the optimization.
