tic;
ticBytes(gcp);

parfor kk=1:2
fname = sprintf('dataset/ten_100_10_%d.mat', kk);
t = getCurrentTask();
% fname
run(fname, t.ID, kk);
% If not using parfor, use some random value instead of t.ID
% run(fname, 999, kk);
end
tocBytes(gcp)
toc