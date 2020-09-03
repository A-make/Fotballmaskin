function [speed]=find_speed(p_w,speed,psi_0,k_d,k_l,k_w)
%takes in a point and the constants for the ball and if spinn is allowed or
%not. Returns the initial values for the machine (9x1)
global p_f t_p
t_p=0:0.001:10;
lb=zeros(9,1); %lower bound of the conditions x
ub=zeros(9,1); %upper bound of the conditions x
x_0=zeros(9,1); %initial values of x
p_f=p_w; % the desired point
lb(1)=1
lb(2)=-pi;
lb(4)=-10;

ub=[27;pi;pi/2;10;pi/2;pi/2;10;10;10];

Aeq=[0 0 0 0 0 0 0 0 0 ;
     0 1 0 0 0 0 0 0 0 ;
     0 0 1 0 0 0 0 0 0 ;
     0 0 0 1 0 0 0 0 0 ;
     0 0 0 0 1 0 0 0 0 ;
     0 0 0 0 0 1 0 0 0 ;
     0 0 0 0 0 0 1 0 0 ;
     0 0 0 0 0 0 0 1 0 ;
     0 0 0 0 0 0 0 0 1];
  


 
 beq=[0;0;psi_0;0;0;0;k_d;k_l;k_w];

x_0=[speed,0,psi_0,0,0,0,k_d,k_l,k_w];

x=fmincon('minfunction',x_0,[],[],Aeq,beq,lb,ub);
speed=x(1);
end