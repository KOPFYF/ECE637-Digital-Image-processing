% Section 1 %

clear all;
clc;

%%
% X = imread('images/img14bl.tif');
% X = imread('images/img14gn.tif');
X = imread('images/img14sp.tif');
X = double(X);

Y = imread('images/img14g.tif');
Y = double(Y);

[r, c] = size(Y);
m = floor(r/20);
n = floor(c/20);
N = m * n;
Z = zeros(N, 49);
Y_col = zeros(N,1);

i = 1;
for j = 1:m
   for k = 1:n
       Z(i,:) = reshape(X(20*j - 3:20*j + 3, 20*k - 3:20*k + 3)', [1, 49]);
       Y_col(i) = Y(20 * j, 20 * k);
       i = i + 1;
    end
end

R_zz = (Z' * Z) ./ N;
r_zy = (Z' * Y_col) ./ N;
theta_star = R_zz \ r_zy;
theta = reshape(theta_star, [7, 7])
imgout = conv2(X, theta);
figure(1);
image(uint8(imgout));
axis('image');
colormap([0:255;0:255;0:255]'/255);
% print('-dpng', '-r300', 'report/Filtered_Blurred.png');
% print('-dpng', '-r300', 'report/Filtered_Noisy.png');
print('-dpng', '-r300', 'report/Filtered_Noisy_Spots.png');

