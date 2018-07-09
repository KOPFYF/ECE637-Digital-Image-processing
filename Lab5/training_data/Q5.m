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

%%
u = mean(X,2);
u = repmat(u,1,n);
Z = (X-u)/sqrt(n-1);
[U,S,V]= svd(Z,0);
A = U(:,1:10);
Y = A'*(X-u);
%%
empty_cell=cell(26,2);
params=cell2struct(empty_cell,{'M','R'},2);
diag_ = cell2struct(empty_cell,{'M','R'},2);

for k = 1:26
    params(k).M = 0;
    params(k).R = 0;
    for j = 1:length(dataset)
    params(k).M = params(k).M + Y(:,26*(j-1)+k);   
    end 
    params(k).M = params(k).M/12;
    
    for j = 1:length(dataset)
    params(k).R = params(k).R + (Y(:,26*(j-1)+k)-params(k).M)*(Y(:,26*(j-1)+k)-params(k).M)';
    end
    params(k).R = params(k).R/11;
    diag_(k).R = diag(diag(params(k).R));
end 


%% Read test data
% go to folders up the hierarchy:
upUpFolder = fileparts(pwd);
% go into another folder
folder = fullfile(upUpFolder, './test_data/veranda');

j = 1;
for ch=datachar
  fname=fullfile(folder,'/',[ch,'.tif']);
  img=imread(fname);
  X_test(:,j)=reshape(img,1,Rows*Cols);
  j=j+1;
end
X_test = double(X_test);
u_test = repmat(mean(X,2),1,26);
y_test = A'*((X_test-u_test));

%%
R_wc = zeros(size(params(1).R));
for k = 1:26
    R_wc = R_wc + params(k).R;
end
R_wc = R_wc/26;
B = R_wc;
% %%
B = diag(diag(R_wc));
%%
% B = eye(10);

%%
k_star = [];
k_right = 1:26;
k_star_pred = [];
for i = 1:26
    y_test_column = y_test(:,i);
    for k = 1:26
%     k_star(k) = (y_test_column - params(k).M)'* params(k).R^(-1)* (y_test_column - params(k).M)+ log(det(params(k).R));  
%     k_star(k) = (y_test_column - params(k).M)'* diag_(k).R^(-1)* (y_test_column - params(k).M)+ log(det(diag_(k).R));  
    k_star(k) = (y_test_column - params(k).M)'* B^(-1)* (y_test_column - params(k).M)+ log(det(B));
    end
    k_star_pred(i) = find(k_star == min(k_star(:)));
end 

k_table = [k_right',k_star_pred']
for i = 1:26
    if k_right(i) ~= k_star_pred(i)
        disp('--------')
        disp(['It is ',num2str(k_right(i)),' But wrong prediction is ',num2str(k_star_pred(i))]);
    end
end 
