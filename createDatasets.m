%Ravdeep Pasricha , Ekta Gujral, Vagelis Papalexakis 2018
%Computer Science and Engineering, University of California, Riverside
function createDatasets(I,J,K,R,batch,numofDatasets)
for i = 1:numofDatasets
[A,B,C,initialRank] =  createDatasetGeneric(I, J, K, R,batch);
fname = sprintf('dataset/test/ten_%d_%d_%d.mat', K, R, i);
save(fname, 'A', 'B', 'C', 'initialRank', 'R', 'batch');
if initialRank ~= 2
    disp("Check code")
end
end

