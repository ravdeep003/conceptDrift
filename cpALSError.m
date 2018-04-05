function err = cpALSError(X, R)
Fact = cp_als(X,R, 'tol',1.0e-7, 'maxiters', 1000);
Xnew = tensor(ktensor(Fact.lambda, Fact.U{1}, Fact.U{2}, Fact.U{3}));
Fact.lambda
err = relativeError(X, Xnew);
end