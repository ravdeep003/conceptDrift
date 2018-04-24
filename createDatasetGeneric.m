%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function [A, B, C,initialRank] = createDatasetGeneric(I, J, K, R,batch)
% I,J & K should be multiple of 100
% It will output factor matrices and a tensor of full Rank R
A = rand(I, R);
B = rand(J, R);
C = zeros(K, R);
initial = 1;
last = batch;
temp = generateC(R, batch);

iter = K/batch;

% n = randperm(size(temp,1)/batch, iter);
n = randi([1,size(temp,1)/batch],1,iter);

% Initial Rank = 2 and last rank = R
% So that it's not rank defficent
n(1) = randi([1,10],1,1);
n(iter) = size(temp,1)/batch;
for i=1:iter
    tempIn =  (n(i)-1)*batch + 1;
    tempLast = n(i)*batch;
  
    C(initial:last, :) = temp(tempIn:tempLast,:);
    initial = initial + batch;
    last = last + batch;
end
% X = tensor(ktensor(ones(R,1),A, B ,C ));
initialRank = size(find(sum(C(1:batch,:)>0)),2);
end