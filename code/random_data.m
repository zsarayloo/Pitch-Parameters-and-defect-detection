function r=random_data(I)
[a b]=size(I);
k=randperm(a);
r=I(k,:);
