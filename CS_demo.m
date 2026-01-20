function CS_demo()
    %% Preprocess image and prepare demo
    img = imread("cameraman.tif");
    img = imresize(img,0.25);    % downsample image to remove memory constraints
    x_original = img(:);
    
    % Define variables
    n = length(x_original);
    p = round(n * 0.5);  % p = length(y)
    C_version = 0.2;  % <1: this prob. for each element; 1: one random one per row; 2: roughly identity matrix
    Psi_version = 0; % 0: DCT; 1: DFT
    Optimization_version = 0; % 0: l1-magic; 1: cvx
    Show_C_matrix = 0;  % 0: don't show; 1: show

    %% Create sampling matrix C
    C = create_C(n, p, C_version);   % Choose the method of creating C
    
    %% Sample image
    
    [Psi, ~] = create_Psi(n, Psi_version);

    Theta = C * Psi;
    
    y = C * double(x_original);  % This is the singel pixel camera taking the picture
    
    %% Solve underdetermined system of equations with L1 optimization
    
    s = solve_L1_optimization(y, Theta, Optimization_version);
    
    %% Retransform to retrieve image
    x_hat = uint8(real(Psi*s));
    resultImg = reshape(x_hat,size(img));
    
    %% Show images
    show_images(img, resultImg, Show_C_matrix*C);
    
    %% Save workspace
    save_workspace(img, n, p, C, s, x_hat);
    
end

function C = create_C(n, p, version)
    if (version >= 0 && version < 1)   % Set probability for each entry
        pixelProbability = version; % probability of a pixel in C being one
        C = rand(p,n) <= pixelProbability;  % multiple pixels per sample possible
    elseif (version == 1)   % One random column per row
        C = zeros(p,n);
        for i = 1:p
            C(i,round(randi(n))) = 1;
        end
    elseif (version == 2)   % roughly diagonal matrix -> probably doesn't work
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
    else
        disp("ERROR: Incorrect C implementation specified!")
    end
end

% Psi: sparse domain -> true image
% Psi_inv: true image -> sparse domain
function [Psi, Psi_inv] = create_Psi(n, version)
    if (version == 0)   % Discrete Cosine Transform
        Psi_inv = dctmtx(n);
            Psi = Psi_inv';
    elseif (version == 1)   % Discrete Fourier Transform
        Psi_inv = dftmtx(n);
        Psi = conj(Psi_inv)/n;
    else
        disp("ERROR: Incorrect Psi implementation specified!");
    end
end

% y = Theta*s
% --> find s from y and Theta while minimizing L1 norm
function s = solve_L1_optimization(y, Theta, version)
    if (version == 0)   % l1-magic
        s0 = Theta'*y;
        s = l1eq_pd(s0, Theta, [], y, 1e-3);
    elseif (version == 1)   % cvx
        cvx_begin;
            variable s(length(x_original));
            minimize( norm(s,1) );
            subject to
                % Theta*s == y;
                norm(Theta*s -y, 2) <= 1e-3
        cvx_end;
    else
        disp("ERROR: Incorrect optimization implementation specified!")
    end

end

function show_images(original, retransformed, C)
    figure
    
    subplot(1,2,1);
    imshow(original);
    title("Original image");
    subplot(1,2,2);
    imshow(retransformed);
    title("Retransformed image");
    
    if (C ~= 0)
        figure
        imshow(C)
    end
end

function save_workspace(img, n, p, C, s, x_hat)
    filename = sprintf('results_%d.mat',uint64(posixtime(datetime('now'))));
    save(filename,'img', 'n', 'p', 'C', 's', 'x_hat');
end