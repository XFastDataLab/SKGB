function [num_samples, sample_size, target_ball_count] = Adapative_parameters(data, k)
% 计算自适应参数
% 输入：
%   data - 数据集
%   k - 在每个sample_set上选取的peak数
%
% 输出：
%   num_samples - 根据data大小计算的样本数
%   sample_size - 根据data大小计算的样本大小
%   target_ball_count - 目标球数量，为k的2倍

% 基于data的大小，使用log2计算num_samples，并向上取整
%num_samples = ceil(log2(size(data, 1)));
num_samples = 20;

% 基于data的大小，计算sample_size的平方根并向上取整
sample_size = ceil(sqrt(size(data, 1)));

% 将target_ball_count设置为k的2倍
%target_ball_count = 3 * k;
target_ball_count = 30;

end
