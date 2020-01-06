function z = fitness(x)
global nfe;
z=abs(0.2-4*x(1)-5*x(2)-6*x(3)+0.6*x(4))+abs(10.2-0.4*x(1)+15*x(2)-99*x(3)+1.6*x(4));
nfe=nfe+1;
end

