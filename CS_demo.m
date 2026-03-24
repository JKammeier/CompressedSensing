function [difference_l2, s, resultImg] = CS_demo(pFactor, C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, fileNameEnd, sparsityCutoff, image)
    % pFactor - p = n*pFactor (Factor between original image vector length n and number of CS measurements p)
    % C_version - 0: Set prob. for each element to be one; 1: one random one per row; 2: roughly identity matrix
    % C_probability - Probability used in C creation
    % Psi_version - 0: DCT; 1: DFT
    % Optimization_version - 0: l1-magic; 1: cvx
    % Show_C_matrix - boolean
    % Show_s_histogram - boolean
    % fileNameEnd - a suffix added to the filename (before the extension)
    % sparsityCutoff - Absolute values lower than this will be set to 0 in
    %                   s
    % image - the image that will be used as an example; set to 0 to
    %               use default "cameraman"

    %% Preprocess image and prepare demo
    if isscalar(image) && image == 0
        img = imread("cameraman.tif");
        img = imresize(img,0.25);    % downsample image to remove memory constraints
    else
        img = image;
    end
    x_original = img(:);    % This is now ground truth (img: matrix, x_original: vector)
    
    % Define variables
    n = length(x_original);
    p = round(n * pFactor);  % p = length(y)

    %% Create sampling matrix C
    C = create_C(n, p, C_version, C_probability);   % Choose the method of creating C
    
    %% Sample image
    
    [Psi, ~] = create_Psi(n, Psi_version);

    Theta = C * Psi;
    
    y = C * double(x_original);  % This is the singel pixel camera taking the picture
    
    %% Solve underdetermined system of equations with L1 optimization
    
    s = solve_L1_optimization(y, Theta, Optimization_version);

    % force s to be sparse
    s(abs(s) < sparsityCutoff) = 0;
    
    %% Retransform to retrieve image
    x_hat = uint8(real(Psi*s));
    resultImg = reshape(x_hat,size(img));
    
    %% Show images
    showImages(img, resultImg, Show_C_matrix*C, Show_s_histogram*s);

    %% Print Norms
    disp("s vector:");
    printNorms(s);
    disp("Distance between images:");
    [~, ~, difference_l2] = printNorms(double(img-resultImg));

    %% Save workspace
    save_workspace(img, n, p, C, s, x_hat, C_version, Psi_version, Optimization_version, fileNameEnd);
end

function C = create_C(n, p, version, probability)
    if (version == 0)   % Set probability for each entry
        C = rand(p,n) <= probability;  % multiple pixels per sample possible
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
    maxError = 1e-3;
    if (version == 0)   % l1-magic
        s0 = Theta'*y;
        s = l1eq_pd(s0, Theta, [], y, maxError);
    elseif (version == 1)   % cvx
        cvx_begin;
            variable s(length(Theta));
            minimize( norm(s,2) );
            subject to
                % Theta*s == y;
                norm(Theta*s -y, 2) <= maxError;
        cvx_end;
    else
        disp("ERROR: Incorrect optimization implementation specified!")
    end

end

function save_workspace(img, n, p, C, s, x_hat, C_version, Psi_version, Optimization_version, fileNameEnd)
    % filename contains a timestamp to remove risk of overwriting data
    filename = sprintf('./results/results_%d_%s.mat', uint64(posixtime(datetime('now'))), fileNameEnd);
    save(filename,'img', 'n', 'p', 'C', 's', 'x_hat', 'C_version', 'Psi_version', 'Optimization_version');
end