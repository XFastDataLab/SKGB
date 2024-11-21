% 数据大小
x = [1e4, 5e4, 1e5, 2e5, 5e5, 1e6, 2e6, 3e6, 4e6, 4852684];

% 为每个算法随机生成运行时间
rng(0); % 设定随机数种子以确保结果可重现
%SDPeak_times = [0.7586, 1.3741, 2.492, 3.7749, 9.46, 33.5596, 73.3673, 88.4193, 132.478, 150.395];   % SDPeak 算法运行时间
SDPeak_times = [0.2715, 1.4868, 1.6281, 1.7777, 1.8946, 4.6931, 9.0559, 19.9068, 30.2335, 42.4194];   % SDPeak2.0 算法运行时间
%FastDPeak_times = [ 3.5038, NaN(1, length(x)-1)]; % FastDPeak 算法运行时间
FHC_LDP_times = [11.9296, 414.3578, NaN(1, length(x) - 2)]; % FHC-LDP 算法运行时间
GB_DP_times = [2.6571, 11.086, 24.4117, 57.3357, 164.4093, 349.2043, 786.8673, 1335.048, 1996.663, 2201.394]; % GB-DP 算法运行时间

% 自定义颜色
% colors = {[115/255, 180/255, 77/255],  % FHC-LDP颜色 
%       %    [246/255, 193/255, 77/255],  % FastDPeak颜色
%           [216/255, 33/255, 28/255],   % SDPeak颜色
%           [41/255, 155/255, 207/255]}; % GB-DP颜色
colors = {[241/255, 108/255, 35/255],  % FHC-LDP颜色 
      %    [246/255, 193/255, 77/255],  % FastDPeak颜色
          [43/255, 106/255, 153/255],   % SDPeak颜色
          [27/255, 124/255, 61/255]}; % GB-DP颜色
      
% 点的大小和线宽
markerSize = 5; % 点的大小
lineWidth = 1; % 线宽

% 绘制折线图
figure;
loglog(x, SDPeak_times, 'o-', 'Color', colors{1}, 'MarkerEdgeColor', colors{1}, 'MarkerFaceColor', colors{1}, 'DisplayName', 'SDPeak', 'MarkerSize', markerSize, 'LineWidth', lineWidth); hold on;
%loglog(x, FastDPeak_times, 'o-', 'Color', colors{2}, 'MarkerEdgeColor', colors{2}, 'MarkerFaceColor', colors{2}, 'DisplayName', 'FastDPeak', 'MarkerSize', markerSize, 'LineWidth', lineWidth);
loglog(x, FHC_LDP_times, 'o-', 'Color', colors{2}, 'MarkerEdgeColor', colors{2}, 'MarkerFaceColor', colors{2}, 'DisplayName', 'FHC-LDP', 'MarkerSize', markerSize, 'LineWidth', lineWidth);
loglog(x, GB_DP_times, 'o-', 'Color', colors{3}, 'MarkerEdgeColor', colors{3}, 'MarkerFaceColor', colors{3}, 'DisplayName', 'GB-DP', 'MarkerSize', markerSize, 'LineWidth', lineWidth);
% 设置 x 轴刻度和标签
set(gca, 'LineWidth', 1.5); % 增加坐标轴的粗细
set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
set(gca, 'FontSize', 9);  % 设置刻度标签的字体大小为16    调整图上的字体大小
xlabel('Data Size');
ylabel('Runtime');
%title('算法性能比较');
legend('show','Location', 'northwest');
grid off;
box off;

%print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\论文\kdd99_compare.png', '-dpng', '-r960');
print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\论文\SDPeak2.0\kdd99_compare.png', '-dpng', '-r960');