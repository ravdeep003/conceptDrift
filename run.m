% rng('default')
close all;clc;clear all;
R = 5; I = 200;
J = 200;
K = 1000;
mode = 3;
% [X, A, B, C] = createTensor(R, I, J, K);
% X = X(:,:,1:200);
%X = createConstantRankTensor(R, I, J, K, 100);
% [X,A,B,C] = getData(R, 300);
% a = load('dataset/ten_500_5_d.mat');
% X = a.X;
batch = 100;
[A,B,C,initialRank, X] = createDatasetGeneric(I,J,K,R,batch);

first = 1;
last = batch;
% Initial batch for tensor
 
Xinit = X(:,:,first:last);
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
fit = zeros(iter,1);
fit(1) = out.fit;
rank = zeros(iter,1);
rank(1) = initialRank;
newrho = cell(iter,1);
rho = cell(iter,1);
rho{1} = lambda;
newrho{1} = lambda;
newconcept = cell(iter,1);
overlapconceptold = cell(iter,1);
overlapconceptnew = cell(iter, 1);

runningRank = initialRank;

% for testing
% iter = 3;
for i=2:iter
    first = last + 1;
    last = i*batch;
    Xs = X(:,:,first:last);
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



    

% l = zeros(iter,1);
c = zeros(1,runningRank);
for z=1:iter
    a = size(rho{z},2);
    c(1:a) = c(1:a) + rho{z};
end
l = c./iter;

% l
Xcomputed = tensor(ktensor(l',Aupdated, Bupdated, Cupdated));
% re1 = relativeError(X, Xcomputed1);
re = relativeError(X(:,:,1:last), Xcomputed);
fit(i) = re;

% disp(re1);
disp("seekAndDestroy Error");  disp(re);
% disp("cpALS Error"); disp(cpErr);
end
cpErr = cpALSError(X, R);
disp("cpALS Error"); disp(cpErr);
% l1 = c.^(1/mode);
% l1 = ones(runningRank,1);
% Xcomputed1 = tensor(ktensor(l1,Aupdated, Bupdated, Cupdated));


% [newConcept, overlapConceptOld, overlapConceptNew] = findConceptOverlap(normMatB, normMatB2);
% disp("B")
%   disp("New");disp(newConcept);
%     disp("OverlapOld");disp(overlapConceptOld);
%     disp("Overlapnew");disp(overlapConceptNew);
%     
% [newConcept, overlapConceptOld, overlapConceptNew] = findConceptOverlap(normMatC, normMatC2);
% disp("C")
%   disp("New");disp(newConcept);
%     disp("OverlapOld");disp(overlapConceptOld);
%     disp("Overlapnew");disp(overlapConceptNew);
% 
% disp(rank);
% if newConcept
%     disp("New Concept added");
% else
%     disp("Overlap")
% end

% currentRank = R;
% F = cp_als(Xinit, initialRank);
% lambda = F.lambda;
% % Aold = F.U{1};
% % Bold = F.U{2};
% % Cold = F.U{3};
% 
% Aold = F.U{1} * diag(lambda.^(1/3));
% Bold = F.U{2} * diag(lambda.^(1/3));
% Cold = F.U{3} * diag(lambda.^(1/3));
% 
% [normMatA, colA] = normalization(Aold);
% [normMatB, colB] = normalization(Bold);
% [normMatC, colC] = normalization(Cold);
% lambda = colA .* colB .*colC;
% 
% runningRank = initialRank;
% 
% [Anew, Bnew, Cnew, newLambda, currentRank, runningRank] = seekAndDestroy(normMatA, normMatB, normMatC, lambda, X(:,:,31:60), initialRank, runningRank);
% [Anew1, Bnew1, Cnew1, newLambda1, finalRank,runningRank ] = seekAndDestroy(Anew, Bnew, Cnew, newLambda, X(:,:,61:100), currentRank, runningRank);
% % [Anew2, Bnew2, Cnew2, newLambda2, finalRan2,runningRank ] = seekAndDestroy(Anew1, Bnew1, Cnew1, newLambda, X(:,:,71:100), finalRank, runningRank);
% 
% % testingLambda = ones(currentRank,1);
% % for i=1:currentRank
% %     testingLambda(i,:) = norm(Anew(:,i)) + norm(Bnew(:,i)) + norm(Cnew(:,i));
% % end
% 
% maxlen = max([length(lambda), length(newLambda), length(newLambda1)]);
% lambda(end+1:maxlen) = 0;
% newLambda(end+1:maxlen) = 0;
% newLambda1(end+1:maxlen) = 0;
% % newLambda2(end+1:maxlen) = 0;
% 
% a = [lambda newLambda newLambda1];
% l = [];
% for i=1:maxlen
%     c = a(:,i);
%     l(i) = mean(c(c~=0));
% end
% % l = mean(a);
% Xcomputed = tensor(ktensor(l',Anew1, Bnew1,Cnew1));
% % Xcomputed = tensor(ktensor(ones(R,1), Anew, Bnew,Cnew));
% % Xcomputed =  sptensor(reshape(khatrirao(Bnew,Anew)*Cnew',[300 300 300]));
% re = relativeError(X, Xcomputed);
% disp(re);