function select=search_euq_dif(C,p)

S=size(C);
th=p;
b=[C(1,1),C(1,3)];
dif=Euq_dist(th,b);
select=C(1,:);
k=0;


for i=2:S(1)
     b=[C(i,1),C(i,3)];
     temp=Euq_dist(th,b);
     if temp<dif
         dif=temp;
         select=C(i,:);
     end
    
end

