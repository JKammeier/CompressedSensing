
% Set parameters
numberOfRuns = 1; % number of runs to average

%pFactor = 0.5;
C_version = 0;
C_probability = 0.2;
Psi_version = 0;
Optimization_version = 0;
Show_C_matrix = false;
Show_s_histogram = false;
fileNameEnd = "";

pFactors = 0.2:0.1:0.6; % vary number of measurements

%% DCT, varying number of measurements
distanceValues_DCT = zeros(size(pFactors));
s_DCT = 0;  % only stores the last result as an example

for pIndex = 1:length(pFactors)
    differenceValuesRaw = zeros(1, numberOfRuns);
    for run = 1:numberOfRuns
       [differenceValuesRaw(run), s_DCT] = CS_demo(pFactors(pIndex), C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, strcat("DCT-",string(pFactors(pIndex))));
    end
    distanceValues_DCT(pIndex) = mean(differenceValuesRaw);
end



%% DFT, varying number of measurements
Psi_version = 1;
distanceValues_DFT = zeros(size(pFactors));
s_DFT = 0; % only stores the last result as an example

for pIndex = 1:length(pFactors)
    differenceValuesRaw = zeros(1, numberOfRuns);
    for run = 1:numberOfRuns
       [differenceValuesRaw(run), s_DFT] = CS_demo(pFactors(pIndex), C_version, C_probability, Psi_version, Optimization_version, Show_C_matrix, Show_s_histogram, strcat("DFT-",string(pFactors(pIndex))));
    end
    distanceValues_DFT(pIndex) = mean(differenceValuesRaw);
end

%% plot the values of distanceValues_DCT and distanceValues_DFT
figure;
hold on;
plot(pFactors, distanceValues_DCT, '-o', 'DisplayName', 'DCT');
plot(pFactors, distanceValues_DFT, '-x', 'DisplayName', 'DFT');
xlabel('"Number of Measurements" Factor');
ylabel('Distance to ground truth');
title('Comparison of DCT and DFT');
legend show;
hold off;

disp("FINISHED!");