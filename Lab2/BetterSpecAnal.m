
% Clear memory and close existing figures
clear
close

% This line reads in a gray scale TIFF image. 
% The matrix img contains a 2-D array of 8-bit gray scale values.

[img] = imread('img04g.tif');

% This line sets the colormap, displays the image, and sets the
% axes so that pixels are square.
% "map" is the corresponding colormap used for the display. 
% A gray scale pixel value is treated as an index into the 
% current colormap so that the pixel at location (i,j)
% has the color [r,g,b] = map(img(i,j),:) .

map=gray(256);
colormap(gray(256));
image(img)
axis('image')

X = double(img)/255;
W = hamming(64)*hamming(64)';

% Select an NxN region of the image and store it in the variable "z"

N = 64;
Sum = zeros(64,64);
for i = 1:5
    for j = 1:5
        m = 96 + (i-1)*64;
        n = 224 + (j-1)*64;
        C = X(m:(N+m-1), n:(N+n-1)).*W;
        Z = (1/N^2)*abs(fft2(C)).^2;      
        Sum = Sum + Z;
    end
end
Avg = Sum/25;
Avg = log(fftshift(Avg));


% Plot the result using a 3-D mesh plot and label the x and y axises properly. 

x = 2*pi*((0:(N-1)) - N/2)/N;
y = 2*pi*((0:(N-1)) - N/2)/N;
figure 
mesh(x,y,Avg)
xlabel('\mu axis')
ylabel('\nu axis')



