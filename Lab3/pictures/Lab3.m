clear all;
clc;

x1=imread('segmentation1.tif');
N1=max(x1(:));
figure;
image(x1);
colormap(rand(N1,3));
axis('image');

x2=imread('segmentation2.tif');
N2=max(x2(:));
figure;
image(x2);
colormap(rand(N2,3));
axis('image');

x3=imread('segmentation1.tif');
N3=max(x3(:));
figure;
image(x3);
colormap(rand(N3,3));
axis('image');