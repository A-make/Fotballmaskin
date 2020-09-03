function [ f ] = minfunction( x )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% x=[v_0;theta;psi;omega;lambda;gamma;x_f;y_f;z_f]
%y=[x,y,z,dx,dy,dz,v,omega,lambda,gamma;k_d;k_l;k_w];
global minindex fplot p_f
x
[t_s,y_s]=Simulate_ballpath(x);
gain=[1,0,0];%for each direction, total speed, spin
dirgain=[1,10,1];
path=aboveground(y_s(:,1:3));
[m,n]=size(path);
f=0;


tempmin=Inf;
for i=1:m
    currentdist=dirgain(1)*(p_f(1)-path(i,1)).^2+dirgain(2)*(p_f(2)-path(i,2)).^2+dirgain(3)*(p_f(3)-path(i,3)).^2;
  if currentdist<tempmin
      tempmin=currentdist;
      minindex=i;
  end
end
if tempmin<=Inf
    f=gain(1)*tempmin+gain(2)*x(1)+gain(3)*t_s(minindex);
    fplot=[fplot f];
end

end

