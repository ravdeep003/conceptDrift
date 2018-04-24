%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function [A, B, C, initialRank] = createIRdata(initialRank, finalRank, I, J, K, batch)
% Creates strictly increasing, decreasing or constant rank dataset
% make sure iter is equal to finalRank - initialRank + 1
% example run for increasing rank [A, B, C, initialRank] = createIRdata(2, 10, 100, 100, 90,10)
iter = K/batch;
if initialRank > finalRank
    R = initialRank;
    rank = initialRank:-1:finalRank;
elseif finalRank > initialRank
    R = finalRank;
    rank = initialRank:finalRank;
else
    R = initialRank;
    rank = repmat(R, 1, iter);
end
    
A = rand(I, R);
B = rand(J, R);
C = zeros(K, R);
initial = 0.3*batch;
last = batch;

for i=1:iter
   allcomb = combnk(1:R,rank(i)); 
   col = randi([1 size(allcomb,1)], 1 ,1);
   C(initial:last, allcomb(col,:)) = rand(last-initial +1,rank(i));
   initial = initial + batch;
   last = last + batch;
   
end
end