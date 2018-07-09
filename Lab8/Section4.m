clear all;
clc;

I2 = [1 2;3 0];
I4 = [4*I2 + 1, 4*I2 + 2; 4*I2 + 3, 4*I2];
I8 = [4*I4 + 1, 4*I4 + 2; 4*I4 + 3, 4*I4];

img = imread('house.tif');
f_l = 255 * (double(img) / 255).^(2.2);
[M, N] = size(img);

N2 = 2; N4 = 4; N8 = 8;
T2 = 255 * ((I2 + 0.5) / (N2^2));
T4 = 255 * ((I4 + 0.5) / (N4^2));
T8 = 255 * ((I8 + 0.5) / (N8^2));

f_l_2 = zeros(M,N); f_l_4 = zeros(M,N); f_l_8 = zeros(M,N);

for p = 1:M
	for q = 1:N
		i = mod(p-1,N2) + 1;
		j = mod(q-1,N2) + 1;
		if f_l(p,q) > T2(i,j)
			f_l_2(p,q) = 255;
		else
			f_l_2(p,q) = 0;
		end
	end
end

for p = 1:M
	for q = 1:N
		i = mod(p-1,N4) + 1;
		j = mod(q-1,N4) + 1;
		if f_l(p,q) > T4(i,j)
			f_l_4(p,q) = 255;
		else
			f_l_4(p,q) = 0;
		end
	end
end

for p = 1:M
	for q = 1:N
		i = mod(p-1,N8) + 1;
		j = mod(q-1,N8) + 1;
		if f_l(p,q) > T8(i,j)
			f_l_8(p,q) = 255;
		else
			f_l_8(p,q) = 0;
		end
	end
end

imwrite(f_l_2, 'house_N2.tif');
imwrite(f_l_4, 'house_N4.tif');
imwrite(f_l_8, 'house_N8.tif');

img_d = double(img);
RMSE_2 = sqrt((1 / (N * M)) * sum(sum((img_d - f_l_2).^2)));
RMSE_4 = sqrt((1 / (N * M)) * sum(sum((img_d - f_l_4).^2)));
RMSE_8 = sqrt((1 / (N * M)) * sum(sum((img_d - f_l_8).^2)));

fid_2 = fidelity(img_d, f_l_2);
fid_4 = fidelity(img_d, f_l_4);
fid_8 = fidelity(img_d, f_l_8);