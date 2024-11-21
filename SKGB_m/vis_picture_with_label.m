
%clc,clear
% 加载数据
%load('points.mat');
%points = load('data/banana/banana_data.txt');

% load('data/SYN1/points.mat');
%points = importdata('data/twenty_data.txt');
%points = importdata('L:\experiment\合成聚类数据集\3M2D5\data.txt');
%labels = load('L:\experiment\合成聚类数据集\3M2D5\test\label.txt');
points = importdata('data/twenty_data.txt');  

% points = importdata('data/Chainlink_data.txt');
labels = load('generate_files\Twenty\labels.txt');

% points = importdata('ball_centers.txt');
% points = all_peaks;
% labels = label_all_peaks;


% 科研配色双色
% colors = [
%    [37/255, 122/255, 182/255]; 
%    [252/255, 132/255, 13/255];     
%  % [144/255, 176/255, 63/255];     
%  % [93/255, 129/255, 183/255]; 
%   % [177/255, 24/255, 45/255];    %红 
%  %  [36/255, 100/255, 171/255];   %蓝
% ];

% 科研配色5色(高饱和)
% colors = [
%     [131/255, 99/255, 159/255];     
%     [234/255, 120/255, 39/255];       
%     [194/255, 47/255, 47/255];     
%     [68/255, 153/255, 69/255];      
%     [31/255, 112/255, 169/255];     
% ];

% % 科研配色7色
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

% colors = [[1,0,0];        % 红色
%           [0,1,0];        % 绿色
%           [1,0,1];        % 品红色
%           [0.5,0,0.5];    % 紫色
%          % [0,0,1];        % 蓝色
%          % [0,1,1];        % 青色
%           [1,0.5,0];      % 橙色 
%           [0,0.5,0.5];    % 深青色
%           [0.6,0.2,0];    % 棕色
% %          [1,1,0];        % 黄色
%           [0.4,0,0];      % 深红色
%           [0,0,0.4];      % 深蓝色
%          [0.5,0.5,0];    % 橄榄色
%           [0,0,0];        % 黑色
% %           [0.8,0.8,0.8];  % 灰色
%           [0.2,0.2,0.2];  % 深灰色
%           [0,0.5,0];      % 深绿色
%          [0.7,0.3,0.5];  % 玫瑰色
%           [0,0.3,0.6];    % 钢蓝色
% %           [1,0.8,0.8];    % 粉红色
% %           [0.8,1,0.8];    % 浅绿色
% %           [0.8,0.8,1];    % 浅蓝色
% %           [0.8,0.6,0];    % 金色
% %           [0.9,0.9,0.9];  % 亮灰色
%           [0.3,0.3,0];    % 深橄榄色
%           [0.6,0,0.2];    % 深紫红色
%           [0.3,0,0.5];    % 蓝紫色
%           [0,0.3,0.3];    % 深海色
%           [0.2,0.6,0.4];  % 深绿色
%           [0.6,0.4,0.2];  % 土色
%           [0.9,0.7,0];    % 柠檬色
%           [0.4,0.6,0.2];  % 森林绿
%           [0.2,0.4,0.6];  % 天蓝色
%           [0.4,0.2,0.6];  % 堇紫色
% %           [0.6,0.6,0.6];  % 中灰色
%           [1,1,0.8];      % 乳白色
%           [0.7,0.5,0.3];  % 卡其色
% %           [0.8,0.4,0.7];  % 浅紫色
%           [0.5,0.3,0.7];  % 薰衣草色
%           [0.7,0.7,0.5]]; % 灰褐色
      
color = [23/255, 21/255, 59/255];

        
% 预设一个figure
% figure;
% Create and maximize the figure
fig = figure;
% screenSize = get(0, 'ScreenSize');
% set(fig, 'Position', screenSize);

% 遍历所有的标签
unique_labels = unique(labels);  % 获取唯一的标签
for i = 1:length(unique_labels)
    % 提取当前标签对应的点
    current_points = points(labels == unique_labels(i), :);
    
    % 使用对应的颜色进行绘制
   plot(current_points(:, 1), current_points(:, 2), '.', 'Color', colors(i, :));
%    plot(current_points(:, 1), current_points(:, 2), '.', 'Color', color); % in same color
%     plot3(current_points(:,1),current_points(:,2),current_points(:,3),'.', 'Color', colors(i, :));
    
    hold on;  % 保持当前的图像，使得下一次绘制不会清除之前的内容
end

% 隐藏右侧和上方的轴线
% box on;
%grid on;
%twenty专用
xlim([-2 18]);  
ylim([-2 14]);

%axis equal; % 设置坐标轴比例相同
% set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
set(gca, 'FontSize', 26);  % 设置刻度标签的字体大小为16
% view(3);
% Display the figure in full screen
% set(gcf, 'WindowState', 'maximized');

%view(3);
% 保存图像
%print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\SKGB\可视化实验\Twenty\New density\clustering.png', '-dpng', '-r960');
%print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\论文\SDPeak2.0\可视化实验\Chainlink\中位数sample\clustering.png', '-dpng', '-r960');