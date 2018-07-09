clear all;
clc;

L = 256;
x=imread('kids.tif');
xmin = min(x(:))
xmax = max(x(:))
for i = 1:size(x,1)
    for j = 1:size(x,2)
        y(i,j) = strecth(x(i,j),xmin,xmax);
    end 
end

figure(10);
image(y+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);

figure(11);
hist(y(:),0:255);
xlabel('pixel intensity');
ylabel('number of pixels');
title('Stretching Histogram of kids.tif')