%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function C = generateC(R,batch)
% R = 5;
sum = 0;
for i = 2:R
    sum = sum + nchoosek(R,i);
end
C = zeros(sum*batch, R);
initial = 0.3*batch;
last = batch;
for i =2:R
    allcomb = combnk(1:R,i);
    iter = size(allcomb,1);
    for j = 1:iter
        C(initial:last,allcomb(j,:)) = rand(last-initial +1,i);
        initial = initial + batch;
        last = last + batch;
    end
end