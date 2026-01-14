_%% Preprocessing image and preparing demo
img = imread("cameraman.tif");
img = imresize(img,0.25);    % downsample image to remove memory constraints
x_original = img(:);

% Define variables
n = length(x_original);
p = round(n * 0.8);  % p = length(y)
%np = 1.5;  % n / np = p -> n=length(x), p=length(y)   TODO: reduce p dimension
%% C matrix:
if (true)
    pixelProbability = 0.2; % probability of a pixel in C being one
    C = rand(p,n) <= pixelProbability;  % multiple pixels per sample possible
elseif (false)
    C = zeros(p,n);
    for i = 1:p
        C(i,round(randi(n))) = 1;
    end
else
    colsToSkip = zeros(1,n-p);
    for i = 1:(n-p)
        colsToSkip(i) = randi(n);
    end
    
    C = zeros(p,n);
    lastRow = 0;
    for i = 1:n
        if ~ismember(i,colsToSkip)
            lastRow = lastRow + 1;
            C(lastRow,i) = 1;
        end
    end
end

%% Sample image
% C = eye(length(x));   % can be used to show sampling the full image

Psi_inv = dftmtx(n);    % Image -> Fourier
Psi = conj(Psi_inv)/n;  % Fourier -> Image
Theta = C * Psi;

y = C * double(x_original);  % This is the singel pixel camera taking the picture


%% no compressed sensing
% s = Psi_inv * double(x_original);
% 
% percentile = 10; % percentile to keep
% s_magnitude = log(1 + abs(s));
% threshold = prctile(s_magnitude(:), 100-percentile);
% s_compressed = s;
% s_compressed(s_magnitude <= threshold) = 0;
% 
% printNorms(s);
% printNorms(s_compressed);
% return; % execute final cells manually

%% Solve underdetermined system of equations
% y = Theta*s
% --> find s from y and Theta while minimizing L1 norm
% s = Theta\y;  % only works when sampling the entire image
cvx_begin;
    variable s(length(x_original));
    minimize( norm(s,1) );
    subject to
        % Theta*s == y;
        norm(Theta*s -y, 2) <= 1e-3
cvx_end;

%% Retransform to retrieve image
x = real(Psi*s);
resultImg = reshape(x,size(img));

%% show images
figure

subplot(1,2,1);
imshow(img);
title("Original image");
% subplot(1,3,2);
% imshow(reshape(y,size(img))); % Doesn't work because multiple pixels get sampled into one value of y
% title("Sampled image");
subplot(1,2,2);
imshow(resultImg);
title("Retransformed image");

figure
imshow(C)