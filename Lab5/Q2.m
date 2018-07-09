clear all;
clc;
n = 1000;
W = randn(2,n);
Rx = [2 -1.2;-1.2 1];
[E,Gama] = eig(Rx);
X_ = sqrt(Gama)*W;
X = E*X_;

figure(1);
plot(W(1,:),W(2,:),'.r','LineWidth',3)
title('W')
axis('equal')

figure(2);
plot(X_(1,:),X_(2,:),'.r','LineWidth',3)
title('X_{slash}')
axis('equal')

figure(3);
plot(X(1,:),X(2,:),'.r','LineWidth',3)
title('X')
axis('equal')

u = mean(X,2);
u = repmat(u,1,n);
R_est = (X-u)*(X-u)'/(n-1)

[E_est,Gama_est] = eig(R_est);
W_est = sqrt(Gama_est)^(-1)*E_est'*X;

u_W = mean(W_est,2);
u_W = repmat(u_W,1,n);
Rw_est = (W_est-u_W)*(W_est-u_W)'/(n-1)


figure(4);
plot(W_est(1,:),W_est(2,:),'.r','LineWidth',3)
title('W_{estimated}')
axis('equal')

% figure(5);
% plot(est_X_(1,:),est_X_(2,:),'.r','LineWidth',3)
% title('X_{slash}')
% axis('equal')

figure(6);
plot(X(1,:),X(2,:),'.r','LineWidth',3)
title('X')
axis('equal')



