fig = figure;
ori_all_peaks = importdata('generate_files\SYN1_low_resolution\ori_all_peaks.txt'); 
ball_centers = all_peaks;
ball_labels = label_all_peaks;


% 科研配色双色
% colors = [
%    [37/255, 122/255, 182/255]; 
%   [252/255, 132/255, 13/255];  
% %  [144/255, 176/255, 63/255];     
% %  [93/255, 129/255, 183/255]; 
%  %  [177/255, 24/255, 45/255];    %红 
%  %  [36/255, 100/255, 171/255];   %蓝
% ];

% colors = [
%     [57/255, 81/255, 162/255];     
%     [114/255, 170/255, 207/255];       
%      [121/255, 66/255, 146/255];     % 紫色
% %     [68/255, 89/255, 155/255];      % 天蓝色    
%     [44/255, 143/255, 160/255];     % 深青色
%     [64/255, 169/255, 59/255];      % 绿色
%     [223/255, 68/255, 66/255];      % 红色
% %    [38/255, 70/255, 83/255];       % 深绿色
%     [233/255, 113/255, 36/255];     % 橙色
%  %   [239/255, 230/255, 68/255];     % 黄色  
%  %   [0.7,0.5,0.3];  % 卡其色
%     [0.5,0.5,0];    % 橄榄色
% ];

% colors = [
%     [131/255, 99/255, 159/255];     
%     [234/255, 120/255, 39/255];       
%     [194/255, 47/255, 47/255];     
%     [68/255, 153/255, 69/255];      
%     [31/255, 112/255, 169/255];     
% ];

% colors = [
% %             [1,0,0];        % 红色
% %           [0,1,0];        % 绿色
% %           [1,0,1];        % 品红色
% %           [0.5,0,0.5];    % 紫色
% %          [0,0,1];        % 蓝色
% %          [0,1,1];        % 青色
%           [1,0.5,0];      % 橙色 
% %           [0,0.5,0.5];    % 深青色
% %           [0.6,0.2,0];    % 棕色
% % %          [1,1,0];        % 黄色
% %           [0.4,0,0];      % 深红色
% %           [0,0,0.4];      % 深蓝色
% %          [0.5,0.5,0];    % 橄榄色
% %           [0,0,0];        % 黑色
% % %           [0.8,0.8,0.8];  % 灰色
% %           [0.2,0.2,0.2];  % 深灰色
% %           [0,0.5,0];      % 深绿色
% %          [0.7,0.3,0.5];  % 玫瑰色
% %           [0,0.3,0.6];    % 钢蓝色
% % %           [1,0.8,0.8];    % 粉红色
% % %           [0.8,1,0.8];    % 浅绿色
% % %           [0.8,0.8,1];    % 浅蓝色
% % %           [0.8,0.6,0];    % 金色
% % %           [0.9,0.9,0.9];  % 亮灰色
% %           [0.3,0.3,0];    % 深橄榄色
% %           [0.6,0,0.2];    % 深紫红色
% %           [0.3,0,0.5];    % 蓝紫色
% %           [0,0.3,0.3];    % 深海色
% %           [0.2,0.6,0.4];  % 深绿色
% %           [0.6,0.4,0.2];  % 土色
% %           [0.9,0.7,0];    % 柠檬色
% %           [0.4,0.6,0.2];  % 森林绿
% %           [0.2,0.4,0.6];  % 天蓝色
% %           [0.4,0.2,0.6];  % 堇紫色
% % %           [0.6,0.6,0.6];  % 中灰色
% %           [1,1,0.8];      % 乳白色
% %           [0.7,0.5,0.3];  % 卡其色
% % %           [0.8,0.4,0.7];  % 浅紫色
%           [0.5,0.3,0.7];  % 薰衣草色
% %           [0.7,0.7,0.5]; % 灰褐色
%     ];

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
      
% 先可视化原始数据点
% scatter(data(:, 1), data(:, 2), 8,'k', 'filled');  % 黑色填充

%plot(ori_all_peaks(:, 1), ori_all_peaks(:, 2), '.k');
plot(ori_all_peaks(:, 1), ori_all_peaks(:, 2), '.', 'Color', [0.5 0.5 0.5]);  % 灰色

