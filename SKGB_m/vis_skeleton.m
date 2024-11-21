fig = figure;

% 设置刻度标签的字体大小为fontSize
fontSize = 24;

% Rotation angle for figures
% rotationAngle = [-85, 7];
% rotationAngle = [-100, 17];

% Axises range
% xRange = [-2 18];
% yRange = [-2 14];
% zRange = [-1.5 1.3];

sample_centers = all_peaks;

% 1.为每个点找到唯一的一个父节点，并可视化出来
m = length(ordgamma);
%m = length(sorted_indices);
peaks_and_nneighs = zeros(m,2);
index_peaks_reshape = reshape(ordgamma',m,1);
%index_peaks_reshape = sorted_indices;
%index_centers_reshape = reshape(ordrho',m,1);              %注意以ordgamma'和ordrho'作为第一列的区别(仅仅是以颜色深浅标示不同密度大小时有影响？)
nneigh_reshape = reshape(nneigh',m,1);              %寻找这k*s个峰值点的最近邻中比自己密度大的点所对应的索引并reshape成一列，且放在第二列
%nneigh_reshape = nearest_labeled_points;
zuijinling = nneigh_reshape(index_peaks_reshape);     
peaks_and_nneighs(:,1) = index_peaks_reshape;
peaks_and_nneighs(:,2) = zuijinling;
% peaks_and_nneighs(peaks_and_nneighs(:, 1) == 840,2) = 0 ;
% peaks_and_nneighs(peaks_and_nneighs(:, 1) == 581,2) = 104 ;


% Color Link: https://colorhunt.co/palette/667bc6fdffd2ffb4c2da7297
% colors = [
%     [102/255, 123/255, 198/255]; % Blue
%     [255/255, 180/255, 194/255]; % Pink
% ];

% 树形骨架图
a_color = 230/length(peaks_and_nneighs); 
b_color = 230/length(peaks_and_nneighs); 
c_color = (255-230)/length(peaks_and_nneighs);

% temp_colors = colors .* 255 ./ length(peaks_and_nneighs);

% 1.对应的
% 如果是3D的，那么length(peaks):length(peaks_and_nneighs)，不需要+1(用obtain_skeleton函数得到的骨架也不需要+1)
for i = length(peaks)+1:length(peaks_and_nneighs)     %不从一开始，避免每个类的聚类中心指向其他类
   if(peaks_and_nneighs(i,2)) ~= 0 
    %3d
%        line([sample_centers(peaks_and_nneighs(i,1)),sample_centers(peaks_and_nneighs(i,2))],...
%        [sample_centers(peaks_and_nneighs(i,1),2),sample_centers(peaks_and_nneighs(i,2),2)],...
%        [sample_centers(peaks_and_nneighs(i,1),3),sample_centers(peaks_and_nneighs(i,2),3)],...
%        'color',[0 + a_color * i , 0 + b_color * i , 255 - c_color * i]./255);

    %2d
   line([sample_centers(peaks_and_nneighs(i,1)),sample_centers(peaks_and_nneighs(i,2))],[sample_centers(peaks_and_nneighs(i,1),2),sample_centers(peaks_and_nneighs(i,2),2)],...
       'color',[0 + a_color * i , 0 + b_color * i , 255 - c_color * i]./255);
    end
end

hold on;
plot(peaks(:,1),peaks(:,2),'pr','LineWidth',1.25);     %聚类中心
%plot(peaks(:,1),peaks(:,2),'pr','LineWidth',1);     %聚类中心
% plot3(peaks(:,1),peaks(:,2),peaks(:,3),'pr','LineWidth', 1.25);     %聚类中心

axis equal;  % 保持轴的比例一致
% SYN1专用
xlim([-0.55 0.6]);  
ylim([-0.5 0.5]); 

% SYN2专用
% xlim([0 600]);  
% ylim([0 800]); 

% SYN3专用
% xlim([0 320]);
% ylim([20 380]);

%twenty专用
% xlim([-2 18]);  
% ylim([-2 14]);

% xlim(xRange);
% ylim(yRange);
% zlim(zRange);

box on;
% grid on;
% set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
% set(gca, 'FontSize', 16);  % 设置刻度标签的字体大小为16
set(gca, 'FontSize', fontSize);
%set(gca, 'XTickLabel', [], 'YTickLabel', [], 'ZTickLabel', []);
%set(gca, 'LineWidth', 1.5); % 增加坐标轴的粗细
% set(gcf, 'Position', [100, 100, 800, 600]);

% view(3);
% view(-75, 20);  % 旋转图像
% view(-50, 45);
% view(-85, 7);
% view(rotationAngle);

figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_skeleton_%d.fig', num_samples, alpha, target_ball_count, k, seedData.Seed);
saveas(fig, figFilename);

figFilename = sprintf('generate_files/SYN1_low_resolution/%d_%.3f_%d_%d_SYN1_skeleton_%d.png', num_samples, alpha, target_ball_count, k, seedData.Seed);
print(figFilename, '-dpng', '-r400');
