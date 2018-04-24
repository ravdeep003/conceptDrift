%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function run(fname, wid, kk)
%
numExperiments = 10;
for num =1:numExperiments
close all;clc; clearvars -except fname num numExperiments kk wid;
mode = 3;
a = load(fname);
A = a.A;
B = a.B;
C = a.C;
batch = a.batch;
initialRank = a.initialRank;
R = a.R;
I = size(A,1);
J = size(B,1);
K = size(C,1);

filename1 = sprintf('results/result_%d_%d_nirvana_%d', K, R, wid);
filename2 = sprintf('results/rank_%d_%d_nirvana_%d', K, R, wid);
filename3 = sprintf('results/error_%d_%d_nirvana_%d', K, R, wid);

first = 1;
last = batch;
% Initial batch for tensor 
% Xinit = X(:,:,first:last);
Xinit = tensor(ktensor(ones(R,1),A, B ,C(first:last,:)));
 



% Get Rank using Autoten
% initialRank = getRankAutoten(Xinit, R);

% [Facts ~, out] = cp_als(Xinit, initialRank, 'tol',1.0e-7, 'maxiters', 1000, 'printitn', 0);

[Facts, out] = runCPALS(Xinit, initialRank);

lambda = diag(Facts.lambda.^(1/mode));
A_init = Facts.U{1} * lambda;
B_init = Facts.U{2} * lambda;
C_init = Facts.U{3} * lambda;

[Aupdated, colA] = normalization(A_init);
[Bupdated, colB] = normalization(B_init);
[Cupdated, colC] = normalization(C_init);


lambda = colA .* colB .* colC;


iter = K/batch;
fit = zeros(1,iter);
fit(1) = 1 - out;
rank = zeros(1, iter);
rank(1) = initialRank;
rho = cell(iter,1);
rho{1} = lambda;
newconcept = cell(iter,1);
overlapconceptold = cell(iter,1);
overlapconceptnew = cell(iter, 1);
missingconcept = cell(iter, 1);

runningRank = initialRank;


for i=2:iter
    first = last + 1;
    last = i*batch;
%     Xs = X(:,:,first:last);
      Xs = tensor(ktensor(ones(R,1),A, B ,C(first:last,:)));
%       Xs = ktensor(ones(R,1),A, B ,C(first:last,:));

%     Autoten Rank
%     r = getRankAutoten(Xs, R);
%     Oracle Rank
      r = size(find(sum(C(first:last,:)>0)),2);

    rank(i) = r;
    [Aupdated, Bupdated, Cupdated, rhoNew, runningRank, newConcept, conceptOverlap, conceptOverlapOld, missingConcept]= seekAndDestroy(Aupdated, Bupdated, Cupdated, Xs, r, runningRank, mode);
    rho{i} = rhoNew;
    newconcept{i} = newConcept;
    overlapconceptold{i} = conceptOverlapOld;
    overlapconceptnew{i} = conceptOverlap;
    missingconcept{i} = missingConcept;

c = zeros(size(rho,1),runningRank);
l = zeros(1,runningRank);
for z=1:iter
    a = size(rho{z},2);
    c(z,1:a) = rho{z};
end
 l = sum(c)./sum(c~=0,1);


Xcomputed = tensor(ktensor(l',Aupdated, Bupdated, Cupdated));
X = tensor(ktensor(ones(R,1),A, B ,C(1:last,:)));

re = relativeError(X, Xcomputed);

fit(i) = re;

% disp(re1);
% disp("seekAndDestroy Error");  
% disp(re);
% disp("cpALS Error"); disp(cpErr);
end
cpErr = cpALSError(X, R);
% disp("cpALS Error"); disp(cpErr);

result = {re, initialRank, runningRank, R, cpErr, batch, I, J, K, kk};
dlmwrite(filename1, result, '-append');
dlmwrite(filename2, rank, '-append');
dlmwrite(filename3, fit, '-append');

end
end