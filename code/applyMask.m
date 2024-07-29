function Is=applyMask(I,M)
I=im2double(I);
% M=im2double(M);
% L=graythresh(M);
% M=im2bw(M,L);
mask=repmat(M,[1,1,3]);
Is=I.*mask;

