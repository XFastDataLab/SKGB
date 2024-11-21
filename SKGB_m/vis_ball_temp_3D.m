figure;

% 先可视化原始数据点
% scatter3(sampled_set(:, 1), sampled_set(:, 2), sampled_set(:, 3), 8, 'k', 'filled');  % 黑色填充
scatter3(sampled_set(:, 1), sampled_set(:, 2), sampled_set(:, 3), 8, 'filled', 'MarkerEdgeColor', [0.5 0.5 0.5]);
% plot3(sampled_set(:, 1), sampled_set(:, 2), sampled_set(:, 3),'.', 'Color', [0.5 0.5 0.5]);
hold on;

% 用球体表示颗粒球
[x, y, z] = sphere;
for i = 1:size(ball_centers, 1)
    surf(ball_radius(i) * x + ball_centers(i, 1), ...
         ball_radius(i) * y + ball_centers(i, 2), ...
         ball_radius(i) * z + ball_centers(i, 3), ...
         'EdgeColor', 'r', 'FaceColor', 'none', ...
         'LineStyle', '-', 'LineWidth', 0.5, 'EdgeAlpha', 0.03); % 浅红色半透明轮廓，无填充颜色
    hold on;
end

% 显示颗粒球中心
%scatter3(ball_centers(:, 1), ball_centers(:, 2), ball_centers(:, 3), 36, 'r', 'filled');
hold on;
plot3(ball_centers(:, 1), ball_centers(:, 2), ball_centers(:, 3),'.r','MarkerSize', 10);

% 添加必要的视图和坐标轴设置
axis equal;
% xlabel('X轴');
% ylabel('Y轴');
% zlabel('Z轴');

% 设置坐标轴范围
% xlim([0 300]);
% ylim([0 400]);
% zlim([0 300]); % 需要根据您的数据范围设置

% 绘制峰值
scatter3(peaks(:, 1), peaks(:, 2), peaks(:, 3), 188, 'pb', 'filled');


% 完成绘图
hold off;
box on;
set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
set(gca, 'FontSize', 16);
view(-75, 20);  % 旋转图像
%view(-75, 50);  % 旋转图像
% print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\论文\SDPeak2.0\可视化实验\Chainlink\sample2.png', '-dpng', '-r960');
