function [X, A, B, C]=createTensor(Rank, I, J, K)
    R = Rank;
    [X, A, B, C] = newdata(R, I, J, K);
%     A=zeros(I,R);
%     B=zeros(J,R);
%     C=zeros(K,R);
%     
%     A(1:2*(I/5),1) = rand(2*(I/5),1);
%     A(2*(I/5)+1:4*(I/5),2) = rand(2*(I/5),1);
%     A(1:2*(I/5),3) = rand(2*(I/5),1);
%     A(4*(I/5)+1:end,3) = rand(I/5,1);
%     A(3*(I/5)+1:end,4) = rand(2*(I/5),1);
%     A(1:3*(I/5),5) = rand(3*(I/5), 1);
% 
%     B =A;
%     
%     C(1:I/5,1) = rand(I/5,1);
% %     C(3*(I/5)+1:4*(I/5),1) = rand(I/5,1);
%     C(2*(I/5)+1:4*(I/5),2) = rand(2*(I/5),1);
%     C(1:2*(I/5),3) = rand(2*(I/5),1);
%     C(4*(I/5)+1:end,3) = rand(I/5,1);
%     C(3*(I/5)+1:end,4) = rand(2*(I/5), 1);
%     C((I/5)+1:3*(I/5),5) = rand(2*(I/5), 1);
%     
%      X = tensor(ktensor(ones(R,1),A, B ,C ));
end


function[X, A, B, C]= newdata(R, I, J, K)
    A=zeros(I,R);
    B=zeros(J,R);
    C=zeros(K,R);
    
    A(1:I/5,1) = rand(I/5,1);
    A(2*(I/5)+1:3*(I/5),1) = rand(I/5,1);
    A(1:I/5,2) = rand(I/5,1);
    A(3*(I/5)+1:4*(I/5),2) = rand(I/5,1);
    A(I/5+1:2*(I/5),3) = rand(I/5,1);
    A(3*(I/5)+1:4*(I/5),3) = rand(I/5,1);
    A(I/5+1:2*(I/5),4) = rand(I/5,1);
    A(4*(I/5)+1:end,4) = rand(I/5,1);
    A(2*(I/5)+1:3*(I/5),5) = rand(I/5,1);
    A(4*(I/5)+1:end,5) = rand(I/5,1);

    B =A;
    
    C(1:I/10,1) = rand(I/10,1);
    C(I/10+1:I/5,2) = rand(I/10,1);
    C(I/5+1:3*(I/10),3) = rand(I/10,1);
    C(3*(I/10)+1:4*(I/10), 4) = rand(I/10,1);
    C(4*(I/10)+1:I/2, 5) = rand(I/10,1);
    C(I/2+1:6*(I/10),1) = rand(I/10,1);
    C(6*(I/10)+1:7*(I/10),2) = rand(I/10,1);
    C(7*(I/10)+1:8*(I/10),3) = rand(I/10,1);
    C(8*(I/10)+1:9*(I/10), 4) = rand(I/10,1);
    C(9*(I/10)+1:I, 5) = rand(I/10,1);
    
%     A(A>0) = 1;
%     B(B>0) = 1;
%     C(C>0) = 1;
    
     X = tensor(ktensor(ones(R,1),A, B ,C ));
end
