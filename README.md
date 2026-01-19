# CompressedSensing
A student project about compressed sensing.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=JKammeier/CompressedSensing)

# File Overview
- [CS_demo.m](./CS_demo.m) currently the main file of the project
- [printNorms.m](./printNorms.m) a utility to print norms of a vector to the console

# Requirements
- A current version of Matlab
- The [cvx](https://cvxr.com/cvx/) library to solve the convex optimization problem

# Known issues
- In the current implementation $s$ does not appear to be sparse after the optimization.
