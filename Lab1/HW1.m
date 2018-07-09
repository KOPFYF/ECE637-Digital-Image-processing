clf
clear all

Ne = 199;
% Ne = 2^7-1;
n = 0:Ne;
a = 0.9;
Delay = 20;
barker = [+1 +1 +1 +1 +1 +1 -1 -1 +1 +1 -1 +1 -1 +1];
% barker = [-1 -1 -1 +1 +1 +1 +1 +1 -1 +1 -1 +1 +1 -1 -1 +1];
mu = 0;
sigma = sqrt(0.01);
% sigma = sqrt(0.1);
% sigma = sqrt(1);


x = zeros(1,length(n));
subplot(3,1,1);
x(1:length(barker)) = barker;
stairs(x);
ylim([-2,2]);
xlabel('N')
ylabel('x-Value')

xd = a.*[zeros(1,Delay), x(1:length(n)-Delay)];
v = normrnd(mu,sigma,[1,length(n)]);

y = xd + v;
subplot(3,1,2);
plot(y)
ylim([-2,2]);
xlabel('N')
ylabel('y-Value')

[acor,lag] = xcorr(y,x);
[~,I] = max(abs(acor));
lagDiff = lag(I)
subplot(3,1,3);
plot(lag,acor);
xlim([0,59]);
xlabel('lag value')
ylabel('Cross correlation')



