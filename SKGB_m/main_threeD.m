%% Run SKGB on Chainlink and plot

%% Run SKGB
clear;clc;
data = importdata('data/Chainlink_data.txt');  

% ------------------------Parameters---------------------------------------
num_samples = 100;           % parameter S: number of sample sets,
alpha = 0.1;               % parameter alpha
target_ball_count = 50;	% parameter M: the number of balls
k = 2;                      % the number peak balls, category number CK
%--------------------------------------------------------------------------
%% Shuffle the seed based on the current time
rng(38302984);
% rng('shuffle');
% Record the current seed and the random number generator settings
seedData = rng;
% Display the seed
disp(['Seed: ', num2str(seedData.Seed)]);
% Save the seed to a file
save('generate_files/Chainlink_low_resolution/seedData.mat', 'seedData');

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
dlmwrite('generate_files/Chainlink_low_resolution/ori_all_peaks.txt', all_peaks);
try
    % 对merged peaks再进行划分
    tic; 
    [all_peaks, ball_radius, points_per_ball] = GB_generation_2(all_peaks);
    time_Step3 = toc; 
    disp(['Time for Step3: ', num2str(time_Step3), ' s']);
    dlmwrite('generate_files/Chainlink_low_resolution/all_peaks.txt', all_peaks);
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
writematrix(labels, 'generate_files/Chainlink_low_resolution/Chainlink_labels.txt');     % 人眼可识别数字
time_save = toc; 
disp(['Time for saving labels: ', num2str(time_save), ' s']);

%% Plot params
% 设置刻度标签的字体大小为fontSize
fontSize = 26;

% Rotation angle for figures
% rotationAngle = [-85, 7];
rotationAngle = [-100, 17];

% Axises range
xRange = [-1.4 1.2];
yRange = [-1.3 2.3];
zRange = [-1.3 1.1];

%% Plot 1 Original points
plot1_tic = tic;

colorBlackBlue = [23/255, 21/255, 59/255]; % BlackBlue
      
% Create and maximize the figure
fig = figure;
% screenSize = get(0, 'ScreenSize');
% set(fig, 'Position', screenSize);
% set(gcf, 'Position', [100, 100, 800, 600]);

plot3(data(:,1), data(:,2), data(:,3), 'o', 'MarkerSize', 5, 'MarkerFaceColor', colorBlackBlue, 'MarkerEdgeColor', 'w');
%     hold on;  % 保持当前的图像，使得下一次绘制不会清除之前的内容

% Chainlink专用
xlim(xRange);
ylim(yRange);
zlim(zRange);

% 隐藏右侧和上方的轴线
% box on;
grid on;

%axis equal; % 设置坐标轴比例相同
% set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
set(gca, 'FontSize', fontSize);  % 设置刻度标签的字体大小为16
view(rotationAngle);
% Display the figure in full screen
% set(gcf, 'WindowState', 'maximized');

% Save the figure with the seed in the filename
figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_data_%d.fig', num_samples, alpha, target_ball_count, seedData.Seed);
saveas(fig, figFilename);
figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_data_%d.png', num_samples, alpha, target_ball_count, seedData.Seed);
% print(figFilename, '-dpng', '-r960');
print(figFilename, '-dpng', '-r400');

time_plot1 = toc(plot1_tic); 
disp(['Time for plotting original points: ', num2str(time_plot1), ' s']);

%% Plot 2 Labeled points
plot2_tic = tic;
% colors = [%[1,0,0];        % 红色
% %           [0,1,0];        % 绿色
% %           [1,0,1];        % 品红色
% %           [0.5,0,0.5];    % 紫色
% %          % [0,0,1];        % 蓝色
% %          [0,1,1];        % 青色
% %           [1,0.5,0];      % 橙色 
% %           [0,0.5,0.5];    % 深青色
% %           [0.6,0.2,0];    % 棕色
% %    %       [1,1,0];        % 黄色
% %           [0.4,0,0];      % 深红色
% %           [0,0,0.4];      % 深蓝色
% %    %       [0.5,0.5,0];    % 橄榄色
% %           [0,0,0];        % 黑色
% %           [0.8,0.8,0.8];  % 灰色
% %           [0.2,0.2,0.2];  % 深灰色
% %           [0,0.5,0];      % 深绿色
% %   %        [0.7,0.3,0.5];  % 玫瑰色
% %           [0,0.3,0.6];    % 钢蓝色
% %           [1,0.8,0.8];    % 粉红色
% %           [0.8,1,0.8];    % 浅绿色
% %           [0.8,0.8,1];    % 浅蓝色
% %           [0.8,0.6,0];    % 金色
% %           [0.9,0.9,0.9];  % 亮灰色
% %           [0.3,0.3,0];    % 深橄榄色
% %           [0.6,0,0.2];    % 深紫红色
% %           [0.3,0,0.5];    % 蓝紫色
% %           [0,0.3,0.3];    % 深海色
% %           [0.2,0.6,0.4];  % 深绿色
% %           [0.6,0.4,0.2];  % 土色
% %           [0.9,0.7,0];    % 柠檬色
% %           [0.4,0.6,0.2];  % 森林绿
%           [0.2,0.4,0.6];  % 天蓝色
%           [0.4,0.2,0.6];  % 堇紫色
%           [0.6,0.6,0.6];  % 中灰色
%           [1,1,0.8];      % 乳白色
%           [0.7,0.5,0.3];  % 卡其色
%           [0.8,0.4,0.7];  % 浅紫色
%           [0.5,0.3,0.7];  % 薰衣草色
%           [0.7,0.7,0.5]]; % 灰褐色
      
