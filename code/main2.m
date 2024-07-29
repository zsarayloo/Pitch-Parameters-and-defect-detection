% Automatic pitch parameter measurement
close all
clear all
clc

%%initializing
I=imread('H (5).jpg');
R=imread('ruler.JPG');
pixelsize=ruler(R);
%%

R=medfilt2(I(:,:,1));
G=medfilt2(I(:,:,2));
B=medfilt2(I(:,:,3));
% Is=G-R-B;
% Is2=medfilt2(Is);
%%
R=imfill(R,'holes');
G=imfill(G,'holes');
B=imfill(B,'holes');
% Is2=G-R-B;
% imshow(Is2,[])



%%
% subplot(121)
% imshow(Is); title('Original Image');
% subplot(122)
% imshow(Is2); title('Denoised Image')
% %%
% Is2=imfill(Is2,'holes');
% 
Is2(:,:,1)=R;
Is2(:,:,2)=G;
Is2(:,:,3)=B;

L=graythresh(Is2);
I1=im2bw(Is2,L);
imshow(I1)
B=imfill(I1,'holes');
[B n]=bwlabeln(B);

state=regionprops(B,'area','Centroid','BoundingBox');
centroids = cat(1, state.Centroid);
Area = cat(1, state.Area);
BoundingBox = cat(1, state.BoundingBox);
[X Y]=sort(Area);
for i=1:(n-2)
    j=Y(i);
    
    param=centroids(j,:);
    Bound=BoundingBox(j,:);
    B(floor(Bound(1,2)):ceil(Bound(1,2)+Bound(1,4)),floor(Bound(1,1)):ceil(Bound(1,1)+Bound(1,3)))=0;
    
end




[BW th]=edge(B,'canny');

I=edge(B,'canny',th);
imshow(I)
imagesc(I)
%%
S=size(I);
I_1=I(:,1:(ceil(S(2)/2)));
I_2=I(:,((ceil(S(2)/2))+1):end);

[row1,col1] = find(I_1) ;
[row2,col2] = find(I_2) ;

figure()
a=25
scatter(col1,row1,a,'filled')

figure()
a=25
scatter(col2,row2,a,'filled')

%%
grad_v1=grad_vector(row1,col1);

grad_v2=grad_vector(row2,col2);

scatter(grad_v1(:,3),grad_v1(:,1),a,'filled')
intersection_point=extract_point(grad_v1);
scatter(intersection_point(:,3),intersection_point(:,1),a,'filled')

intersection_point2=extract_point(grad_v2);
scatter(intersection_point2(:,3),intersection_point2(:,1),a,'filled')
point=[intersection_point2;intersection_point];
scatter(point(:,3),point(:,1),a,'filled')
%% select inner and outter point of pitch
C=intersection_point(:,3);
[D, ID]=sort(C);
p_in1=[intersection_point(ID(end),1) D(end)];%% inner point1
v=intersection_point(ID(1:(end-1)),:);
p_out1=search_in(v,p_in1);%% outter point in one side1
ind=find((v(:,1)==p_out1(1))& (v(:,3)==p_out1(3)));
v(ind,:)=[];
p_out2=search_in(v,p_in1);%% outter point in one side2
p_out2=[p_out2(1) p_out2(3)];
p_out1=[p_out1(1) p_out1(3)];

C=intersection_point2;
p_in2=search_euq_dif(C,p_in1);%% inner point2
p_in2=[p_in2(1) p_in2(3)];

[D ID]=sort(C(:,1));
A=abs(D-p_out2(1));
B=abs(D-p_out1(1));
i=find(B==min(B));
j=find(A==min(A));

if i<j
A=C(ID(i:j),:);
else
A=C(ID(j:i),:);
end

MX=max(A(:,3));
p=A(find(A(:,3)==MX),:);
p_out3=[p(1),p(3)];
a=25
point=[p_in1;p_in2;p_out1;p_out2;p_out3];
scatter(point(:,2),point(:,1),a,'filled')


%% measurment
%%%select two external point that located in one line')
p1=p_out2;
p2=p_out3;

x=[p1(2),p2(2)];
y=[p1(1),p2(1)];
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
%%%% select two internal point that located in a line
point1=p_in1;
point2=p_in2;
Minor_D=abs(point1(2)-point2(2));%minor diameter

Pitch_diameter=Minor_D+((Major_D-Minor_D)/2);% pitch diameter
%determine pitch and pitch angle by  select 3 point in one side of thread and one pitch')

p1=p_in1;
p2=p_out1;
p3=p_out2;

x1=abs(p1(2)-p2(2));
x2=abs(p1(2)-p3(2));
x3=abs(p3(2)-p2(2));
[S D]=sort([x1 x2 x3]);

if D(1)==1
    point1=p1;
    point2=[p1(2) p2(1)];
    point3=[p3(2) (p1(1)+p2(1))/2];
elseif D(1)==2

    point1=p1;
    point2=[p1(2) p3(1)];
    point3=[p2(2) (p1(1)+p3(1))/2];
else
    point1=p2;
    point2=[p2(2) p3(1)];
    point3=[p1(2) (p2(1)+p3(1))/2];
end

Pitch=abs(point1(1)-point2(1));% pitch length

p1=point3;
p2=[point1(2) point3(1)];
p3=point1;

A=Euq_dist(p2,p3);
R=Euq_dist(p1,p3);

pitch_angle=2*asin(A/R);
%% show result
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

% pixelsize=input('please input pixel size');
% display('pitch parameters:')
% display('Major diameter(in mm)is:')
% Major_Diameter=pixelsize.*Major_D
% display('Minor diameter(in mm)is:')
% Minor_Diameter=pixelsize.*Minor_D
% display('Helix angle(in degree) is:')   
% Helix_angle
% display('pitch diameter(in mm)is:')   
% Pitch_Diameter=pixelsize.*Pitch_diameter
% display('pitch length(in mm)is:')
% Pitch_length=pixelsize.*Pitch
% display('pitch angle(in degree)is:')
% pitch_angle













