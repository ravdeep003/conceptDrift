clear all;close all;clc;
% I,J,K should be multiple of 100
I=100;R=3;
J=I;K=I;
A=zeros(I,R);B=zeros(J,R);C=zeros(K,R);

if(R==3)
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

    A(A>0) = 1;
    B(B>0) = 1;
    C(C>0) = 1;
    X=sptensor(reshape(khatrirao(B,A)*C',[I J K]));
    

end
if(R==4)
    A(1:I/2,1)=rand(I/2,1);A((3*I/4)+1:I,1)=rand(I/4,1);A(1:I/5,2)=rand(I/5,1);A((I/4)+1:3*I/4,2)=rand(I/2,1);A(I/5+1:I/2,3)=rand(3*I/10,1);A(7*I/10+1:I,3)=rand(3*I/10,1);
    A(1:I/4,4)=rand(I/4,1);
    A((I/2)+1:(3*I/4),4)=rand(I/4,1);
    B(1:I/2,1)=rand(I/2,1);B((3*I/4)+1:I,1)=rand(I/4,1);B(1:I/5,2)=rand(I/5,1);B((I/4)+1:3*I/4,2)=rand(I/2,1);B(I/5+1:I/2,3)=rand(3*I/10,1);B(7*I/10+1:I,3)=rand(3*I/10,1);
    B(1:I/4,4)=rand(I/4,1);B((I/2)+1:(3*I/4),4)=rand(I/4,1);
    C(1:K/4,1)=rand(K/4,1);C((K/4)+1:3*K/4,[2 3])=rand(K/2,2);C((3*K/4)+1:K,4)=rand(K/4,1);
    A(A>0) = 1;
    B(B>0) = 1;
    C(C>0) = 1;
    X=sptensor(reshape(khatrirao(B,A)*C',[I J K]));
end
if(R==5)
    A(1:I/2,1)=rand(I/2,1);A((3*I/4)+1:I,1)=rand(I/4,1);A(1:I/5,2)=rand(I/5,1);A((I/4)+1:3*I/4,2)=rand(I/2,1);A(I/5+1:I/2,3)=rand(3*I/10,1);A(7*I/10+1:I,3)=rand(3*I/10,1); A(1:I/4,4)=rand(I/4,1);A((I/2)+1:(3*I/4),4)=rand(I/4,1);A(1:I/2,5)=rand(I/2,1);
    B(1:I/2,1)=rand(I/2,1);B((3*I/4)+1:I,1)=rand(I/4,1);B(1:I/5,2)=rand(I/5,1);B((I/4)+1:3*I/4,2)=rand(I/2,1);B(I/5+1:I/2,3)=rand(3*I/10,1);B(7*I/10+1:I,3)=rand(3*I/10,1); B(1:I/4,4)=rand(I/4,1);B((I/2)+1:(3*I/4),4)=rand(I/4,1);B(1:I/2,5)=rand(I/2,1);
    C(1:K/4,1)=rand(K/4,1);C((K/4)+1:3*K/4,[2 3])=rand(K/2,2);C((3*K/4)+1:K,[4 5])=rand(K/4,2);
    A(A>0) = 1;
    B(B>0) = 1;
    C(C>0) = 1;
    X=sptensor(reshape(khatrirao(B,A)*C',[I J K]));
end
%
%    Fac1=cp_als(X(:,:,1:20),R);C1 = Fac1.U{3}; C1(C1>0)=1;C1(C1<0)=0;
%    Fac2=cp_als(X(:,:,21:40),R);C2 = Fac2.U{3};C2(C2>0)=1;C2(C2<0)=0;
%    Fac3=cp_als(X(:,:,41:60),R);C3 = Fac3.U{3};C3(C3>0)=1;C3(C3<0)=0;
%    Fac4=cp_als(X(:,:,61:80),R);C4 = Fac4.U{3};C4(C4>0)=1;C4(C4<0)=0;
%    Fac5=cp_als(X(:,:,81:100),R);C5 = Fac5.U{3};C5(C5>0)=1;C5(C5<0)=0;

% X1=sptensor(reshape(khatrirao(B,A)*C(:,1:20)',[I J 20]));

rank = getRankADR(X,R)
