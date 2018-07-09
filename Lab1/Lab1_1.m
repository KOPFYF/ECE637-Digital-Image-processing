clc;
close all;
clear all;

u = -pi:0.05:pi;
v = -pi:0.05:pi;
[U,V] = meshgrid(u,v);

H1 = abs(64/81*sinc(8.*U).*sinc(8.*V));
figure;
surf(U,V,H1)
xlabel('U')
ylabel('V')
zlabel('H(U,V)')
title('DSFT of h(m,n)')
colormap
colorbar

H2 = abs(16/25*sinc(4.*U).*sinc(4.*V));
figure;
surf(U,V,H2)
xlabel('U')
ylabel('V')
zlabel('H(U,V)')
title('DSFT of h(m,n)')
colormap
colorbar

lamada = 1.5;
G2 = abs((1+lamada)*ones(size(H2))-lamada*H2);
figure;
surf(U,V,G2)
xlabel('U')
ylabel('V')
zlabel('G(U,V)')
title('DSFT of g(m,n)')
colormap
colorbar

H3 = abs(0.01./(1-0.9*exp(-i*U)-0.9*exp(-i*V)+0.81*exp(-i*U)*exp(-i*V)));
figure;
surf(U,V,H3)
xlabel('U')
ylabel('V')
zlabel('H(U,V)')
title('DSFT of h(m,n)-IIR')
colormap
colorbar


%% View and compare

OriginImg = imread('img03.tif');
BlurImg = imread('imgblur.tif');
image(OriginImg);
colormap(gray(256));
truesize;

%% Compute the point spread function h(m,n)
x = zeros(256,256);
x(127,127) = 1;
imwrite(uint8(255*100*h),'h_out.tif')
