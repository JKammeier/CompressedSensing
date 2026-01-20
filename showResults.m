%% Load .mat file
load('results_example.mat');

resultImg = reshape(x_hat,size(img));

showImages(img, resultImg, 0*C);