clear all;
clc;

img = imread('house.tif');
[M, N] = size(img);

graymap = [0:255;0:255;0:255]'/255;
colormap(graymap);

img_thres = zeros(size(img));
for i = 1:M
    for j = 1:N
        if img(i,j) > 127
            img_thres(i,j) = 255;
        end 
    end
end

image(img_thres);
truesize;
imwrite(img_thres, 'house_thresholding.tif');

img_d = double(img);
img_thres_d = double(img_thres);

RMSE = sqrt((1 / (N * M)) * sum(sum((img_d - img_thres_d).^2)));

fid = fidelity(img, img_thres);