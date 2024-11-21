%% Run SKGB on 2D datasets and plot

%% Run SKGB
clear;clc;
% data = importdata('data\twenty_data.txt');
data = importdata('data\SYN1\points.mat');

% ------------------------Parameters---------------------------------------
num_samples = 20;           % parameter S: number of sample sets,
alpha = 0.1;               % parameter alpha
target_ball_count = 20;	% parameter M: the number of balls
k = 5;                      % the number peak balls, category number CK
%--------------------------------------------------------------------------
%% Shuffle the seed based on the current time
result_dir = 'E:\Academic_Writing\Clustering\SKGB\SKGB_m\generate_files\\SYN1_low_resolution';
% Create directories if they do not exist
if ~exist(result_dir, 'dir')
    mkdir(result_dir);
end

rng(54508909);
% rng('shuffle');
% Record the current seed and the random number generator settings
seedData = rng;
% Display the seed
disp(['Seed: ', num2str(seedData.Seed)]);
% Save the seed to a file
save(fullfile(result_dir, 'seedData.mat'), 'seedData');

%% Plot params
% 设置刻度标签的字体大小为fontSize
fontSize = 24;

% Axises range
% Twenty
% xRange = [-2 18];
% yRange = [-2 14];

% SYN1专用
xRange = [-0.55 0.6];
yRange = [-0.5 0.5];

% SYN3专用
% xRange = [0 320];
% yRange = [20 380];

%% SKGB
sample_size = round(alpha * size(data, 1));
all_peaks = [];
total_time_tic = tic;
time_Step2 = tic;
for i = 1:num_samples
   
    % Step1: Randomly sampling
    sampled_set = data(randperm(size(data, 1), sample_size), :);
    % Step2: Find peaks of GB and merge them
    [ball_centers, ball_radius, points_per_ball] = GB_generation(sampled_set, target_ball_count);  % Generate GB for each sample set 
    median_radius = median(ball_radius);
    
    density = calculateDensity2(ball_radius, points_per_ball, median_radius);
    delta = calculateDelta(density, ball_centers);   % Calculate delta for each GB
    gamma = density .* delta;
    peaks = getTopKPeaks(gamma, ball_centers, k);
    all_peaks(end + 1:end + size(peaks, 1), :) = peaks;
   
end

total_time_Step2  = toc(time_Step2);
disp(['Time for Step2: ', num2str(total_time_Step2 ), ' s']);

% 对merged peaks去重
all_peaks = unique(all_peaks, 'rows');
dlmwrite(fullfile(result_dir, 'ori_all_peaks.txt'), all_peaks);
try
    % 对merged peaks再进行划分
    tic; 
    [all_peaks, ball_radius, points_per_ball] = GB_generation_2(all_peaks);
    time_Step3 = toc; 
    disp(['Time for Step3: ', num2str(time_Step3), ' s']);
    dlmwrite(fullfile(result_dir, 'all_peaks.txt'), all_peaks);
    if size(all_peaks, 1) < k
        error('输入数据个数不足。'); 
    end
    % Step4: Construct the skeleton by DPeak-like on GB
    tic; 
    [label_all_peaks, peaks, nneigh, ordgamma] = obtain_skeleton2(all_peaks, ball_radius, points_per_ball, k);
    time_Step4 = toc; 
    disp(['Time for Step4: ', num2str(time_Step4), ' s']);
catch e
    disp(getReport(e, 'basic'));  
    return; 
end

% Step4: Calculate the min distance between all_peaks and all data points to assign labels
tic; 
labels = assignLabelsToData(label_all_peaks, all_peaks, data);
time_Step5 = toc; 
disp(['Time for Step5: ', num2str(time_Step5), ' s']);

total_time = toc(total_time_tic);
disp(['Total time for Clustering: ', sprintf('%.4f', total_time), ' s']);

%Saving labels to .txt labels
tic;
writematrix(labels, fullfile(result_dir, 'labels.txt'));
time_save = toc;
disp(['Time for saving labels: ', num2str(time_save), ' s']);

%% Plot 1 Original points
plot1_tic = tic;
colorBlackBlue = [23/255, 21/255, 59/255];
fig = figure;

plot(data(:, 1), data(:, 2), '.', 'Color', colorBlackBlue); % in same color

box on;
axis equal;  % 保持轴的比例一致
%grid on;
xlim(xRange);
ylim(yRange);
set(gca, 'FontSize', fontSize);

