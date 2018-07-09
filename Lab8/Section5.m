
clear all;
clc;

img = imread('house.tif');
img_diff = error_Diffusion(img);
[M, N] = size(img);

graymap = [0:255;0:255;0:255]'/255;
colormap(graymap);
image(img_diff);
truesize;
imwrite(img_diff, 'house_errdiff.tif');

RMSE = sqrt((1 / (N * M)) * sum(sum((double(img) - img_diff).^2)));
fid = fidelity(double(img), img_diff);