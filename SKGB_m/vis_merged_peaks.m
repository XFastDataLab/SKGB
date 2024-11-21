fig = figure;
%plot(data(:,1), data(:,2), '.', 'Color', [0.5 0.5 0.5]);
%plot3(data(:,1), data(:,2),data(:,3), '.', 'Color', [0.5 0.5 0.5]);
hold on;
%plot(accumulated_centers(:,1),accumulated_centers(:,2),'ob','MarkerSize', 10,'LineWidth',1);

% plot(all_peaks(:, 1), all_peaks(:, 2), 'pb', 'MarkerSize', 12, 'LineWidth', 1.5); % 2
plot3(all_peaks(:,1),all_peaks(:,2),all_peaks(:,3),'pb','MarkerSize', 10,'LineWidth',1);    % 3D

%plot(peaks(:, 1), peaks(:, 2), 'or', 'MarkerSize', 12, 'LineWidth', 1.5); % 2D
%plot3(peaks(:, 1), peaks(:, 2), peaks(:, 3), 'or', 'MarkerSize', 12, 'LineWidth', 1.5); % 3D

% set(gcf,'unit','normalized','position',[0.2,0.2,0.2,0.3])
set(gca, 'FontSize', 16);  % 设置刻度标签的字体大小为16

% Twenty专用
% xlim([-2 18]);  
% ylim([-2 14]);

% SYN1专用
% xlim([-0.5 0.58]);
% ylim([-0.5 0.5]);

% SYN3专用
% xlim([0 300]);  
% ylim([0 400]); 


xlim([-1. 1.1]);  
ylim([-1.1 2.1]);  
zlim([-1.1 1.1]);

box on;
%view(3);
%view(-75, 20);  % 旋转图像

set(gcf, 'Position', [100, 100, 800, 600]);

view(-80, 45);

figFilename = sprintf('generate_files/%d_%.3f_%d_Chainlink_merged_peaks_%d.fig', num_samples, alpha, target_ball_count, seedData.Seed);
saveas(fig, figFilename);

figFilename = sprintf('generate_files/%d_%.3f_%d_Chainlink_merged_peaks_%d.png', num_samples, alpha, target_ball_count, seedData.Seed);
print(figFilename, '-dpng', '-r960');