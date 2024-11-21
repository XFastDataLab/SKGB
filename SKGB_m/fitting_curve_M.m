%% Fitting with Confidence Interval for Multiple Sheets
clear; clc;

% 数据加载
data_path = 'D:\Academic_Writing\Clustering\SKGB\Experiment Records tables\M confidence interval.xlsx'; % 将路径替换为上传的文件路径
s10 = readtable(data_path, 'Sheet', 1);
s20 = readtable(data_path, 'Sheet', 2);
s30 = readtable(data_path, 'Sheet', 3);
s40 = readtable(data_path, 'Sheet', 4);

% M 数据 (假定 M 是固定的)
M = [1, 2, 3, 5, 7, 10, 13, 16, 20, 24, 28, 32]'; % 转置为列向量

% 提取数据 (假设在每个 sheet 的第 2 列)
clustering_time_data = {s10{:, 2}, s20{:, 2}, s30{:, 2}, s40{:, 2}};
colors = lines(4); % 使用更协调的颜色
labels = {'s=10', 's=20', 's=30', 's=40'};

% 绘图
figure;
hold on;

for i = 1:4
    clustering_time = clustering_time_data{i};
    
    % 多项式拟合
    degree = 6; % 多项式阶数 7
    p = polyfit(M, clustering_time, degree); % 进行多项式拟合
    M_fit = linspace(min(M), max(M), 100)'; % 从 M 中生成拟合点
    clustering_fit = polyval(p, M_fit); % 计算拟合值
    
    % 计算残差和置信区间
    R = clustering_time - polyval(p, M); % 残差
    conf_interval = 1.96 * std(R); % 简单近似 95% 置信区间
    upper_bound = clustering_fit + conf_interval;
    lower_bound = clustering_fit - conf_interval;
    
    % 绘制拟合曲线和置信区间
    scatter(M, clustering_time, 50, 'MarkerFaceColor', colors(i, :), ...
        'MarkerEdgeColor', 'k', 'DisplayName', [labels{i}, ' Data']); % 实心数据点
    plot(M_fit, clustering_fit, '-', 'LineWidth', 2, 'Color', colors(i, :), ...
        'DisplayName', [labels{i}, ' Fit']);
    fill([M_fit; flipud(M_fit)], [upper_bound; flipud(lower_bound)], colors(i, :), ...
        'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', [labels{i}, ' CI']);
end

% 设置 X 轴的刻度和标签
% xticks(M); % 自定义刻度位置
% xlabel('M (ck)', 'FontSize', 20); % X轴标签
% 自定义横坐标标签
M_labels = arrayfun(@(x) sprintf('%dck', x), M, 'UniformOutput', false); % 转换为 "数字ck" 格式
xticks(M); % 设置刻度
M_labels(M == 2) = {''}; % 将 M=2 的标签设置为空字符串
xticklabels(M_labels); % 设置刻度标签为自定义格式
% xtickangle(50); % 将横坐标标签逆时针旋转 90 度
xtickangle(40); % 将横坐标标签逆时针旋转 90 度
xlabel('M', 'FontSize', 20); % X轴标签


% 图形设置
grid off;
ylabel('Clustering Time (s)', 'FontSize', 20);
% ylim([450, 650]); % 设置 Y 轴范围
ylim([400, 700]); % 设置 Y 轴范围
set(gca, 'FontSize', 20); % 设置坐标轴刻度字体大小为 20

% 调整图形大小以适应内容
set(gcf, 'Units', 'centimeters', 'Position', [3, 1, 18*1.5, 12*1.5]); % [x, y, width, height]

% 自定义图例内容
% custom_legend = {'s=10 Data', 'Fit', 'Confidence Interval', ...
%                  's=20 Data', 'Fit', 'Confidence Interval', ...
%                  's=30 Data', 'Fit', 'Confidence Interval', ...
%                  's=40 Data', 'Fit', 'Confidence Interval'};
custom_legend = {'s=10 Data', 'Fit', '95% CI', ...
                 's=20 Data', 'Fit', '95% CI', ...
                 's=30 Data', 'Fit', '95% CI', ...
                 's=40 Data', 'Fit', '95% CI'};
% 设置图例横排，分为 3 列，并放在上方
legend(custom_legend, 'Location', 'northeast', 'Orientation', 'horizontal', 'NumColumns', 3);%northoutside

% 在 M=10 处添加垂直虚线
% xline(10, '--r', 'LineWidth', 1.5, 'HandleVisibility', 'off'); %, 'DisplayName', 'M=10'
% 添加标注
% text(8.8, 425, 'M=10', 'HorizontalAlignment', 'left', 'FontSize', 20, 'Color', 'k');
% 找到 M=10 对应的最高数据点值
M_index = find(M == 10); % 找到 M=10 的索引
max_clustering_time = max(cellfun(@(x) x(M_index), clustering_time_data)); % 计算最高数据点值
% 在 M=10 处添加限定高度的垂直虚线（不加入图例）
line([10, 10], [400, max_clustering_time + 80], 'LineStyle', '--', 'Color', 'r', 'LineWidth', 1.5, 'HandleVisibility', 'off');
% 添加标注
text(10, max_clustering_time + 80 + 10, 'M=10ck', 'HorizontalAlignment', 'left', 'FontSize', 20, 'Color', 'k');


% 保存为高分辨率 PNG 文件
% figFilename = 'D:\Academic_Writing\Clustering\SKGB\SKGB_Accessories\AGC100M\M_CI.png';
% print(figFilename, '-dpng', '-r400');
% 保存为高分辨率 PNG 文件，减少空白边缘
figFilename = 'D:\Academic_Writing\Clustering\SKGB\SKGB_Accessories\AGC100M\M_CI.png';
exportgraphics(gcf, figFilename, 'Resolution', 400, 'ContentType', 'image');
hold off;
