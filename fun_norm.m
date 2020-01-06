function z = fun_norm(data,mf)
 nf=size(data,1);
 min1 = min(data);
 max1 = max(data);
 for p=1:numel(data)
   data(p)=(data(p)-min1)/(max1-min1);
 end
 temp=zeros(nf-mf+1,mf);
 for i=1:nf-mf+1
     temp(i,:)=data(i:i+mf-1);
 end
 z=temp;
end