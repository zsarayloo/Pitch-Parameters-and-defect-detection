
function [F] = wavelet_feature(imageFile)

% Load image
I = imread(imageFile);

I = rgb2gray(I);
[rows, cols] = size(I);


I=imresize(I,[ceil(rows/50)*50 ceil(cols/50)*50]);
D=I;D1=I;
s=size(I);


w=50;
k1=(s(1)/w)*(s(2)/w);
B=zeros(w,w,k1);

k=1;

for i=1:w:s(1)
    for j=1:w:s(2)
        B(:,:,k)=I(i:i+w-1,j:j+w-1);
        k=k+1;
    end
end

G=zeros(k1,8);

for i=1:k1
    [cA,cH,cV,cD] = dwt2(B(:,:,i),'db2');
    G(i,1)=mean(mean(cA));
    G(i,2)=std(std(cA));
    G(i,3)=mean(mean(cH));
    G(i,4)=std(std(cH));
    G(i,5)=mean(mean(cV));
    G(i,6)=std(std(cV));
    G(i,7)=mean(mean(cD));
    G(i,8)=std(std(cD));
end
F=G;
