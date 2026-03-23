
%% Set parameters

%pFactor = 0.5;
C_version = 0;
C_probability = 0.5;
Psi_version = 0;
Optimization_version = 0;
Show_C_matrix = false;
Show_s_histogram = false;
fileNameEnd = "images_";
sparsityCutoff = 1;

globalResultFigure = figure;
hold on;

%% DCT, varying number of measurements
f = [0.2, 0.3, 0.5]; % vary number of measurements
s_l0 = zeros(size(f));
resultImg = zeros(64,64);  % only stores the last result as an example

subplot(2,2,1);
img = imread("cameraman.tif");
img = imresize(img,0.25);
imshow(img);
title("Ground truth");

for pIndex = 1:length(f)
    [~, ~, resultImg] = CS_demo(f(pIndex), C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, strcat(fileNameEnd, string(f(pIndex))), sparsityCutoff);
    
    figure(globalResultFigure);
    subplot(2,2,pIndex+1);
    imshow(resultImg);
    title("f = " + f(pIndex));
end


disp("FINISHED!");