clear all;
clc;

%% read data
data = load('data.mat');
reflect = load('reflect.mat');
lambda = 400:10:700;
R = reflect.R;
x = data.x;
y = data.y;
z = data.z;
illum1 = data.illum1;
illum2 = data.illum2;

%% 170*256*31
[m, n, j] = size(R);
I = zeros(size(R));
for p = 1:m
	for q = 1:n
        for i = 1:j
%             I(p,q,i) = R(p,q,i)* illum1(i);
            I(p,q,i) = R(p,q,i)* illum2(i);
        end 
    end 
end 

%%
[m, n, ~] = size(I);
XYZ = zeros(m,n,3);
for p = 1:m
	for q = 1:n
        XYZ(p,q,:) = permute(I(p,q,:), [1 3 2]) * [x;y;z]';
	end
end

%%
D_65 = [0.3127 0.3290 0.3583];
RGB_709 = [0.64 0.3 0.15;
    0.33 0.6 0.06;
    0.03 0.1 0.79];
XYZ_wp = [D_65(1)/D_65(2) 1 D_65(3)/D_65(2)];
k_rgb = inv(RGB_709) * XYZ_wp';
M = RGB_709 * diag(k_rgb);

%%
rgb = zeros(m,n,3);
for p = 1:m
	for q = 1:n
		rgb(p,q,:) = inv(M) * permute(XYZ(p,q,:), [1 3 2])';
	end
end

%%
rgb(rgb(:) > 1) = 1;
rgb(rgb(:) < 0) = 0;

figure(1);
image(rgb);

%% Gama-correct
gc_rgb = zeros(m,n,3);
gc_rgb = 255 * ((rgb).^(1/2.2));

figure(2);
image(uint8(gc_rgb));
imwrite(uint8(gc_rgb), 'd65Img2.png');