%plot(data(:, 1), data(:, 2), '.', 'Color', [0.5 0.5 0.5]);  % 灰色
%plot(data(:, 1), data(:, 2), '.k');  
%hold on;  % 保持当前图像，以便添加更多内容
% 遍历data的每个点
% for i = 1:size(data, 1)
%     plot(data(i, 1), data(i, 2), '.', 'Color', colors(data_labels(i), :));
%     hold on;
% end

% 用圆圈表示颗粒球
% for i = 1:size(ball_centers, 1)
%     rectangle('Position', [ball_centers(i, 1) - ball_radius(i), ball_centers(i, 2) - ball_radius(i), 2*ball_radius(i), 2*ball_radius(i)], ...
%               'Curvature', [1, 1], ...
%               'EdgeColor', colors(ball_labels(i), :));
%        %       'EdgeColor', 'r');  % 设置为红色                    
% end
% hold on;

%用圆圈表示颗粒球
for i = 1:size(ball_centers, 1)
    expanded_radius = 3 * ball_radius(i);  % 扩大*倍的半径
    rectangle('Position', [ball_centers(i, 1) - expanded_radius, ball_centers(i, 2) - expanded_radius, 2 * expanded_radius, 2 * expanded_radius], ...
              'Curvature', [1, 1], ...
              'EdgeColor', colors(ball_labels(i), :));
end
hold on;

% 显示颗粒球中心
%scatter(ball_centers(:, 1), ball_centers(:, 2), 'r', 'filled');  % 红色填充
%首先，绘制ball_centers
for i = 1:size(ball_centers, 1)
 %   plot(ball_centers(i, 1), ball_centers(i, 2), '.', 'Color', colors(ball_labels(i), :),'MarkerSize', 10);
%     plot(ball_centers(i, 1), ball_centers(i, 2), '.r','MarkerSize', 10);
     scatter(ball_centers(i, 1), ball_centers(i, 2), 3, colors(ball_labels(i), :), 'filled','Marker','o');   % 默认18 % 'o', '+', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'
 %    scatter(ball_centers(i, 1), ball_centers(i, 2), 18, colors(ball_labels(i), :), 'filled');
%      scatter(ball_centers(i, 1), ball_centers(i, 2), 80, 'k', 'filled','Marker','p');
    hold on;  % 保持当前图形，以便在同一图上绘制其他形状
end


% 添加必要的视图和坐标轴设置
axis equal;  % 保持轴的比例一致

% SYN1专用
xlim([-0.55 0.6]);  
ylim([-0.5 0.5]); 

% SYN2专用
% xlim([0 600]);  
% ylim([0 800]); 

% SYN3专用
% xlim([0 320]);
% ylim([20 380]);

%twenty专用
% xlim([-2 18]);  
% ylim([-2 14]);

% Chainlink专用
% xlim([-1. 1.1]);  
% ylim([-1.1 2.1]);  
% zlim([-1.1 1.1]);

% 完成绘图
hold off;
% box on;


% % 调整图像大小
%figureHandle = gcf; % 获取当前图形的句柄
% % set(figureHandle, 'Position', [左 下 宽 高]);
%set(figureHandle, 'Position', [100, 100, 1000, 800]); % 例如: 800x600的图像大小

%set(gcf,'unit','normalized','position',[0.2,0.2,0.25,0.35])
% set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
set(gca, 'FontSize', 24);  % 设置刻度标签的字体大小为16

% print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\SKGB\可视化实验\SYN1\New density\GB_clustering\ori.png', '-dpng', '-r960');
%print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\论文\SDPeak2.0\可视化实验\SYN2\中位数sample\GB_clustering_3r.png', '-dpng', '-r960');

% Save the figure with the seed in the filename
figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_balls_%d.fig', num_samples, alpha, target_ball_count, k, seedData.Seed);
saveas(fig, figFilename);
figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_balls_%d.png', num_samples, alpha, target_ball_count, k, seedData.Seed);
print(figFilename, '-dpng', '-r400');
