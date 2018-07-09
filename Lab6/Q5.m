clear all;
clc;

[x, y] = meshgrid(0:0.005:1);
z = 1 - y - x;

RGB_709 = [0.64 0.3 0.15;
    0.33 0.6 0.06;
    0.03 0.1 0.79];
M_709 = RGB_709 * eye(3);

[m, n] = size(x);
XYZ = zeros(m,n,3);

XYZ(:,:,1) = x;
XYZ(:,:,2) = y;
XYZ(:,:,3) = z;

rgb = zeros(m,n,3);

for p = 1:m
	for q = 1:n
		rgb(p,q,:) = inv(M_709) * permute(XYZ(p,q,:), [1 3 2])';
		if any(rgb(p,q,:) < 0)
			rgb(p,q,:) = [1, 1, 1];
		end
	end
end

gama_rgb = ((rgb).^(1/2.2));

figure(1);
image([0:0.005:1], [0:0.005:1], gama_rgb);
axis('xy');
hold on;

data = load('data.mat');
x0 = data.x;
y0 = data.y;
z0 = data.z;

x1 = x0(:) ./ (x0(:) + y0(:) + z0(:));
y1 = y0(:) ./ (x0(:) + y0(:) + z0(:));
plot(x1, y1, 'r-');
print('-dpng', '-r300', 'Q5.png');