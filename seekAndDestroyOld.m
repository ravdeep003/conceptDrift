%% seekAndDestroy: Takes Factors of tensor and batch of new slices as input.
%% Detects the type of drift and update the factors accordingly

function [Aupdated, Bupdated, Cupdated, rho, currentRank, highestRank] = seekAndDestroy(Aold, Bold, Cold, oldLambda, Xs, R, highRank)
    % For autoten
    % Scaling Factor is rho
    % maxrank = R * 2;
    % [F1, F2, K] = getRankTensor(Xs, maxrank);

    % For ARDCP
    % K = getRankADR(Xs, R);
    % Using Autoten
%     K = getRankAutoten(Xs, R);
    K =5;
    
    if K >= highRank
        highestRank = K;
    elseif highRank > K
        highestRank =  highRank;
    end
    currentRank = K;

    initOpt.printitn = 0;
    if K > R
        % currentRank = K;
        F = cp_als(Xs, K, 'printitn', 0);
        fprintf('Rank increased');
        lambda = F.lambda;
        A = F.U{1};
        B = F.U{2};
        C = F.U{3};
        bestPermA = matchAndPermute(Aold, A, highestRank, K, lambda);
        bestPermB = matchAndPermute(Bold, B, highestRank, K, lambda);
        bestPermC = matchAndPermute(Cold, C, highestRank, K, lambda);
        newComponentsA = setdiff([1:highestRank],bestPermA);
        newComponentsB = setdiff([1:highestRank],bestPermB);
        newComponentsC = setdiff([1:highestRank],bestPermC);
        A = A * diag(lambda.^(1/3));
        B = B * diag(lambda.^(1/3));
        C = C * diag(lambda.^(1/3));


        [normMatA, colA]=normalization(A);
        [normMatB, colB]=normalization(B);
        [~, colC]=normalization(C);
        %  This case works when A and B are not sampled.
        Cnorm = C * diag(1./colC);
        Aupdated = [Aold normMatA(:, newComponentsA)];
        Bupdated = [Bold normMatB(:, newComponentsB)];
        Cupdated = updateIncrease(Cold, Cnorm, bestPermC, newComponentsC);

        rho = colA .* colB .*colC;
        % lambdaUpdated = updateLambda(oldLambda, lambda, R, K);
%         lambdaVal = lambdaNewUpdate(A, B, C)
    elseif K < R
        fprintf('Rank decreased');
        % currentRank = K;
        F = cp_als(Xs, K, 'printitn', 0);
        lambda = F.lambda;
        A = F.U{1};
        B = F.U{2};
        C = F.U{3};
        disp(K);
        bestPermA = matchAndPermute(Aold, F.U{1}, highestRank, K, lambda);
        bestPermB = matchAndPermute(Bold, F.U{2}, highestRank, K, lambda);
        bestPermC = matchAndPermute(Cold, F.U{3}, highestRank, K, lambda);
        missingComponentsA = setdiff([1:highestRank],bestPermA);
        missingComponentsB = setdiff([1:highestRank],bestPermB);
        missingComponentsC = setdiff([1:highestRank],bestPermC);
        A = A * diag(lambda.^(1/3));
        B = B * diag(lambda.^(1/3));
        C = C * diag(lambda.^(1/3));


        [normMatA colA]=normalization(A);
        [normMatB colB]=normalization(B);
        [normMatC colC]=normalization(C);
        %  This case works when A and B are not sampled.
        Cnorm = C * diag(1./colC);
        Aupdated = Aold;
        Bupdated = Bold;
        Cupdated = updateDecrease(Cold, Cnorm, bestPermC);
        % lambdaUpdated = updateLambda(oldLambda, lambda, R, K);

        rho = colA .* colB .*colC;
        % lambdaUpdated = lambda;
    else
        fprintf('Rank Unchanged! Might have a drift in node membership.')
        F = cp_als(Xs, K, 'printitn', 0);
        lambda = F.lambda;

        A = F.U{1} * diag(lambda.^(1/3));
        B = F.U{2} * diag(lambda.^(1/3));
        C = F.U{3} * diag(lambda.^(1/3));
        % currentRank = R;
        [normMatA colA]=normalization(A);
        [normMatB colB]=normalization(B);
        [normMatC colC]=normalization(C);
        Cnorm = C * diag(1./colC);
        Aupdated = Aold;
        Bupdated = Bold;
        bestPermC = matchAndPermute(Cold, C, highestRank, K, F.lambda);
