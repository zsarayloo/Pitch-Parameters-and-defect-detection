%% pitch detection process
close all
clear all
clc

%%initializing
I=imread('H (1).jpg');
R=imread('ruler.JPG');
pixelsize=ruler(R);
% %%Otsu
% GI=medfilt2(GI);
% 
% GI=im2double(GI);
% level=graythresh(GI);
% BI=im2bw(GI,level);
% imshow(BI)
%% kmeans

I1=I;
I(:,:,1)=medfilt2(I(:,:,1));
I(:,:,2)=medfilt2(I(:,:,2));
I(:,:,3)=medfilt2(I(:,:,3));
% figure,
% subplot(1,2,1)
% imshow(I1)
% title('original image')
% subplot(1,2,2)
% imshow(I)
% title('remove noise by median filter')
% I=im2double(I);
% S=size(I);
% vector=reshape(I,S(1)*S(2),3);
% [IDX,~] = kmeans(vector,2,'distance','sqeuclidean','emptyaction','singleton','onlinephase','on','start','sample');
% 
% new_I=reshape(IDX,[S(1),S(2)]);
%  for i=1:S(1)
%      for j=1:S(2)
%          temp=new_I(i,j);
%          if temp==2
%              new_I(i,j)=0;
%          else
%              new_I(i,j)=1;
%          end
%      end
%  end

%% methode 1: select point manualy
image(I)
display('please select two external point that located in one line')
[x y]=ginput(2);
x=round(x);
y=round(y);
Major_D=(abs(x(1)-x(2)));% major diameter in pixel

if y(1)>y(2)
    point1=[x(1) y(1)];
    point2=[x(2) y(2)];
    point3=[x(2) y(1)];
else
    point1=[x(2) y(2)];
    point2=[x(1) y(1)];
    point3=[x(1) y(2)];
end
R=Euq_dist(point1,point2);
A=Euq_dist(point2,point3);
   
Helix_angle=asin(A./R);% calculate Helix angle in degree
% minor and pitch diameter
display('please select two internal point that located in a line')
image(I)
internal=ginput(2);
internal=round(internal);
point1=internal(1,:);
point2=internal(2,:);
Minor_D=abs(point1(1)-point2(1));%minor diameter

Pitch_diameter=Minor_D+((Major_D-Minor_D)/2);% pitch diameter

%determine pitch and pitch angle
display('please select 3 point in one side of thread and one pitch')
image(I)
pitch=ginput(3);
pitch=round(pitch);
p1=pitch(1,:);
p2=pitch(2,:);
p3=pitch(3,:);

x1=abs(p1(1)-p2(1));
x2=abs(p1(1)-p3(1));
x3=abs(p3(1)-p2(1));
[S D]=sort([x1 x2 x3]);

if D(1)==1
    point1=p1;
    point2=[p1(1) p2(2)];
    point3=[p3(1) (p1(2)+p2(2))/2];
elseif D(1)==2

    point1=p1;
    point2=[p1(1) p3(2)];
    point3=[p2(1) (p1(2)+p3(2))/2];
else
    point1=p2;
    point2=[p2(1) p3(2)];
    point3=[p1(1) (p2(2)+p3(2))/2];
end

Pitch=abs(point1(2)-point2(2));% pitch length

p1=point3;
p2=[point1(1) point3(2)];
p3=point1;

A=Euq_dist(p2,p3);
R=Euq_dist(p1,p3);

pitch_angle=2*asin(A/R);
%% show result
%% show result
%in pixel
display('pitch parameters:')
display('Major diameter(in pixel)is:')
Major_Diameter=Major_D
display('Minor diameter(in pixel)is:')
Minor_Diameter=Minor_D
display('Helix angle(in degree) is:')   
Helix_angle
display('pitch diameter(in pixel)is:')   
Pitch_Diameter=Pitch_diameter
display('pitch length(in pixel)is:')
Pitch_length=Pitch
display('pitch angle(in degree)is:')
pitch_angle
%% in mm

display('pitch parameters:')
display('Major diameter(in mm)is:')
Major_Diameter=pixelsize.*Major_D
display('Minor diameter(in mm)is:')
Minor_Diameter=pixelsize.*Minor_D
display('Helix angle(in degree) is:')   
Helix_angle
display('pitch diameter(in mm)is:')   
Pitch_Diameter=pixelsize.*Pitch_diameter
display('pitch length(in mm)is:')
Pitch_length=pixelsize.*Pitch
display('pitch angle(in degree)is:')
pitch_angle







