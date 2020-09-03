function [x_return]=find_initvalues_spin(p_w,k_d,k_l,k_w)
%takes in a point and the constants for the ball and if spinn is allowed or
%not. Returns the initial values for the machine
%(9x1)[velocity,theta,psi,omega,lambda,gamma,kd,kl,kw]
global p_f t_p
t_p=0:0.001:10;
lb=zeros(9,1); %lower bound of the conditions x
ub=zeros(9,1); %upper bound of the conditions x
x_0=zeros(9,1); %initial values of x
p_f=p_w; % the desired point
lb(1)=1
lb(2)=-pi;

lb(4)=-10;

ub=[26;pi;pi/2;10;pi/2;pi/2;10;10;10];

Aeq=[0 0 0 0 0 0 0 0 0 ;
     0 1 0 0 0 0 0 0 0 ;
     0 0 0 0 0 0 0 0 0 ;
     0 0 0 0 0 0 0 0 0 ;
     0 0 0 0 1 0 0 0 0 ;
     0 0 0 0 0 1 0 0 0 ;
     0 0 0 0 0 0 1 0 0 ;
     0 0 0 0 0 0 0 1 0 ;
     0 0 0 0 0 0 0 0 1];
  


 
 beq=[0;0;0;0;0;0;k_d;k_l;k_w];
  
theta_0=0;
if p_f(3)== 0
    psi_0=45*pi/180;
else
    psi_0=asin(p_f(3)/sqrt(p_f(2)^2+p_f(3)^2));
end
x_0=[10,theta_0,psi_0,0,0,0,k_d,k_l,k_w];

x=fmincon('minfunction',x_0,[],[],Aeq,beq,lb,ub);
x_return=x;
end