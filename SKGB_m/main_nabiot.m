clear;clc;
% data = importdata('data/Chainlink_data.txt');
% data = importdata('D:\Academic_Writing\Clustering\SKGB\data_Marveen\N-BaIot\whole_data.txt');
data = importdata('L:\experiment\合成聚类数据集\N-BaIoT Dataset\sample data\whole_data.txt');
% data = importdata('L:\experiment\实验信息\Acc on pendigits\pendigits_data.txt');
% data = importdata('L:\experiment\合成聚类数据集\3M2D5\data.txt');
% data = importdata('C:\Users\Lqhness\PycharmProjects\pythonProject\data\twenty_data.txt');

% rng(619); % Seed
rng('shuffle'); % Shuffle the seed based on the current time
seedData = rng; % Record the current seed and the random number generator settings
disp(['Seed: ', num2str(seedData.Seed)]); % Display the seed
[n_points, n_features] = size(data); % numRows, numCols

% ------------------------Parameters---------------------------------------
num_samples = 30;                                   % parameter S: number of sample sets,
alpha = 1e-3;                                       % parameter alpha
sample_size = round(alpha * n_points);           % parameter alpha
% sample_size = round(sqrt(n_points)); % sample size of a sampled set
target_ball_count = 30;                             % parameter M: the number of balls
k = 9;                                              % the number peak balls, category number CK
% target_ball_count = 10 * k;                             % parameter M: the number of balls
%--------------------------------------------------------------------------
% Generate dynamic folder name
folder_name = sprintf('L:/SKGB_Export_Marveen/ClusteringResults/N-BaIot %d %d %d %d _S %d', num_samples, alpha, target_ball_count, k, seedData.Seed);
% folder_name = sprintf('L:/SKGB_Export_Marveen/ClusteringResults/Twenty %d sqrt %d %d _S %d', num_samples, target_ball_count, k, seedData.Seed);
% folder_name = sprintf('L:/SKGB_Export_Marveen/ClusteringResults/Twenty %d sqrt 10ck %d _S %d', num_samples, k, seedData.Seed);
if ~exist(folder_name, 'dir')
    mkdir(folder_name);
end

all_peaks = [];
total_time_tic = tic;
time_Step2 = tic;
for i = 1:num_samples
   
    % Step1: Randomly sampling
    sampled_set = data(randperm(n_points, sample_size), :);
    % Step2: Find peaks of GB and merge them
    [ball_centers, ball_radius, points_per_ball] = GB_generation(sampled_set, target_ball_count);  % Generate GB for each sample set 
    median_radius = median(ball_radius);
    
%    density = calculateDensity(ball_radius, points_per_ball);    % Calculate density for each GB
    density = calculateDensity2(ball_radius, points_per_ball, median_radius);
    delta = calculateDelta(density, ball_centers);   % Calculate delta for each GB
    gamma = density .* delta;
    peaks = getTopKPeaks(gamma, ball_centers, k);
    all_peaks(end + 1:end + size(peaks, 1), :) = peaks;
    % TODO:  //得到每个peak的ball_radius和points_per_ball
   
end

total_time_Step2  = toc(time_Step2);
disp(['Time for Step2: ', num2str(total_time_Step2 ), ' s']);

% 对merged peaks去重
all_peaks = unique(all_peaks, 'rows');
dlmwrite(fullfile(folder_name, 'ori_all_peaks.txt'), all_peaks);
[num_All_RBC, ~] = size(all_peaks); % number of All_RBC
try
    % 对merged peaks再进行划分
    tic; 
    [all_peaks, ball_radius, points_per_ball] = GB_generation_2(all_peaks);
    time_Step3 = toc; 
    disp(['Time for Step3: ', num2str(time_Step3), ' s']);
    dlmwrite(fullfile(folder_name, 'all_peaks.txt'), all_peaks);
    [num_KM, ~] = size(all_peaks); % number of KM
    if size(all_peaks, 1) < k
        error('输入数据个数不足。'); 
    end
    % Step4: Construct the skeleton by DPeak-like on GB
    tic; 
%    [label_all_peaks, peaks, sorted_indices, nearest_labeled_points] = obtain_skeleton(all_peaks, ball_radius, points_per_ball, k);
    [label_all_peaks, peaks, nneigh, ordgamma] = obtain_skeleton2(all_peaks, ball_radius, points_per_ball, k);
    time_Step4 = toc; 
    disp(['Time for Step4: ', num2str(time_Step4), ' s']);
catch e
    disp(getReport(e, 'basic'));  
    return; 
end

% Step4: Calculate the min distance between all_peaks and all data points to assign labels
tic; 
labels_data = assignLabelsToData(label_all_peaks, all_peaks, data);
time_Step5 = toc; 
disp(['Time for Step5: ', num2str(time_Step5), ' s']);

total_time = toc(total_time_tic);
disp(['Total time for Clustering: ', sprintf('%.4f', total_time), ' s']);

%Saving labels to .txt labels
tic; 
% dlmwrite('generate_files/labels_data.txt', labels_data);  % 无法识别的字符，源码可能是二进制
writematrix(labels_data, fullfile(folder_name, 'labels.txt'));     % 人眼可识别数字
time_save = toc; 
disp(['Time for saving labels: ', num2str(time_save), ' s']);

fileID = fopen(fullfile(folder_name, 'log.txt'), 'w');
fprintf(fileID, folder_name);
fprintf(fileID, '\nTotal time: %.6f s\n', total_time);
fprintf(fileID, 'Time for Step1&2: %.6f s\n', total_time_Step2);
fprintf(fileID, 'Time for Step3: %.6f s\n', time_Step3);
fprintf(fileID, 'Time for Step4: %.6f s\n', time_Step4);
fprintf(fileID, 'Time for Step5: %.6f s\n', time_Step5);
fprintf(fileID, 'All_RBC: %d \n', num_All_RBC);
fprintf(fileID, 'KM: %d \n', num_KM);
fclose(fileID);

finishSound()