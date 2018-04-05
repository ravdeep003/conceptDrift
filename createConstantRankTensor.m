function X = createConstantRankTensor(Rank, I, J, K, batchSize)
    % Assumes all indexes have same value
    % Batch size should be a multiple of I(J,K)
    iter = I/batchSize;
    X = tensor(zeros(I,J,K));
    first = 1; 
    last = batchSize;
    for i=1:iter
        Xs = createData(Rank, I, J, batchSize);
        X(:,:,first:last) = Xs;
        first = last + 1;
        last = (i+1)*batchSize;
    end
end

function X = createData(R,I,J,K)
    A=zeros(I,R);B=zeros(J,R);C=zeros(K,R);
    A(1:I/2,1)=rand(I/2,1);
    A((3*I/4)+1:I,1)=rand(I/4,1);
    A(1:I/5,2)=rand(I/5,1);
    A((I/4)+1:3*I/4,2)=rand(I/2,1);
    A(I/5+1:I/2,3)=rand(3*I/10,1);
    A(7*I/10+1:I,3)=rand(3*I/10,1);

    B(1:I/2,1)=rand(I/2,1);
    B((3*I/4)+1:I,1)=rand(I/4,1);
    B(1:I/5,2)=rand(I/5,1);
    B((I/4)+1:3*I/4,2)=rand(I/2,1);
    B(I/5+1:I/2,3)=rand(3*I/10,1);
    B(7*I/10+1:I,3)=rand(3*I/10,1);

    C(1:K/2,1)=rand(K/2,1);
    C((K/2)+1:K,[2 3])=rand(K/2,2);
    
    X = tensor(ktensor(ones(R,1),A, B ,C ));

end