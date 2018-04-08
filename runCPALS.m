function [Facts, maxfit] = runCPALS(X, R)
iter = 4;
Facts_cell = cell(iter, 1);
out_cell = zeros(iter,1);
for i = 1:iter
  [F, ~, out] = cp_als(X, R, 'tol',1.0e-7, 'maxiters', 1000, 'printitn', 0);
   Facts_cell{i} = F;
%    disp(i);
%    F.lambda'
   out_cell(i) = out.fit;
end
out_cell'
[maxfit, index] = max(out_cell);
if maxfit > 0.9
    Facts = Facts_cell{index};
else 
    warning("unstable cp_als fit");
end
end