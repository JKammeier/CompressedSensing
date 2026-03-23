# CompressedSensing
A student project about compressed sensing.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=JKammeier/CompressedSensing)

# File Overview
- scripts to run predefined tests (they call CS_demo.m)
    - [create_pictures.m](./create_pictures.m): creates example pictures for three different factors $f$
    - [demonstrateSparsity.m](./demonstrateSparsity.m): presents the sparsity of the vector $\hat s$
    - [test_custom_picture.m](./test_custom_picture.m): runs the CS demo on a custom picture
        - change the filename at the beginning or name your file "test_image.jpg" to load your image
    - [test_f_factors.m](./test_f_factors.m): tests different values for the factor $f$ and averages the result of multiple runs
- [CS_demo.m](./CS_demo.m): the main function of the project implementing CS
- [printNorms.m](./printNorms.m): a utility to print norms of a vector/matrix to the console
- [showImages.m](./showImages.m): creates a figure to show before/after images
- [showResults.m](./showResults.m): loads and shows results from a .mat file
  - change the the filename at the beginning of the script to load your own .mat file
- [results_example.mat](./results_example.mat): An example of results from running the demo

# Requirements
- A current version of Matlab
- One L1-optimization tool
  - *recommended:* The [l1-magic](https://candes.su.domains/software/l1magic/index.html) collection of matlab routines to solve convex optimization problems
  - The [cvx](https://cvxr.com/cvx/) library to solve the convex optimization problem
