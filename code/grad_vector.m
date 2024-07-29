function v=grad_vector(row1,col1)
[D ID]=sort(row1);
point=[D,col1(ID)];
S=size(point);
k=0;

for i=1:4:(S(1)-4)
    p1=point(i,:);
    p2=point(i+4,:);
    k=k+1;
    g(k,1:2)=grad_point(p1,p2);
    g(k,3)=p1(1,2);
    
end
v=g;

    