% Save the figure with the seed in the filename
figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_data_%d.fig', num_samples, alpha, target_ball_count, k, seedData.Seed);
saveas(fig, figFilename);
figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_data_%d.png', num_samples, alpha, target_ball_count, k, seedData.Seed);
print(figFilename, '-dpng', '-r400'); % r960

time_plot1 = toc(plot1_tic); 
disp(['Time for plotting original points: ', num2str(time_plot1), ' s']);

%% Plot 2 Labeled points
plot2_tic = tic;

% Colors for SYN1
colors = [
            [1,0,0];        % 红色
         [0,0,1];        % 蓝色
          [1,0.5,0];      % 橙色 
          [0.4,0.6,0.2];  % 森林绿
          [0.5,0.3,0.7];  % 薰衣草色
    ];

% Colors for Twenty
% colors = [
%             [1,0,0];        % 红色
%           [0,1,0];        % 绿色
% %           [1,0,1];        % 品红色
%           [0.5,0,0.5];    % 紫色
%          [0,0,1];        % 蓝色
% %          [0,1,1];        % 青色
%           [1,0.5,0];      % 橙色 
% %           [0,0.5,0.5];    % 深青色
%           [0.6,0.2,0];    % 棕色
%          [1,1,0];        % 黄色
% %           [0.4,0,0];      % 深红色
% %           [0,0,0.4];      % 深蓝色
%          [0.5,0.5,0];    % 橄榄色
% %           [0,0,0];        % 黑色
% % %           [0.8,0.8,0.8];  % 灰色
%           [0.2,0.2,0.2];  % 深灰色
% %           [0,0.5,0];      % 深绿色
%          [0.7,0.3,0.5];  % 玫瑰色
%           [0,0.3,0.6];    % 钢蓝色
% % %           [1,0.8,0.8];    % 粉红色
% %           [0.8,1,0.8];    % 浅绿色
% %           [0.8,0.8,1];    % 浅蓝色
% %           [0.8,0.6,0];    % 金色
% % %           [0.9,0.9,0.9];  % 亮灰色
% %           [0.3,0.3,0];    % 深橄榄色
%           [0.6,0,0.2];    % 深紫红色
%           [0.3,0,0.5];    % 蓝紫色
% %           [0,0.3,0.3];    % 深海色
% %           [0.2,0.6,0.4];  % 深绿色
% %           [0.6,0.4,0.2];  % 土色
%           [0.9,0.7,0];    % 柠檬色
%           [0.4,0.6,0.2];  % 森林绿
%           [0.2,0.4,0.6];  % 天蓝色
%           [0.4,0.2,0.6];  % 堇紫色
% % %           [0.6,0.6,0.6];  % 中灰色
% %           [1,1,0.8];      % 乳白色
%           [0.7,0.5,0.3];  % 卡其色
% % %           [0.8,0.4,0.7];  % 浅紫色
%           [0.5,0.3,0.7];  % 薰衣草色
%           [0.7,0.7,0.5]; % 灰褐色
%     ];


% colors = [
%             [1,0,0];        % 红色
%           [0,1,0];        % 绿色
% %           [1,0,1];        % 品红色
%           [0.5,0,0.5];    % 紫色
%          [0,0,1];        % 蓝色
% %          [0,1,1];        % 青色
%           [1,0.5,0];      % 橙色 
% %           [0,0.5,0.5];    % 深青色
%           [0.6,0.2,0];    % 棕色
%          [1,1,0];        % 黄色
% %           [0.4,0,0];      % 深红色
% %           [0,0,0.4];      % 深蓝色
%          [0.5,0.5,0];    % 橄榄色
% %           [0,0,0];        % 黑色
% % %           [0.8,0.8,0.8];  % 灰色
%           [0.2,0.2,0.2];  % 深灰色
% %           [0,0.5,0];      % 深绿色
%          [0.7,0.3,0.5];  % 玫瑰色
%           [0,0.3,0.6];    % 钢蓝色
% % %           [1,0.8,0.8];    % 粉红色
% %           [0.8,1,0.8];    % 浅绿色
% %           [0.8,0.8,1];    % 浅蓝色
% %           [0.8,0.6,0];    % 金色
% % %           [0.9,0.9,0.9];  % 亮灰色
% %           [0.3,0.3,0];    % 深橄榄色
%           [0.6,0,0.2];    % 深紫红色
%           [0.3,0,0.5];    % 蓝紫色
% %           [0,0.3,0.3];    % 深海色
% %           [0.2,0.6,0.4];  % 深绿色
% %           [0.6,0.4,0.2];  % 土色
%           [0.9,0.7,0];    % 柠檬色
%           [0.4,0.6,0.2];  % 森林绿
%           [0.2,0.4,0.6];  % 天蓝色
%           [0.4,0.2,0.6];  % 堇紫色
% % %           [0.6,0.6,0.6];  % 中灰色
% %           [1,1,0.8];      % 乳白色
%           [0.7,0.5,0.3];  % 卡其色
% % %           [0.8,0.4,0.7];  % 浅紫色
%           [0.5,0.3,0.7];  % 薰衣草色
%           [0.7,0.7,0.5]; % 灰褐色
%     ];
      
