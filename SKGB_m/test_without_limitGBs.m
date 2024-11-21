%clc,clear
%data = importdata('data/covertype_data.txt');
%data = importdata('L:\experiment\合成聚类数据集\3M2D5\data.txt'); 
tic
rng(123);
%[ball_centers, ball_radius, points_per_ball] = GB_generation(sampled_set, 20);
[ball_centers, ball_radius, points_per_ball] = GB_generation_2(sampled_set);
toc