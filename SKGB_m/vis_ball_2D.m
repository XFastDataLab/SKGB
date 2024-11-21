
figure

% 先可视化原始数据点
%scatter(sampled_set(:, 1), sampled_set(:, 2), 8,'k', 'filled');  % 黑色填充
plot(sampled_set(:, 1), sampled_set(:, 2), '.', 'Color', [0.5 0.5 0.5]);


% 用圆圈表示颗粒球
for i = 1:size(ball_centers, 1)
    rectangle('Position', [ball_centers(i, 1) - ball_radius(i), ball_centers(i, 2) - ball_radius(i), 2*ball_radius(i), 2*ball_radius(i)], ...
              'Curvature', [1, 1], ...
              'EdgeColor', 'r');  % 设置为红色
              
              
               
end
hold on;

% 显示颗粒球中心

for i = 1:size(ball_centers, 1)
     plot(ball_centers(i, 1), ball_centers(i, 2), '.r','MarkerSize', 10);
 %    plot(ball_centers(i, 1), ball_centers(i, 2), '.r','MarkerSize', 10);
 %    scatter(ball_centers(i, 1), ball_centers(i, 2), 18, colors(ball_labels(i), :), 'filled','Marker','p');    % 'o', '+', '*', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'
    hold on;  % 保持当前图形，以便在同一图上绘制其他形状
end


% 添加必要的视图和坐标轴设置
axis equal;  % 保持轴的比例一致

% SYN1专用
% xlim([-0.5 0.58]);  
% ylim([-0.5 0.5]); 

% SYN2专用
% xlim([0 600]);  
% ylim([0 800]); 

% SYN3专用
% xlim([0 300]);  
% ylim([0 400]); 

%twenty专用
% xlim([-2 18]);  
% ylim([-2 14]);

hold on;
%plot(peaks(:, 1), peaks(:, 2), 'pb', 'MarkerSize', 12);

plot(peaks(:, 1), peaks(:, 2), 'pb', 'MarkerSize', 12, 'LineWidth', 1.5); % 这里同时调整了标记大小和线宽


% 完成绘图
hold off;
box on;

%set(gcf,'unit','normalized','position',[0.2,0.2,0.25,0.35])
set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
set(gca, 'FontSize', 16);  % 设置刻度标签的字体大小为16

% print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\SKGB\可视化实验\SYN1\New density\sample2.png', '-dpng', '-r960');
%print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\论文\SDPeak2.0\可视化实验\3M25D\sample1 without contorling.png', '-dpng', '-r960');


