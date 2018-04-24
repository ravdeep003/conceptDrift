%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function [normMat, colNorm] = normalization(Amat)
    try
      colNorm = vecnorm(Amat);
    catch
        % older version of matlab doesn't have vecnorm
        colNorm = sqrt(sum(Amat.^2));
    end
    n = size(colNorm, 2);
    normMat = [];
    for i=1:n
        a =  Amat(:,i)/colNorm(i);
            normMat(:,i) = a;
    end
end