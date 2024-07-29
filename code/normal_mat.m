function n=normal_mat(K)
MN=min(min(K));
MX=max(max(K));
K =(K-MN)./MX;
n=K;
