% 
% read_data.m
%
% ECE637
% Prof. Charles A. Bouman
% Image Processing Laboratory: Eigenimages and Principal Component Analysis
%
% Description:
%
% This is a Matlab script that reads in a set of training images into
% the Matlab workspace.  The images are sets of English letters written
% in various fonts.  Each image is reshaped and placed into a column
% of a data matrix, "X".
% 
clear all;
clc;

% The following are strings used to assemble the data file names
datadir='.';    % directory where the data files reside
dataset={'arial','bookman_old_style','century','comic_sans_ms','courier_new',...
  'fixed_sys','georgia','microsoft_sans_serif','palatino_linotype',...
  'shruti','tahoma','times_new_roman'};
datachar='abcdefghijklmnopqrstuvwxyz';

Rows=64;    % all images are 64x64
Cols=64;
n=length(dataset)*length(datachar);  % total number of images
p=Rows*Cols;   % number of pixels

X=zeros(p,n);  % images arranged in columns of X
k=1;
for dset=dataset
for ch=datachar
  fname=sprintf('%s/%s/%s.tif',datadir,char(dset),ch);
  img=imread(fname);
  X(:,k)=reshape(img,1,Rows*Cols);
  k=k+1;
end
end
% 
% display samples of the training data, all 'a'
for k=1:length(dataset)
  img=reshape(X(:,26*(k-1)+1),64,64);
  figure(20); subplot(3,4,k); imshow(img);
  axis('image'); colormap(gray(256)); 
  title(dataset{k},'Interpreter','none');
end

u = mean(X,2);
u = repmat(u,1,n);
Z = X - u;
[U,S,V]=svd(Z,0);
% Rx = (X-u)*(X-u)'/(n-1);
% [E,Gama] = eig(Rx);
% [U,S,V]= svd(1/sqrt(n)*X,0);
% R_est = U*S^2*U';

% [U,S,V]= svd(X,0);
U12 = U(:,1:12);
% S12 = S(1:12,:);
% V12 = V(1:12,:);
% X12 = U12*S12*V12';

% X1111 = U12*U12'*X;

% display samples of the training data
for k=1:12
  img=reshape(U12(:,k),64,64);
  figure(30); subplot(4,3,k); imagesc(img);
  axis('image'); colormap(gray(256)); 
  title(['eigenimage' {k}],'Interpreter','none');
end

Y = U'*(X-u);
Y4 = Y(1:10,1:4);
figure(40);
t = 1:10;
plot(t,Y4(:,1),t,Y4(:,2),t,Y4(:,3),t,Y4(:,4))
legend('a','b','c','d');
xlim([1,10]);
title('Projection coefficients');

m = [1 5 10 15 20 30];
k = 1;
for i = m
    Um = U(:,1:i);
    Ym = Um'*(X-u);
    X_est = Um*Ym;
    X1_est = X_est(:,1);
    X1_est = X1_est + u(:,1);
    img=reshape(X1_est,64,64);
    figure(12); subplot(3,2,k); imagesc(img);
    axis('image'); colormap(gray(256)); 
    title({k},'Interpreter','none');
    k = k+1;
end

figure(10);
img=reshape(X(:,1),64,64);
imagesc(img);
axis('image'); colormap(gray(256)); 
title('Original image');

    
    
    



