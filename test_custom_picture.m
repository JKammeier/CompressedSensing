
%% Set parameters
f = 0.5;
C_version = 0;
C_probability = 0.5;
Psi_version = 0;
Optimization_version = 0;
Show_C_matrix = false;
Show_s_histogram = false;
fileNameEnd = "custom_image";
sparsityCutoff = 1;

%% prepare image
preparation = figure;

% load image
image = imread("test_image.jpg");
subplot(1,3,1);
imshow(image);
title("Original image");

% make image grayscale
image = rgb2gray(image);
subplot(1,3,2);
imshow(image);
title("Grayscale image");

% scale down image (5000 < n <= 10000)
% image = imresize(image, [64, 64]);
while numel(image) > 10000
    image = imresize(image,0.5);
end
subplot(1,3,3);
imshow(image);
title("Downscaled image -> ground truth for CS")


%% run CS_demo

[difference_l2, s_hat, resultImg] = CS_demo(f, C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, fileNameEnd, sparsityCutoff, image);


disp("FINISHED!");