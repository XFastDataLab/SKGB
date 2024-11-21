function [label_all_peaks, peaks, sorted_indices, nearest_labeled_points] = obtain_skeleton(ball_centers, ball_radius, points_per_ball, k)
    % 计算平均半径
    average_radius = median(ball_radius);
    
    % 计算密度
    density = calculateDensity2(ball_radius, points_per_ball, average_radius);
    
    % 计算每个GB的delta
    delta = calculateDelta(density, ball_centers);
    
    % 计算gamma
    gamma = density .* delta;
    
    % 获取前k个峰值的索引和数据点
    [sorted_gamma, sorted_indices] = sort(gamma, 'descend');
    max_length = min(k, length(sorted_gamma));
    peak_indices = sorted_indices(1:max_length);
    peaks = ball_centers(peak_indices, :);
    
    % 初始化所有点的簇标签为0
    labels = zeros(size(ball_centers, 1), 1);
    
    % 初始化nearest_labeled_points数组为0，表示最初没有点是最近的已标记点
    nearest_labeled_points = zeros(size(ball_centers, 1), 1);
    
    % 给峰值点分配簇标签
    for i = 1:length(peak_indices)
        labels(peak_indices(i)) = i;
    end
    
%     % 为非峰值点分配簇标签
%     for i = 1:size(ball_centers, 1)
%         if labels(i) == 0 % 如果点未被标记
%             % 找到所有更高密度并已被标记的点
%             higher_density_labeled_indices = find(density > density(i) & labels ~= 0);
%             if ~isempty(higher_density_labeled_indices)
%                 % 计算到这些点的距离并找到最近的
%                 distances = pdist2(ball_centers(i,:), ball_centers(higher_density_labeled_indices,:));
%                 [~, idx] = min(distances);
%                 nearest_high_density_labeled_point = higher_density_labeled_indices(idx);
%                 % 分配到最近的更高密度点的簇
%                 labels(i) = labels(nearest_high_density_labeled_point);
%                 % 更新nearest_labeled_points数组
%                 nearest_labeled_points(i) = nearest_high_density_labeled_point;
%             end
%         end
%     end

    
    label_all_peaks = labels;

end
