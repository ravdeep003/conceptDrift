tic;
ticBytes(gcp);
parfor kk=1:4
fname = sprintf('dataset/test/ten_100_10_%d.mat', kk);
% t = getCurrentTask();
% fname
run(fname, t.ID, kk);
% run(fname, 999, kk);
end
tocBytes(gcp)
toc