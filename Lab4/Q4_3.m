clear all;
clc;

figure;
x=imread('linear.tif');
x = double(x);
figure(14);
image(x+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);


gamma = 1.99;
for i = 1:size(x,1)
    for j = 1:size(x,2)
%         y(i,j) = 255*(x(i,j)/255)^gamma;
%         y(i,j) = 255*exp(log(x(i,j)/255)/gamma);
        y(i,j) = 255*(x(i,j)/255)^(1/gamma);
    end 
end
figure(15);
image(y+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);


%% gamma 1.5
gamma = 1.5;
x15=imread('gamma15.tif');
x15 = double(x15);
figure(16);
image(x15+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);

x_linear = 255*(x15./255).^(1.5);
x_corrected = 255*(x_linear./255).^(1/1.99);
figure(17);
image(x_corrected+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);

