clear all;
clc;

figure;
x1=imread('race.tif');
hist(x1(:),[0:255]);
xlabel('pixel intensity');
ylabel('number of pixels');
title('Histogram of race.tif')

figure;
x2=imread('kids.tif');
hist(x2(:),[0:255]);
xlabel('pixel intensity');
ylabel('number of pixels');
title('Histogram of kids.tif')
