clear all;
clc;

data = load('data.mat');
lambda = 400:10:700;
x = data.x;
y = data.y;
z = data.z;
illum1 = data.illum1;
illum2 = data.illum2;

A_inv = [0.2430 0.8560 -0.044;
    -0.3910 1.1650 0.0870;
    0.0100 -0.0080 0.5630];

%% Plot
set(0, 'DefaultLineLineWidth', 2);
figure(1);
hold on;
plot(lambda, x);
plot(lambda, y);
plot(lambda, z);
legend('x_{0}(\lambda)', 'y_{0}(\lambda)', 'z_{0}(\lambda)');
xlabel('wavelength (nm)');
title('Color Matching Functions vs. Wavelength');
print('-dpng', '-r300', 'xyzmatching.png');

lms = A_inv * [x;y;z];
l = lms(1,:);
m = lms(2,:);
s = lms(3,:);

figure(2);
hold on;
plot(lambda, l);
plot(lambda, m);
plot(lambda, s);
legend('l_{0}(\lambda)', 'm_{0}(\lambda)', 's_{0}(\lambda)');
xlabel('wavelength (nm)');
title('Color Matching Functions (long, medium, short cones) vs. Wavelength');
print('-dpng', '-r300', 'lmnmatching.png');

figure(3);
hold on;
plot(lambda, illum1);
plot(lambda, illum2);
legend('D_{65}', 'Flurorescent Light');
xlabel('wavelength (nm)');
title('Spectrum of D_{65} and Fluorescent Light vs. Wavelength');
print('-dpng', '-r300', 'illuminants.png');