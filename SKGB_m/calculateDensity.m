function density = calculateDensity(ball_radius, points_per_ball)
    % 初始化density数组
    density = zeros(length(ball_radius), 1); 
    
    % 计算每个球的密度
    for j = 1:length(ball_radius)
        if ball_radius(j) == 0
            density(j) = 0; % 半径为0时，设置密度为0
        else
            density(j) = points_per_ball(j) / (ball_radius(j)); % 计算密度
        end
    end
end