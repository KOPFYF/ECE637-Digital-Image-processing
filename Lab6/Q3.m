clear all;
clc;

%% read data
data = load('data.mat');
lambda = 400:10:700;
x0 = data.x;
y0 = data.y;
z0 = data.z;

%% equations (4)
x = x0(:) ./ (x0(:) + y0(:) + z0(:));
y = y0(:) ./ (x0(:) + y0(:) + z0(:));

D_65 = [0.3127 0.3290 0.3583];
EE = [0.3333 0.3333 0.3333];

RGB_CIE_1931 = [0.73467 0.26533 0.0;
    0.27376 0.71741 0.00883;
    0.16658 0.00886 0.82456;
    0.73467 0.26533 0.0];

RGB_709 = [0.64 0.33 0.03;
    0.3 0.6 0.1;
    0.15 0.06 0.79;
    0.64 0.33 0.03];
%% Plot
figure(5);
set(0, 'DefaultLineLineWidth', 2);
plot(x,y,'b-');
hold on;
plot(RGB_CIE_1931(:,1), RGB_CIE_1931(:,2), 'r*-');
text(RGB_CIE_1931(:,1), RGB_CIE_1931(:,2), 'RGB_{CIE_{1931}}');
plot(RGB_709(:,1), RGB_709(:,2), 'g*-');
text(RGB_709(:,1), RGB_709(:,2), 'RGB_{709}');
plot(D_65(1), D_65(2), 'y+');
text(D_65(1), D_65(2), 'D_{65}');
plot(EE(1), EE(2), 'ko');
text(EE(1), EE(2), 'EE');
title('Chromaticity for 4 RGB primaries');
print('-dpng', '-r300', 'Q3_chromaticity.png');