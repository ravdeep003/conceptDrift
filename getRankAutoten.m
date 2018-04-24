%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function estRank=getRankAutoten(X, R)
    n = 10;
    maxRank = 2 * R;
    allRank = zeros(n,1);
    parfor i=1:n
        % [F1, F2, K] = getRankTensor(X, maxRank);
        [Fac ,c ,K] = AutoTen(X, maxRank, 1);
        allRank(i) = K;
    end
    estRank = mode(allRank);
%     disp(allRank);
end