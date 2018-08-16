%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function runReal(fname, wid, kk)
%
numExperiments = 10;
for num =1:numExperiments
close all;clc; clearvars -except fname num numExperiments kk wid;
mode = 3;

%For synthetic data, use the below variables
% a = load(fname);
% A = a.A;
% B = a.B;
% C = a.C;
% batch = a.batch;
% initialRank = a.initialRank;
% R = a.R;
% I = size(A,1);
% J = size(B,1);
% K = size(C,1);

% For real data,
a = load(fname);
% this variable would depend on how you saved the tensor in .mat file. 
X = tensor(a.Y);
I = size(X,1); 
J = size(X,2);
K = size(X,3);
% batch size would depend on the data and user's choice.
batch = round(0.1*K);
% Using Autoten to get an estimation of whole tensor.
% Autoten takes tensor and some candidate rank, which we double in
% getRankAutoten before passing it to Autoten.
candidateRank = 4 ;
R = getRankAutoten(X, candidateRank);

filename1 = sprintf('results/result_%d_%d_real_%d', K, R, wid);
filename2 = sprintf('results/rank_%d_%d_real_%d', K, R, wid);
filename3 = sprintf('results/error_%d_%d_real_%d', K, R, wid);

first = 1;
last = batch;

% Initial batch for tensor for real dataset 
Xinit = X(:,:,first:last);

% Initial batch for tensor for synthetic dataset
% Xinit = tensor(ktensor(ones(R,1),A, B ,C(first:last,:)));
 



% Real data. Get initial Rank using Autoten
initialRank = getRankAutoten(Xinit, R);

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
    Xs = X(:,:,first:last);
% for synthetic data
%       Xs = tensor(ktensor(ones(R,1),A, B ,C(first:last,:)));
%       Xs = ktensor(ones(R,1),A, B ,C(first:last,:));

%     Autoten Rank
      r = getRankAutoten(Xs, R);
%     Oracle Rank for synthetic data
  %    r = size(find(sum(C(first:last,:)>0)),2);

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

% For synthetic data
%X = tensor(ktensor(ones(R,1),A, B ,C(1:last,:)));

re = relativeError(X(:,:,1:last), Xcomputed);

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