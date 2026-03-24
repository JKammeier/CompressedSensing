%% Load .mat file
load('results/results_example.mat');

resultImg = reshape(x_hat,size(img));

show_C = false;
show_s = true;

showImages(img, resultImg, show_C*C, show_s*s);