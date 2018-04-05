function [A, B, C, X] = createDatasetGeneric(I, J, K, R)
% I,J & K should be multiple of 100
% It will output factor matrices and a tensor of full Rank R
A = rand(I, R);
B = rand(J, R);
C = zeros(K, R);
temp = generateC(R);
initial = 1;
last = 100;
batch = 100;
iter = K/batch;
n = randperm(size(temp,1)/100, iter);
n(iter) = size(temp,1)/100;
for i=1:iter
    tempIn =  (n(i)-1)*100 + 1;
    tempLast = n(i)*100;
    C(initial:last, :) = temp(tempIn:tempLast,:);
    initial = initial + 100;
    last = last + 100;
end
X = tensor(ktensor(ones(R,1),A, B ,C ));
end