%         Cupdated = [Cold;Cnorm(:,bestPermC)];
        if(highestRank > K)
            Cupdated = updateDecrease(Cold, Cnorm, bestPermC);
        elseif highestRank == K
             Cupdated = [Cold;Cnorm(:,bestPermC)];
        end
            
         rho = colA .* colB .*colC;




    end
end

function bestPerm = matchAndPermute(Aold, Anew, R, K, lambda)
    oldRank = R;
    newRank = K;
    oldCol = 1:R;
    newCol = 1:K;
    % Anew = Anew * diag(lambda.^(1/3));
    normAold = normalization(Aold);
    normAnew = normalization(Anew);
    disp(size(normAold));
    disp(size(normAnew));


    if newRank > oldRank
        comb = combnk(newCol, R);
        iter = size(comb,1);
        allcomb = [];
        for i = 1:iter
            allcomb = [allcomb; perms(comb(i,:))];
        end
        sumVal = 0;
        for j = 1:size(allcomb,1)
          sumDot = sum(dot(normAold(end-size(normAnew,1) + 1:end,:), normAnew(:,allcomb(j,:))));
          if sumDot > sumVal
              sumVal = sumDot;
              bestPerm = allcomb(j,:);
          elseif sumDot > min(R,K)
              % Error Handling
              % if normalized correctly this part of the code should never execute
              fprintf('Something has gone wrong');
          end
        end
    elseif oldRank > newRank
        comb = combnk(oldCol, K);
        iter = size(comb,1);
        allcomb = [];
        for i = 1:iter
            allcomb = [allcomb; perms(comb(i,:))];
        end
        sumVal = 0;
        for j = 1:size(allcomb,1)
          sumDot = sum(dot(normAold(end-size(normAnew,1)+1:end, allcomb(j,:)), normAnew));
          if sumDot > sumVal
              sumVal = sumDot;
              bestPerm = allcomb(j,:);
          elseif sumDot > min(R,K)
              % Error Handling
              % if normalized correctly this part of the code should never execute
              fprintf('Something has gone wrong');
          end
        end
     else
        comb = combnk(oldCol, K);
        iter = size(comb,1);
        allcomb = [];
        for i = 1:iter
            allcomb = [allcomb; perms(comb(i,:))];
        end
        sumVal = 0;
        for j = 1:size(allcomb,1)
          sumDot = sum(dot(normAold(end-size(normAnew,1)+1:end, :), normAnew(:,allcomb(j,:))));
          if sumDot > sumVal
              sumVal = sumDot;
              bestPerm = allcomb(j,:);
          elseif sumDot > min(R,K)
              % Error Handling
              % if normalized correctly this part of the code should never execute
              fprintf('Something has gone wrong');
          end
        end

    end


end



function updatedC = updateIncrease(Cold, Cnew, bestPerm, newComponents)
    updatedC = [Cold; Cnew(:, bestPerm)];
    newCol = zeros(size(Cold,1), size(newComponents,2));
    newCol = [newCol; Cnew(:,newComponents)];
    updatedC = [updatedC newCol];
end

function lambda = updateLambda(oldLambda, newLambda, oldRank, newRank)
    if newRank > oldRank
        lambda = (oldLambda + newLambda(1:oldRank,:))/2;
        lambda = [lambda; newLambda(oldRank+1:newRank,:)];
    elseif oldRank > newRank
        lambda = (oldLambda(1:newRank,:) + newLambda)/2;
        lambda = [lambda; oldLambda(newRank+1:oldRank,:)];
    end
end

function updatedC = updateDecrease(Cold, Cnew, bestPerm)
    newMat = zeros(size(Cnew,1), size(Cold, 2));
    newMat(:,bestPerm) = Cnew;
    updatedC = [Cold; newMat];
end

function = updateFactors(A, B, C);



end