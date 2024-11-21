% figure
% Create and maximize the figure
fig = figure;
screenSize = get(0, 'ScreenSize');
set(fig, 'Position', screenSize);

ori_all_peaks = importdata('generate_files/ori_all_peaks.txt'); % 假设这个文件包含了三列数据，分别对应 X, Y, Z 坐标
ball_centers = all_peaks; % 假设 all_peaks 也是三列数据，对应球心的 X, Y, Z 坐标
ball_labels = label_all_peaks;

% 定义颜色
% 科研配色双色
colors = [
 %  [37/255, 122/255, 182/255]; 
 % [252/255, 132/255, 13/255];     
  [93/255, 129/255, 183/255]; 
  [144/255, 176/255, 63/255];    
   [177/255, 24/255, 45/255];    %红 
   [36/255, 100/255, 171/255];   %蓝
];

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
    X = X * ball_radius(i) + ball_centers(i, 1);
    Y = Y * ball_radius(i) + ball_centers(i, 2);
    Z = Z * ball_radius(i) + ball_centers(i, 3);
    % 绘制球体轮廓
    mesh(X, Y, Z, 'EdgeColor', colors(ball_labels(i), :), 'FaceColor', 'none', 'LineWidth', 0.1,'EdgeAlpha', 1);
end

% 显示颗粒球中心
% plot3(ball_centers(:, 1), ball_centers(:, 2), ball_centers(:, 3),'.r','MarkerSize', 10);
% 用不同颜色绘制球心
% 用不同颜色和标记绘制球心
for i = 1:size(ball_centers, 1)
    scatter3(ball_centers(i, 1), ball_centers(i, 2), ball_centers(i, 3), 18, ...
             colors(ball_labels(i), :), 'filled', 'Marker', 'p');
    hold on;  % 保持当前图形，以便在同一图上绘制其他形状
end



% 设置视图和坐标轴
axis equal;
% Chainlink专用
% xlim([-1. 1.1]);  
% ylim([-1.1 2.1]);  
% zlim([-1.1 1.1]);

% 完成绘图
hold off;
box on;
% set(gcf, 'unit', 'normalized', 'position', [0.2, 0.2, 0.2, 0.3]);
set(gca, 'FontSize', 16);
% view(-75, 20);  % 旋转图像
view(3);
% Display the figure in full screen
set(gcf, 'WindowState', 'maximized');

% 保存图片
% print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\论文\SDPeak2.0\可视化实验\Chainlink\中位数sample\GB_clusterinh.png', '-dpng', '-r960');
