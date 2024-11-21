clc,clear

% values = [39.66, 61.26, 81.86, 127.67, 163.01, 3017.34];   % alpha
% a_values = {'\alpha=0.001', '\alpha=0.003', '\alpha=0.005', '\alpha=0.01', 'Kmeans++', 'GB-DP'}; % alpha

% values = [37.66, 33.82, 45.18,  56.86, 163.01, 3017.34];    % M
% a_values = {'M=30', 'M=50', 'M=200', 'M=500', 'Kmeans++', 'GB-DP'}; % M

values = [13.95, 29.19, 37.30, 56.29, 163.01, 3017.34];    % s
a_values = {'s=10', 's=20', 's=30', 's=50', 'Kmeans++', 'GB-DP'}; % s


colors = [
    hex2dec('df')/255, hex2dec('44')/255, hex2dec('42')/255; % df4442
    hex2dec('e9')/255, hex2dec('71')/255, hex2dec('24')/255; % e97124
    hex2dec('ef')/255, hex2dec('e6')/255, hex2dec('44')/255; % efe644
    hex2dec('40')/255, hex2dec('a9')/255, hex2dec('3b')/255; % 40a93b
    hex2dec('2c')/255, hex2dec('8f')/255, hex2dec('a0')/255; % 2c8fa0
    hex2dec('44')/255, hex2dec('59')/255, hex2dec('9b')/255; % 44599b
    hex2dec('79')/255, hex2dec('42')/255, hex2dec('92')/255; % 794292
];


figure; % ����һ���µ�ͼ�δ���
hold on; % ���ֵ�ǰͼ�Σ��Ա���ͬһͼ��������µ�ͼ��Ԫ��

%bars = gobjects(length(values), 1); % ��ʼ��ͼ�ζ�������


% �������ÿ�����ӣ���Ϊÿ������������ɫ
for i = 1:length(values)
    bars(i) = bar(i, values(i), 'FaceColor', colors(i,:));
end

set(gca, 'YScale', 'log'); % ����������Ϊ�����߶�
set(gca, 'xtick', []); % ����ʾ�������ǩ
% ����Y��Ŀ̶�
ylim([1 3.5*10^3]);
%yticks([0 10 10^2 10^3]);
ylabel('Value'); % ����y���ǩ

% �ֶ�����ͼ��λ��
lg = legend(a_values, 'FontSize', 8);
%set(lg, 'Position', [0.265, 0.635, 0.2, 0.2]); % alpha
set(lg, 'Position', [0.28, 0.62, 0.2, 0.2]); % M and s

% legend(bars, a_values, 'Location', 'northwest', 'FontSize', 6.8); % ����ͼ���������С
% hold off; % �رձ���״̬

%set(gcf,'unit','normalized','position',[0.15,0.15,0.15,0.23])
set(gcf,'unit','normalized','position',[0.15,0.15,0.15,0.25])
set(gca, 'FontSize', 10);  % ���ÿ̶ȱ�ǩ�������СΪ16
box on;

title('Runtime of N-BaloT with different s', 'FontSize', 12); % ����ͼ�����������С
ylabel('Log runtime(s)', 'FontSize', 12); % ����y���ǩ�������С
print('C:\Users\Lqhness\Desktop\overleaf\cl_by_ball_centers\SKGB\impact of parameters\impact of s.png', '-dpng', '-r960');
