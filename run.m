% rng('default')

close all;clc;clear all;
R = 5; I = 100;
J = 100;
K = 100;
mode = 3;
% [X, A, B, C] = createTensor(R, I, J, K);
% X = X(:,:,1:200);
%X = createConstantRankTensor(R, I, J, K, 100);
% [X,A,B,C] = getData(R, 300);
% a = load('dataset/ten_500_5_d.mat');
% X = a.X;
batch = 50;
% [A,B,C,initialRank, X] = createDatasetGeneric(I,J,K,R,batch);
a = load('test.mat');
A = a.A;
B = a.B;
C = a.C;
initialRank = a.initialRank;
R = a.R;

numExperiments = 20;
filename1 = sprintf('result_%d_%d', K, R);
filename2 = sprintf('rank_%d_%d', K, R);
filename3 = sprintf('error_%d_%d', K, R);
for num =1:numExperiments

first = 1;
last = batch;
% Initial batch for tensor
 
% Xinit = X(:,:,first:last);
Xinit = tensor(ktensor(ones(R,1),A, B ,C(first:last,:)));
% Get Rank using ADRCP
% initialRank = getRankADR(Xinit, 4);
% Get Rank using Autoten

% initialRank = getRankAutoten(Xinit, R);
% For testing
% initialRank = 2;
[Facts ~, out] = cp_als(Xinit, initialRank, 'tol',1.0e-7, 'maxiters', 1000, 'printitn', 0);
% al = Facts.lambda;

% CLARIFY THIS LINEop
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
fit(1) = 1 - out.fit;
rank = zeros(1, iter);
rank(1) = initialRank;
newrho = cell(iter,1);
rho = cell(iter,1);
rho{1} = lambda;
newrho{1} = lambda;
newconcept = cell(iter,1);
overlapconceptold = cell(iter,1);
overlapconceptnew = cell(iter, 1);
missingconcept = cell(iter, 1);

runningRank = initialRank;

% for testing
% iter = 3;
for i=2:iter
    first = last + 1;
    last = i*batch;
%     Xs = X(:,:,first:last);
    Xs = tensor(ktensor(ones(R,1),A, B ,C(first:last,:)));
    r = getRankAutoten(Xs, R);
% For testing, remove this and use getRankAutoten 
%     r = i;
    rank(i) = r;
    [Aupdated, Bupdated, Cupdated, rhoNew, runningRank, newConcept, conceptOverlap, conceptOverlapOld, missingConcept, newRho]= seekAndDestroy(Aupdated, Bupdated, Cupdated, Xs, r, runningRank, mode, newrho{i-1});
    rho{i} = rhoNew;
    newrho{i} = newRho;
    newconcept{i} = newConcept;
    overlapconceptold{i} = conceptOverlapOld;
    overlapconceptnew{i} = conceptOverlap;
    missingconcept{i} = missingConcept;

% l = zeros(iter,1);
c = zeros(size(rho,1),runningRank);
l = zeros(1,runningRank);
for z=1:iter
    a = size(rho{z},2);
    c(z,1:a) = rho{z};
end
 l = sum(c)./sum(c~=0,1);
% l = c./iter;

% l
Xcomputed = ktensor(l',Aupdated, Bupdated, Cupdated);
X = ktensor(ones(R,1),A, B ,C );

% re1 = relativeError(X, Xcomputed1);
re = relativeError(X, Xcomputed);
fit(i) = re;

% disp(re1);
% disp("seekAndDestroy Error");  
disp(re);
% disp("cpALS Error"); disp(cpErr);
end
cpErr = cpALSError(X, R);
% disp("cpALS Error"); disp(cpErr);

result = {re, initialRank, runningRank, R, cpErr, batch, I, J, K};
dlmwrite(filename1, result, '-append');
dlmwrite(filename2, rank, '-append');
dlmwrite(filename3, fit, '-append');

end