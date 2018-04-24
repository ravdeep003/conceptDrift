%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function err = cpALSError(X, R)
[Fact, ~, out] = cp_als(X,R, 'tol',1.0e-7, 'maxiters', 1000, 'printitn',0);
% out.fit;
Xnew = tensor(ktensor(Fact.lambda, Fact.U{1}, Fact.U{2}, Fact.U{3}));
% Fact.lambda;
err = relativeError(X, Xnew);
end