function intersection_point=extract_point(grad_v1)
S=size(grad_v1);
k=0;

for i=1:(S(1)-5)
    v1=grad_v1(i,2);
    v2=grad_v1(i+1,2);
    v3=grad_v1(i+2,2);
    v4=grad_v1(i+3,2);
    v5=grad_v1(i+4,2);
    v6=grad_v1(i+5,2);
    if v1<0 && v2>=0 && v3>=0 && v4>=0 && v5>=0 && v6>=0 
        k=k+1;
        intersection_point(k,:)=grad_v1(i+1,:);
    elseif v1>=0 && v2<0 && v3<0 && v4<0&& v5<0 && v6<0
        k=k+1;
        intersection_point(k,:)=grad_v1(i+1,:);
    end
end


        
        
        