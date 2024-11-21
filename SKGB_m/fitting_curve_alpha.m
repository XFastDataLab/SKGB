%% Fitting with Confidence Interval for Multiple Sheets
clear; clc;

% 数据加载
data_path = 'D:\Academic_Writing\Clustering\SKGB\Experiment Records tables\alpha confidence interval.xlsx';
s10 = readtable(data_path, 'Sheet', 1);
s20 = readtable(data_path, 'Sheet', 2);
s30 = readtable(data_path, 'Sheet', 3);
s40 = readtable(data_path, 'Sheet', 4);

% Alpha 数据 (假定 alpha 是固定的)
alpha = [1.0E-6, 1.0E-5, 1.0E-4, 1.0E-3, 1.0E-2]'; % 转置为列向量

% 提取 Clustering Time 数据
clustering_time_data = {s10{:, 2}, s20{:, 2}, s30{:, 2}, s40{:, 2}};
colors = lines(4); % 使用更协调的颜色
labels = {'s=10', 's=20', 's=30', 's=40'};

% 绘图
figure;
hold on;

for i = 1:4
    clustering_time = clustering_time_data{i};
    
    % 拟合曲线 (指数拟合，使用逐元素运算符)
    fit_func = @(b, x) b(1) .* exp(b(2) .* x) + b(3);
    b0 = [500, 1, 500]; % 初始猜测参数
    beta = nlinfit(alpha, clustering_time, fit_func, b0);
    
    % 生成拟合值
    alpha_fit = logspace(log10(min(alpha)), log10(max(alpha)), 100)';
    clustering_fit = fit_func(beta, alpha_fit);
    
    % 计算置信区间
    [~, R] = nlinfit(alpha, clustering_time, fit_func, b0); % 残差
    conf_interval = 1.96 * std(R); % 简单近似 95% 置信区间
    upper_bound = clustering_fit + conf_interval;
    lower_bound = clustering_fit - conf_interval;
    
    % 绘制拟合曲线和置信区间
    scatter(alpha, clustering_time, 50, 'MarkerFaceColor', colors(i, :), ...
        'MarkerEdgeColor', 'k', 'DisplayName', [labels{i}, ' Data']); % 实心数据点
    semilogx(alpha_fit, clustering_fit, '-', 'LineWidth', 2, 'Color', colors(i, :), ...
        'DisplayName', [labels{i}, ' Fit']);
    fill([alpha_fit; flipud(alpha_fit)], [upper_bound; flipud(lower_bound)], colors(i, :), ...
        'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', [labels{i}, ' CI']);
end

% 设置 Alpha 轴的刻度和标签
set(gca, 'XScale', 'log'); % 对数刻度
xticks(alpha); % 自定义刻度位置
xticklabels({'1.0E-6', '1.0E-5', '1.0E-4', '1.0E-3', '1.0E-2'}); % 自定义刻度标签

% 图形设置
grid off;
xlabel('\alpha', 'FontSize', 20); % X轴标签显示为希腊字母 α
ylabel('Clustering Time (s)', 'FontSize', 20);
% title('Clustering Time vs Alpha with Confidence Interval (Multiple Sheets)', 'FontSize', 20);
ylim([350, 3350]); % 设置 Y 轴下限为 300
set(gca, 'FontSize', 20); % 设置坐标轴刻度字体大小为 20
% 调整图形大小以适应内容
set(gcf, 'Units', 'centimeters', 'Position', [3, 1, 18*1.5, 12*1.5]); % [x, y, width, height]
% % 设置图例的位置为左上角
% legend('show', 'Location', 'northwest');
% 自定义图例内容
custom_legend = {'s=10 Data', 'Fit', '95% CI', ...
                 's=20 Data', 'Fit', '95% CI', ...
                 's=30 Data', 'Fit', '95% CI', ...
                 's=40 Data', 'Fit', '95% CI'};
% 设置图例横排，分为 3 列，并放在上方
legend(custom_legend, 'Location', 'northwest', 'Orientation', 'horizontal', 'NumColumns', 3);

% 在 alpha=1e-4 处添加垂直虚线
% xline(1.0E-4, '--r', 'LineWidth', 1.5, 'HandleVisibility', 'off');
% 在 alpha=1e-4 处添加限定高度的垂直虚线（不加入图例）
line([1e-4, 1e-4], [350, 1500], 'LineStyle', '--', 'Color', 'r', 'LineWidth', 1.5, 'HandleVisibility', 'off');
% 添加标注
% text(1e-4, 1500 + 80, '\alpha=$\frac{1}{\sqrt{n}}$', 'HorizontalAlignment', 'left', 'FontSize', 20, 'Color', 'k');
text(1e-4, 1500 + 80, '$\alpha=\frac{1}{\sqrt{n}}$', 'HorizontalAlignment', 'left', 'FontSize', 20, 'Color', 'k', 'Interpreter', 'latex');

figFilename = 'D:\Academic_Writing\Clustering\SKGB\SKGB_Accessories\AGC100M\alpha_CI.png';
exportgraphics(gcf, figFilename, 'Resolution', 400, 'ContentType', 'image');
hold off;