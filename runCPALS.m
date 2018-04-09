function [Facts, maxfit] = runCPALS(X, R)
iter = 4;
Facts_cell = cell(iter, 1);
% out_cell = cell(iter,1);
out_fit = zeros(iter,1);
for i = 1:iter
  [Facts_cell{i}, ~, out] = cp_als(X, R, 'tol',1.0e-7, 'maxiters', 1000, 'printitn', 0);
  out_fit(i) = out.fit;
%    disp(i);
%    F.lambda'= F;
%    out_cell(i) = out.fit;
end
% out_cell'

[maxfit, index] = max(out_fit);
if maxfit > 0.95
    Facts = Facts_cell{index};
else 
    warning('unstable cp_als fit');
end
end