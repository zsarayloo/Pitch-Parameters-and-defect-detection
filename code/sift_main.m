%% feature extraction

clear all
clc
%% sift feature
% for i=1:30
%     [imaged, descriptorsd, locsd] = sift(sprintf('ImD (%d).jpg',i));
%     [imageh, descriptorsh, locsh] = sift(sprintf('ImH (%d).jpg',i));
%     
%     save(sprintf('descriptorsd (%d).mat',i),'descriptorsd','locsd');
%     save(sprintf('descriptorsh (%d).mat',i),'descriptorsh','locsh');
%     
% end
% for i=1:30
%     load(sprintf('descriptorsh (%d).mat',i));
%     load(sprintf('descriptorsd (%d).mat',i));
%     descriptorsd=normal_mat( descriptorsd);
%     descriptorsh=normal_mat( descriptorsh);
%     M=mean(descriptorsd,1);
% %     S=std(descriptorsd,1);
%     M1=mean(descriptorsh,1);
% %     S1=std(descriptorsh,1);
%     SIFTd(i,:)=[M];
%     SIFTh(i,:)=[M1];
% end
% save('SIFTd.mat','SIFTd');
% save('SIFTh.mat','SIFTh');
% 
% plot3(SIFTd(:,7), SIFTd(:,8), SIFTd(:,9),'*')
% hold on
% plot3(SIFTh(:,7), SIFTh(:,8), SIFTh(:,9),'*')

%% wavelet feAture
for i=1:30
    waved = wavelet_feature(sprintf('ImD (%d).jpg',i));
    waveh = wavelet_feature(sprintf('ImH (%d).jpg',i));
    waved=normal_mat( waved);
    waveh=normal_mat( waveh);
    Waved(i,:)=mean(waved,1);
    Waveh(i,:)=mean(waveh,1);
    
    
end
% save('Waved.mat','Waved');
% save('Waveh.mat','Waveh');
subplot(2,1,1)
plotmatrix(Waved)
title('wavelet feature of defected pitch')
subplot(2,1,2)
plotmatrix(Waveh)
title('wavelet feature of Helthly pitch')



plot3(Waved(:,4), Waved(:,5), Waved(:,6),'*')
hold on
plot3(Waveh(:,4), Waveh(:,5), Waveh(:,6),'*')

%% Hough transform feature

% for i=1:30
%     
% I=imread(sprintf('ImD (%d).jpg',i));
% I1=imread(sprintf('ImH (%d).jpg',i));
% 
% I(:,:,1)=medfilt2(I(:,:,1));
% I(:,:,2)=medfilt2(I(:,:,2));
% I(:,:,3)=medfilt2(I(:,:,3));
% 
% I1(:,:,1)=medfilt2(I1(:,:,1));
% I1(:,:,2)=medfilt2(I1(:,:,2));
% I1(:,:,3)=medfilt2(I1(:,:,3));
% 
% I  = rgb2gray(I);
% I1  = rgb2gray(I1);
% 
% % Extract edges.
% BW = edge(I,'canny');
% [H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89.5);
% P  = houghpeaks(H,3);
% 
% BW1 = edge(I1,'canny');
% [H1,T1,R1] = hough(BW1,'RhoResolution',0.5,'Theta',-90:0.5:89.5);
% P1  = houghpeaks(H1,3);
% end


%% FFT feature


for i=1:30
    
I=imread(sprintf('ImD (%d).jpg',i));
I1=imread(sprintf('ImH (%d).jpg',i));
I=rgb2gray(I);
I1=rgb2gray(I1);

F1=double(I-(mean(mean(I))));
fftA=fft2(F1);
mag =abs(fftshift(fftA));
phase = angle(fftshift(fftA));

S=size(mag);
k=S(1)*S(2);

normal_M=(mag-min(min(mag)))./max(max(mag));
level = graythresh(normal_M);
BW = im2bw(normal_M,level);
STATS.i = regionprops(BW,'Centroid');

[L, NUM(1,i)] = bwlabeln(BW);


F1=double(I1-(mean(mean(I1))));
fftA1=fft2(F1);
mag1 =abs(fftshift(fftA1));
phase1 = angle(fftshift(fftA1));

S=size(mag1);
k1=S(1)*S(2);

normal_M1=(mag1-min(min(mag1)))./max(max(mag1));
level = graythresh(normal_M1);
BW1 = im2bw(normal_M1,level);
STATS1 = regionprops(BW1,'Centroid');
[L1, NUM1(1,i)] = bwlabeln(BW1);
figure
subplot(2,1,1)
imshow(I)
title(sprintf('Original image number(%d)',i));
subplot(2,1,2)
imshow(BW)
title(sprintf('fft of defected pitch(%d)',i));

% figure
% subplot(2,1,1)
% imshow(I1)
% title(sprintf('Original image number(%d)',i));
% subplot(2,1,2)
% imshow(BW1)
% title(sprintf('fft of pitch with no defect(%d)',i));


end
Mx=max(NUM1);

NUM=NUM./Mx;
NUM1=NUM1./Mx;

save('Numd.mat','NUM');
save('Numh.mat','NUM1');

feature_vectord=[Waved,NUM'];
feature_vectorh=[Waveh,NUM1'];
e1=repmat([1],1,30);
e2=2*e1;
FV=[feature_vectord;feature_vectorh];
Target=[e1';e2'];
data=[FV Target];
save('data.mat','data','FV','Target','feature_vectord','feature_vectorh');