% colors = [
% %   [37/255, 122/255, 182/255]; 
% %  [252/255, 132/255, 13/255];     
% %   [93/255, 129/255, 183/255]; 
%    [36/255, 100/255, 171/255];   %蓝
%   [144/255, 176/255, 63/255];    
%    [177/255, 24/255, 45/255];    %红 
% ];

% colors = [
% %   [37/255, 122/255, 182/255]; 
% %  [252/255, 132/255, 13/255];     
% %   [93/255, 129/255, 183/255]; 
% % Color Link: https://colorhunt.co/palette/667bc6fdffd2ffb4c2da7297
%     [102/255, 123/255, 198/255]; % Blue
%     [255/255, 180/255, 194/255]; % Pink
%    [36/255, 100/255, 171/255];   %蓝
%   [144/255, 176/255, 63/255];    
%    [177/255, 24/255, 45/255];    %红 
% ];

% % Colors for SYN1
% colors = [
% % https://colorhunt.co/palette/f38181fce38aeaffd095e1d3
% 	[243/255, 129/255, 129/255];
% 	[252/255, 227/255, 138/255];
% 	[234/255, 255/255, 208/255];
% 	[149/255, 225/255, 211/255];
% % https://colorhunt.co/palette/b1b2ffaac4ffd2daffeef1ff
% 	[177/255, 178/255, 255/255];
%     ];


fig = figure;

% 遍历所有的标签
unique_labels = unique(labels);  % 获取唯一的标签
for i = 1:length(unique_labels)
    % 提取当前标签对应的点
    current_points = data(labels == unique_labels(i), :);
    
    % 使用对应的颜色进行绘制
    plot(current_points(:, 1), current_points(:, 2), '.', 'Color', colors(i, :));
    hold on;  % 保持当前的图像，使得下一次绘制不会清除之前的内容
end

axis equal;  % 保持轴的比例一致
xlim(xRange);
ylim(yRange);
box on;
set(gca, 'FontSize', fontSize);

% Save the figure with the seed in the filename
figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_points_%d.fig', num_samples, alpha, target_ball_count, k, seedData.Seed);
saveas(fig, figFilename);
figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_points_%d.png', num_samples, alpha, target_ball_count, k, seedData.Seed);
print(figFilename, '-dpng', '-r400');

time_plot2 = toc(plot2_tic); 
disp(['Time for plotting labeled points: ', num2str(time_plot2), ' s']);

%% Plot 3 Balls
% plot3_tic = tic;
% ori_all_peaks = importdata('generate_files\Twenty\ori_all_peaks.txt'); 
% ball_labels = label_all_peaks;
% 
% fig = figure;
% % 先可视化原始数据点
% %scatter(sampled_set(:, 1), sampled_set(:, 2), 8,'k', 'filled');  % 黑色填充
% % plot(sampled_set(:, 1), sampled_set(:, 2), '.', 'Color', [0.5 0.5 0.5]);  % 灰色
% % plot(data(:, 1), data(:, 2), '.', 'Color', colorBlackBlue);
% plot(ori_all_peaks(:, 1), ori_all_peaks(:, 2), '.', 'Color', colorBlackBlue);
% 
% % 用圆圈表示颗粒球
% for i = 1:size(ball_centers, 1)
%     expanded_radius = 3 * ball_radius(i);  % 扩大*倍的半径
%     rectangle('Position', [ball_centers(i, 1) - expanded_radius, ball_centers(i, 2) - expanded_radius, 2 * expanded_radius, 2 * expanded_radius], ...
%               'Curvature', [1, 1], ...
%               'EdgeColor', colors(ball_labels(i), :));
% end
% hold on;
% 
% % 显示颗粒球中心
% for i = 1:size(ball_centers, 1)
% %      plot(ball_centers(i, 1), ball_centers(i, 2), '.r','MarkerSize', 10);
%  %    plot(ball_centers(i, 1), ball_centers(i, 2), '.r','MarkerSize', 10);
%     scatter(ball_centers(i, 1), ball_centers(i, 2), 3, colors(ball_labels(i), :), 'filled','Marker','o');    % 'o', '+', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'
%     hold on;  % 保持当前图形，以便在同一图上绘制其他形状
% end
% 
% xlim(xRange);
% ylim(yRange);
% hold off;
% % box on;
% set(gca, 'FontSize', fontSize);
% 
% % Save the figure with the seed in the filename
% figFilename = sprintf('generate_files/Twenty/%d_%.3f_%d_Twenty_balls_%d.fig', num_samples, alpha, target_ball_count, seedData.Seed);
% saveas(fig, figFilename);
% figFilename = sprintf('generate_files/Twenty/%d_%.3f_%d_Twenty_balls_%d.png', num_samples, alpha, target_ball_count, seedData.Seed);
% print(figFilename, '-dpng', '-r960');
% 
% time_plot3 = toc(plot3_tic); 
% disp(['Time for plotting balls: ', num2str(time_plot3), ' s']);

