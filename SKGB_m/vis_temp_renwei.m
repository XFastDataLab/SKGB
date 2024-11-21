% 假设 data 是你的矩阵
data = accumulated_centers;  % 你的矩阵数据

% 目标值
target_value = 435.25;

% 计算第一列与目标值之间的差的绝对值
differences = abs(data(:, 1) - target_value);

% 找到最小差值的索引（即行号）
[~, row_index] = min(differences);

% 显示行号
disp(row_index);
