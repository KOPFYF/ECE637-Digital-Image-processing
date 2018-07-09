clear all;
clc;

L = 256;
x=imread('kids.tif');
h = hist(x(:),[0:L-1]);

Output=h/numel(x);
%Calculate the Cumlative sum
hSum=cumsum(Output);
figure;
plot(0:L-1,hSum,'LineWidth',4)
xlabel('pixel intensity');
ylabel('cdf of pixels');
title('cdf')

%Perform the transformation S=T(R) where S and R in the range [0 1]
Z=hSum(x+1);
%Convert the image into uint8
Z=uint8(Z*(L-1));
figure,imshow(Z);

figure(10);
image(Z+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);


figure;
hist(Z(:),[0:255]);
xlabel('pixel intensity');
ylabel('number of pixels');
title('Equalized Histogram of kids.tif')


