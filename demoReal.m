tic;
ticBytes(gcp);

% parfor kk=1:2
% set path to dataset.
fname = sprintf('<path/to/dataset>');
% t = getCurrentTask();
% fname
% run(fname, t.ID, kk);
% If not using parfor, use some random value instead of t.ID and kk, these
% are just for keeping track. 
runReal(fname, 999, 9999);
% end
tocBytes(gcp)
toc