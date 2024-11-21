clc,clear
% csvFilePath = 'L:\experiment\合成聚类数据集\N-BaIoT Dataset\whole_data.csv';
% 
% tic;  
% % 读取CSV文件，从第二行开始
% opts = detectImportOptions(csvFilePath);
% opts.DataLines = [2, Inf]; % 从第二行开始读取，直到文件末尾
% dataTable = readtable(csvFilePath, opts);
% 
% % 将表格转换为数组
% dataArray = table2array(dataTable);
% data = table2array(dataTable);
% rng(123);
% n = 6000000; % 需要抽取的行数
% data = datasample(dataArray, n, 'Replace', false);
% 
% time_readdata = toc;
% disp(['Time for loading data: ', num2str(time_readdata), ' s']);

% data = importdata('data/SYN2/points.mat');  
%data = importdata('L:\experiment\合成聚类数据集\train.csv\PCA_data.txt');  
%data = importdata('data/segment_data.txt');
%data = importdata('data/covertype_data.txt');
%data = importdata('data/Dry_Bean_Dataset.txt');
%data = importdata('data/ConfLongDemoJSI164860.txt');
%data = importdata('data/twenty_data.txt');
%data = importdata('L:\experiment\合成聚类数据集\kdd_data\标准化数据\kdd1999_only_data.txt');
%data = importdata('L:\experiment\合成聚类数据集\3M2D5\data.txt');
data = importdata('data/Chainlink_data.txt');  

% ------------------------Parameters---------------------------------------
num_samples = 50;                                   % parameter S: number of sample sets,
sample_size = round(0.1 * size(data, 1));           % parameter alpha
target_ball_count = 10;                             % parameter M: the number of balls
k = 2;                                              % the number peak balls, category number CK
%--------------------------------------------------------------------------

% 自适应参数
%[num_samples, sample_size, target_ball_count] = Adapative_parameters(data, k);                                

% rng(123); % 实验所用到的种子
% rng(123); 

% Shuffle the seed based on the current time
rng('shuffle');
% Record the current seed and the random number generator settings
seedData = rng;
% Display the seed
disp(['Seed: ', num2str(seedData.Seed)]);
% Save the seed to a file
save('generate_files/seedData.mat', 'seedData');

all_peaks = [];
total_time_tic = tic;
time_Step2 = tic;
for i = 1:num_samples
   
    % Step1: Randomly sampling
    sampled_set = data(randperm(size(data, 1), sample_size), :);
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
dlmwrite('generate_files/ori_all_peaks.txt', all_peaks);
try
    % 对merged peaks再进行划分
    tic; 
    [all_peaks, ball_radius, points_per_ball] = GB_generation_2(all_peaks);
    time_Step3 = toc; 
    disp(['Time for Step3: ', num2str(time_Step3), ' s']);
    dlmwrite('generate_files/all_peaks.txt', all_peaks);
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
writematrix(labels_data, 'generate_files/Chainlink_labels.txt');     % 人眼可识别数字
time_save = toc; 
disp(['Time for saving labels: ', num2str(time_save), ' s']);
