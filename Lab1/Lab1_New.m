clc;
close all;
clear all;

u = -pi:0.05:pi;
v = -pi:0.05:pi;
[U,V] = meshgrid(u,v);

%% Section 3
H1 = zeros(size(U));
for k = -4:4
    for l = -4:4
        H1 = H1 + 1/81*exp(-1i*(k.*U+l.*V));
    end 
end 
H1 = abs(H1);
figure;
surf(U,V,H1)
xlabel('U')
ylabel('V')
zlabel('H(U,V)')
title('DSFT of h(m,n)')
colormap
colorbar

%% Section 4
H2 = zeros(size(U));
for k = -2:2
    for l = -2:2
        H2 = H2 + 1/25*exp(-1i*(k.*U+l.*V));
    end 
end 
H2 = abs(H2);
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

%% Section 5
H3 = abs(0.01./(1-0.9*exp(-i*U)-0.9*exp(-i*V)+0.81*exp(-i*U).*exp(-i*V)));
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
image(BlurImg);
colormap(gray(256));
truesize;

%% Compute the point spread function h(m,n)
x = zeros(256,256);
x(127,127) = 1;
y = zeros(256,256);
for k = 2:256
    for l = 2:256
        y(k,l) = 0.01*x(k,l) + 0.9*(y(k,l-1)+y(k-1,l))- 0.81*y(k-1,l-1);
    end
end
h = y;
imwrite(uint8(255*100*h),'h_out.tif')
