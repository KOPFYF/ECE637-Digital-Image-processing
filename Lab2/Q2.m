clear all;
clc;

N = 512;
a = -0.5; b = 0.5;
x = (b-a).*rand(N) + a;
x_scaled = 255*(x+0.5);
figure;
colormap(gray(256));
image(uint8(x_scaled));

y = zeros(N);
y(1,1) = 3*x(1,1);
y(2,1) = 3*x(2,1);
y(1,2) = 3*x(1,2);

for i = 2:512
    for j = 2:512
        y(i,j) = 3*x(i,j) + 0.99*y(i-1,j)+  0.99*y(i,j-1) -  0.99^2*y(i-1,j-1);
    end 
end
figure;
colormap(gray(256));
image(uint8(y+127));

Z = (1/N^2)*abs(fft2(y)).^2;

% Use fftshift to move the zero frequencies to the center of the plot
Z = fftshift(Z);

% Compute the logarithm of the Power Spectrum.
Zabs = log( Z );

% Plot the result using a 3-D mesh plot and label the x and y axises properly. 

u = 2*pi*((0:(N-1)) - N/2)/N;
v = 2*pi*((0:(N-1)) - N/2)/N;
figure;
mesh(u,v,Zabs)
xlabel('\mu axis')
ylabel('\nu axis')

%% Theoretical plot of Sy
[u,v] = meshgrid(-pi:0.02:pi,-pi:0.02:pi);
Sy = abs(3./(1-0.99.*exp(-1i.*u)-0.99.*exp(-1i.*v)+0.9801.*exp(-1i.*u-1i.*v))).^2./12;
figure;
mesh(u,v,log(Sy))
xlabel('\mu axis')
ylabel('\nu axis')
title('Analytical solution of for output power spectral density  ')


%%
W = hamming(64)*hamming(64)';
N = 64;
% Select an NxN region of the image and store it in the variable "z"
Sum = zeros(N);
for i = 1:5
    for j = 1:5
        m = 96 + (i-1)*64;
        n = 96 + (j-1)*64;
        C = y(m:(N+m-1), n:(N+n-1)).*W;
        Z = (1/N^2)*abs(fft2(C)).^2;
        Sum = Sum + Z;
    end
end
Avg = Sum/25;
Avg = log(fftshift(Avg));


% Plot the result using a 3-D mesh plot and label the x and y axises properly. 

u = 2*pi*((0:(N-1)) - N/2)/N;
v = 2*pi*((0:(N-1)) - N/2)/N;
figure 
mesh(u,v,Avg)
xlabel('\mu axis')
ylabel('\nu axis')