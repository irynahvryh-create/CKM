clc;clear;close all;
n=5;
x=1:2:(2*n+1)
p=2*n+1+n.^n
S=sum(x.^p);
disp(['result S= ', num2str(S)]);



