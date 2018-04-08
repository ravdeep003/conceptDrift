for kk=1:2
% fname=sprintf('/home/egujr001/MATLAB/Projects/SDM18_SAMBATEN/NEW/datasets/ten_100/ten_100_10_%d.mat',kk);
fname = sprintf('dataset/test/ten_500_10_%d.mat', kk);
fname
run(fname);
end