function [test_data remain_data]=random_test_train(x,p,c)
%c= number of classe;  p=percent of data for testing
I=x(:,end);
s=size(x);
test_data=[];
remain_data=[];
for i=1:c
    temp=find(I==i);
    L=length(temp);
    rate=ceil(L*p);
    X=x(temp,:);
    rand_n=randperm(L);
    n=L-rate;
    remain_data=[remain_data;X(rand_n(1:n),:)];
    test_data=[test_data;X(rand_n(n+1:L),:)];
    
end


        
    