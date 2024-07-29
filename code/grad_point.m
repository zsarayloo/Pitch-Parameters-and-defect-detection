function g=grad_point(p,h)
g=zeros(1,2);
a=p(1);
b=p(2);
c=h(2);
g(:,:)=[a,c-b];

