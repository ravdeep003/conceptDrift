function [normMat, colNorm] = normalization(Amat)
    colNorm = vecnorm(Amat);
    n = size(colNorm, 2);
    normMat = [];
    for i=1:n
        a =  Amat(:,i)/colNorm(i);
            normMat(:,i) = a;
    end
end