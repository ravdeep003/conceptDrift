function err = cpALSError(X, R)
[Fact, ~, out] = cp_als(X,R, 'printitn',0);
% out.fit;
Xnew = ktensor(Fact.lambda, Fact.U{1}, Fact.U{2}, Fact.U{3});
% Fact.lambda;
err = relativeError(X, Xnew);
end