%% Plot 4 Skeleton
% plot4_tic = tic;
% 
% fig = figure;
% 
% sample_centers = all_peaks;
% 
% % 1.为每个点找到唯一的一个父节点，并可视化出来
% m = length(ordgamma);
% %m = length(sorted_indices);
% peaks_and_nneighs = zeros(m,2);
% index_peaks_reshape = reshape(ordgamma',m,1);
% %index_peaks_reshape = sorted_indices;
% %index_centers_reshape = reshape(ordrho',m,1);              %注意以ordgamma'和ordrho'作为第一列的区别(仅仅是以颜色深浅标示不同密度大小时有影响？)
% nneigh_reshape = reshape(nneigh',m,1);              %寻找这k*s个峰值点的最近邻中比自己密度大的点所对应的索引并reshape成一列，且放在第二列
% %nneigh_reshape = nearest_labeled_points;
% zuijinling = nneigh_reshape(index_peaks_reshape);     
% peaks_and_nneighs(:,1) = index_peaks_reshape;
% peaks_and_nneighs(:,2) = zuijinling;
% % peaks_and_nneighs(peaks_and_nneighs(:, 1) == 840,2) = 0 ;
% % peaks_and_nneighs(peaks_and_nneighs(:, 1) == 581,2) = 104 ;
% 
% 
% % Color Link: https://colorhunt.co/palette/667bc6fdffd2ffb4c2da7297
% % colors = [
% %     [102/255, 123/255, 198/255]; % Blue
% %     [255/255, 180/255, 194/255]; % Pink
% % ];
% 
% % 树形骨架图
% a_color = 230/length(peaks_and_nneighs); 
% b_color = 230/length(peaks_and_nneighs); 
% c_color = (255-230)/length(peaks_and_nneighs);
% 
% % temp_colors = colors .* 255 ./ length(peaks_and_nneighs);
% 
% % 1.对应的
% % 如果是3D的，那么length(peaks):length(peaks_and_nneighs)，不需要+1(用obtain_skeleton函数得到的骨架也不需要+1)
% for i = length(peaks):length(peaks_and_nneighs)     %不从一开始，避免每个类的聚类中心指向其他类
%    if(peaks_and_nneighs(i,2)) ~= 0 
%     %3d
%        line([sample_centers(peaks_and_nneighs(i,1)), sample_centers(peaks_and_nneighs(i,2))],...
%        [sample_centers(peaks_and_nneighs(i,1),2), sample_centers(peaks_and_nneighs(i,2),2)],...
%        [sample_centers(peaks_and_nneighs(i,1),3), sample_centers(peaks_and_nneighs(i,2),3)],...
%        'color',[0 + a_color * i , 0 + b_color * i , 255 - c_color * i]./255);
% 
%     end
% end
% 
% hold on;
% % plot(peaks(:,1),peaks(:,2),'pr','LineWidth',1.25);     %聚类中心
% xlim(xRange);
% ylim(yRange);
% % box on;
% set(gca, 'FontSize', fontSize);
% 
% figFilename = sprintf('generate_files/Twenty/%d_%.3f_%d_Twenty_skeleton_%d.fig', num_samples, alpha, target_ball_count, seedData.Seed);
% saveas(fig, figFilename);
% 
% figFilename = sprintf('generate_files/Twenty/%d_%.3f_%d_Twenty_skeleton_%d.png', num_samples, alpha, target_ball_count, seedData.Seed);
% print(figFilename, '-dpng', '-r960');
% 
% time_plot4 = toc(plot4_tic); 
% disp(['Time for plotting skeleton: ', num2str(time_plot4), ' s']);
