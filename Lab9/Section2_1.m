clear all;
clc;
run('Qtables.m');

img = imread('img03y.tif');
% gamma = 0.25;
gamma = 1;
% gamma = 4;
img = double(img) - 128;

%% Block transforming, quantizing and storing
dct_blk = blockproc(img, [8 8],@(x)round(dct2(x.data, [8 8])./(Quant*gamma)));
f = fopen('img03y.dq', 'w');
% f = fopen('img03y_3.dq', 'w');
fwrite(f, size(dct_blk, 1), 'integer*2');
fwrite(f, size(dct_blk, 2), 'integer*2');
fwrite(f, dct_blk', 'integer*2');

%% restoring the image
f2 = fopen('img03y.dq', 'r');
% f2 = fopen('img03y_3.dq', 'r');
data = fread(f2, 'integer*2');
img_restoring = reshape(data(3:end), [data(2) data(1)])'; 
img_restoring = blockproc(img_restoring, [8 8],@(x) round(idct2(x.data.*Quant*gamma, [8 8])));
img_restoring = img_restoring + 128;
img_restoring = uint8(img_restoring);

%% difference images
img = imread('img03y.tif');
img_diff = 10 * (img - img_restoring) + 128;

figure(1);
image(img);
truesize;
colormap(gray(256));

figure(2);
image(img_restoring);
truesize;
colormap(gray(256));
imwrite(uint8(img_restoring),'img03y_2.tif');

figure(3);
image(img_diff);
truesize;
colormap(gray(256));
imwrite(uint8(img_diff),'img03y_diff_2.tif');

%% Section 2.3

[m,n] = size(img);
DC = zeros(m/8,n/8);

for i = 1:m/8
    for j = 1:n/8
        DC(i,j) = dct_blk((i-1)*8+1,(j-1)*8+1)+128;
    end
end
figure(4);
image(DC);
truesize;
colormap(gray(256));
imwrite(uint8(DC),'img03y_DC.tif');

N = m*n/64;

for p = 1:8
    for q = 1:8
        AC(p,q) = 0;
        for i = 1:m/8
            for j = 1:n/8       
                AC(p,q) = AC(p,q)+abs(dct_blk((i-1)*8+p,(j-1)*8+q));
            end 
        end 
        AC(p,q) = AC(p,q)/ N;
    end
end

AC_coeff = AC(Zig);
AC_coeff = AC_coeff(2:end)
figure(5)
% index = 1:64
index = 1:63
plot(index,AC_coeff);
title('Mean Abs value of AC coeffcients, \gamma = 1')
xlabel('Order index')
ylabel('Mean abs AC coeffcients')


