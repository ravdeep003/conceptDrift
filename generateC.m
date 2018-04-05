function C = generateC(R)
% R = 5;
sum = 0;
for i = 2:R
    sum = sum + nchoosek(R,i);
end
C = zeros(sum*100, R);
initial = 26;
last = 100;
for i =2:R
    allcomb = combnk(1:R,i);
    iter = size(allcomb,1);
    for j = 1:iter
        C(initial:last,allcomb(j,:)) = rand(75,i);
        initial = initial + 100;
        last = last + 100;
    end
end