% colors = [
% %   [37/255, 122/255, 182/255]; 
% %  [252/255, 132/255, 13/255];     
% %   [93/255, 129/255, 183/255]; 
%    [36/255, 100/255, 171/255];   %蓝
%   [144/255, 176/255, 63/255];    
%    [177/255, 24/255, 45/255];    %红 
% ];

colors = [
%   [37/255, 122/255, 182/255]; 
%  [252/255, 132/255, 13/255];     
%   [93/255, 129/255, 183/255]; 
% Color Link: https://colorhunt.co/palette/667bc6fdffd2ffb4c2da7297
    [102/255, 123/255, 198/255]; % Blue
    [255/255, 180/255, 194/255]; % Pink
   [36/255, 100/255, 171/255];   %蓝
  [144/255, 176/255, 63/255];    
   [177/255, 24/255, 45/255];    %红 
];

fig = figure;

% 遍历所有的标签
unique_labels = unique(labels);  % 获取唯一的标签
for i = 1:length(unique_labels)
    % 提取当前标签对应的点
    current_points = data(labels == unique_labels(i), :);
    
    % 使用对应的颜色进行绘制
%     plot3(current_points(:,1),current_points(:,2),current_points(:,3),'.', 'Color', colors(i, :));
    plot3(current_points(:,1),current_points(:,2),current_points(:,3),'o', 'MarkerSize', 5, 'MarkerFaceColor', colors(i, :), 'MarkerEdgeColor', 'k');
    
    hold on;  % 保持当前的图像，使得下一次绘制不会清除之前的内容
end

% Chainlink专用
xlim(xRange);
ylim(yRange);
zlim(zRange);

% 隐藏右侧和上方的轴线
% box on;
grid on;

set(gca, 'FontSize', fontSize);
view(rotationAngle);

% Save the figure with the seed in the filename
figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_points_%d.fig', num_samples, alpha, target_ball_count, seedData.Seed);
saveas(fig, figFilename);
figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_points_%d.png', num_samples, alpha, target_ball_count, seedData.Seed);
print(figFilename, '-dpng', '-r400');

time_plot2 = toc(plot2_tic); 
disp(['Time for plotting labeled points: ', num2str(time_plot2), ' s']);

%% Plot 3 Balls
plot3_tic = tic;

fig = figure;

ori_all_peaks = importdata('generate_files/Chainlink_low_resolution/ori_all_peaks.txt'); % 假设这个文件包含了三列数据，分别对应 X, Y, Z 坐标
ball_centers = all_peaks; % 假设 all_peaks 也是三列数据，对应球心的 X, Y, Z 坐标
ball_labels = label_all_peaks;

% 可视化原始数据点
plot3(ori_all_peaks(:, 1), ori_all_peaks(:, 2), ori_all_peaks(:, 3), '.k'); % 使用 plot3 绘制三维点
hold on;

% 用不同颜色和标记绘制球心
for i = 1:size(ball_centers, 1)
    scatter3(ball_centers(i, 1), ball_centers(i, 2), ball_centers(i, 3), 25, ...
             colors(ball_labels(i), :), 'filled', 'Marker', 'p');
    hold on;  % 保持当前图形，以便在同一图上绘制其他形状
end

% 用线框绘制球体轮廓
for i = 1:size(ball_centers, 1)
    % 计算球的网格数据
    [X, Y, Z] = sphere;
    % 缩放并平移网格数据以匹配每个球体的位置和大小
%     X = X * ball_radius(i) + ball_centers(i, 1);
%     Y = Y * ball_radius(i) + ball_centers(i, 2);
%     Z = Z * ball_radius(i) + ball_centers(i, 3);
    
    % Scale up balls' radii
    ScalePercentage = 3.5;
    X = X * ball_radius(i) * ScalePercentage + ball_centers(i, 1);
    Y = Y * ball_radius(i) * ScalePercentage + ball_centers(i, 2);
    Z = Z * ball_radius(i) * ScalePercentage + ball_centers(i, 3);
    % 绘制球体轮廓
    mesh(X, Y, Z, 'EdgeColor', colors(ball_labels(i), :), 'FaceColor', 'none', 'LineWidth', 0.1,'EdgeAlpha', 1);

