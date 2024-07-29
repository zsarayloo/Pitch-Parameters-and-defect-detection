function p=ruler(R)
R1=R(594:(594+850),1464:(1464+560),:);
R1=rgb2gray(R1);
p=10/(557-350+1); % pixel size in mm
