
%% Set parameters
numberOfRuns = 1; % number of runs to average

%f = 0.5;
C_version = 0;
C_probability = 0.5;
Psi_version = 0;
Optimization_version = 0;
Show_C_matrix = false;
Show_s_histogram = false;
fileNameEnd = "f_";
sparsityCutoff = 1;
custom_image = 0;

globalResultFigure = figure;
hold on;

%% DCT, varying number of measurements
f = 0.1:0.1:1.0; % vary number of measurements
distanceValues_DCT = zeros(size(f));
s_l0 = zeros(size(f));
s_DCT = zeros(4096);  % only stores the last result as an example

for pIndex = 1:length(f)
    differenceValuesRaw = zeros(1, numberOfRuns);
    s_l0_Raw =zeros(1, numberOfRuns);
    for run = 1:numberOfRuns
       [differenceValuesRaw(run), s_DCT, ~] = CS_demo(f(pIndex), C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, strcat(fileNameEnd, string(f(pIndex))), sparsityCutoff, custom_image);
        s_l0_Raw(run) = nnz(s_DCT) / numel(s_DCT);
    end
    distanceValues_DCT(pIndex) = mean(differenceValuesRaw);
    s_l0(pIndex) = 100 * mean(s_l0_Raw);
end

figure(globalResultFigure);

yyaxis left
plot(f, distanceValues_DCT, '-x', 'Color', 'b');
ylabel('Distance to ground truth: $|| x - \hat{x}||_2$', 'Interpreter', 'latex');
offset = 0.01 * (max(distanceValues_DCT) - min(distanceValues_DCT));
text(f, distanceValues_DCT + offset, string(distanceValues_DCT), 'FontSize', 8, 'VerticalAlignment','bottom','HorizontalAlignment','right');

yyaxis right
plot(f, s_l0, '-o', 'Color', 'r');
ylabel('Number of nonzero entries (L0 norm) [%]');
offset = 0.01 * (max(s_l0) - min(s_l0));
text(f, s_l0 + offset, string(s_l0), 'FontSize', 8, 'VerticalAlignment','bottom','HorizontalAlignment','right');

xlabel('$f = \frac{p}{n}$', 'Interpreter', 'latex');


%% DCT, varying sparsityCutoff
% sparsityCutoff = [ 0, 0.1, 1, 10, 100, 1000 ];
% distanceValues_DCT = zeros(size(f));
% s_DCT = 0;  % only stores the last result as an example
% 
% for pIndex = 1:length(sparsityCutoff)
%     differenceValuesRaw = zeros(1, numberOfRuns);
%     for run = 1:numberOfRuns
%        [differenceValuesRaw(run), s_DCT, ~] = CS_demo(f, C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, strcat("cutoff-",string(f)), sparsityCutoff(pIndex));
%     end
%     distanceValues_DCT(pIndex) = mean(differenceValuesRaw);
% end
% figure(globalResultFigure);
% plot(f, distanceValues_DCT, '-o', 'DisplayName', 'DCT');
% xlabel('sparsity cutoff value');


%% DFT, varying number of measurements
% Psi_version = 1;
% distanceValues_DFT = zeros(size(f));
% s_DFT = 0; % only stores the last result as an example
% 
% for pIndex = 1:length(f)
%     differenceValuesRaw = zeros(1, numberOfRuns);
%     for run = 1:numberOfRuns
%        [differenceValuesRaw(run), s_DFT, ~] = CS_demo(f(pIndex), C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, strcat("DFT-",string(f(pIndex))));
%     end
%     distanceValues_DFT(pIndex) = mean(differenceValuesRaw);
% end
% figure(globalResultFigure);
% plot(f, distanceValues_DFT, '-x', 'DisplayName', 'DFT');


%% plot the values of distanceValues_DCT and distanceValues_DFT

figure(globalResultFigure);

% title('Comparison of different numbers of measurements p');
% legend show;
hold off;

disp("FINISHED!");