end

% 显示颗粒球中心
plot3(ball_centers(:, 1), ball_centers(:, 2), ball_centers(:, 3),'.r','MarkerSize', 10);
% 用不同颜色绘制球心
% 用不同颜色和标记绘制球心
for i = 1:size(ball_centers, 1)
    scatter3(ball_centers(i, 1), ball_centers(i, 2), ball_centers(i, 3), 18, ...
             colors(ball_labels(i), :), 'filled', 'Marker', 'p');
    hold on;  % 保持当前图形，以便在同一图上绘制其他形状
end

% 设置视图和坐标轴
% Chainlink专用
xlim(xRange);
ylim(yRange);
zlim(zRange);

% 完成绘图
hold off;
% box on;
grid on;
set(gca, 'FontSize', fontSize);
view(rotationAngle);

% Save the figure with the seed in the filename
figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_balls_%d.fig', num_samples, alpha, target_ball_count, seedData.Seed);
saveas(fig, figFilename);
figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_balls_%d.png', num_samples, alpha, target_ball_count, seedData.Seed);
print(figFilename, '-dpng', '-r400');

time_plot3 = toc(plot3_tic); 
disp(['Time for plotting balls: ', num2str(time_plot3), ' s']);

%% Plot 4 Skeleton
plot4_tic = tic;

fig = figure;

sample_centers = all_peaks;

% 1.为每个点找到唯一的一个父节点，并可视化出来
m = length(ordgamma);
%m = length(sorted_indices);
peaks_and_nneighs = zeros(m,2);
index_peaks_reshape = reshape(ordgamma',m,1);
%index_peaks_reshape = sorted_indices;
%index_centers_reshape = reshape(ordrho',m,1);              %注意以ordgamma'和ordrho'作为第一列的区别(仅仅是以颜色深浅标示不同密度大小时有影响？)
nneigh_reshape = reshape(nneigh',m,1);              %寻找这k*s个峰值点的最近邻中比自己密度大的点所对应的索引并reshape成一列，且放在第二列
%nneigh_reshape = nearest_labeled_points;
zuijinling = nneigh_reshape(index_peaks_reshape);     
peaks_and_nneighs(:,1) = index_peaks_reshape;
peaks_and_nneighs(:,2) = zuijinling;
% peaks_and_nneighs(peaks_and_nneighs(:, 1) == 840,2) = 0 ;
% peaks_and_nneighs(peaks_and_nneighs(:, 1) == 581,2) = 104 ;


% Color Link: https://colorhunt.co/palette/667bc6fdffd2ffb4c2da7297
% colors = [
%     [102/255, 123/255, 198/255]; % Blue
%     [255/255, 180/255, 194/255]; % Pink
% ];

% 树形骨架图
a_color = 230/length(peaks_and_nneighs); 
b_color = 230/length(peaks_and_nneighs); 
c_color = (255-230)/length(peaks_and_nneighs);

% temp_colors = colors .* 255 ./ length(peaks_and_nneighs);

% 1.对应的
% 如果是3D的，那么length(peaks):length(peaks_and_nneighs)，不需要+1(用obtain_skeleton函数得到的骨架也不需要+1)
for i = length(peaks):length(peaks_and_nneighs)     %不从一开始，避免每个类的聚类中心指向其他类
   if(peaks_and_nneighs(i,2)) ~= 0 
    %3d
       line([sample_centers(peaks_and_nneighs(i,1)), sample_centers(peaks_and_nneighs(i,2))],...
       [sample_centers(peaks_and_nneighs(i,1),2), sample_centers(peaks_and_nneighs(i,2),2)],...
       [sample_centers(peaks_and_nneighs(i,1),3), sample_centers(peaks_and_nneighs(i,2),3)],...
       'color',[0 + a_color * i , 0 + b_color * i , 255 - c_color * i]./255);

    end
end

hold on;
% plot(peaks(:,1),peaks(:,2),'pr','LineWidth',1.25);     %聚类中心
%plot(peaks(:,1),peaks(:,2),'pr','LineWidth',1);     %聚类中心
plot3(peaks(:,1),peaks(:,2),peaks(:,3),'pr','LineWidth', 1.25);     %聚类中心

% Chainlink专用
xlim(xRange);
ylim(yRange);
zlim(zRange);

% box on;
grid on;
set(gca, 'FontSize', fontSize);
view(rotationAngle);

figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_skeleton_%d.fig', num_samples, alpha, target_ball_count, seedData.Seed);
saveas(fig, figFilename);

figFilename = sprintf('generate_files/Chainlink_low_resolution/%d_%.3f_%d_Chainlink_skeleton_%d.png', num_samples, alpha, target_ball_count, seedData.Seed);
print(figFilename, '-dpng', '-r400');

time_plot4 = toc(plot4_tic); 
disp(['Time for plotting skeleton: ', num2str(time_plot4), ' s']);
