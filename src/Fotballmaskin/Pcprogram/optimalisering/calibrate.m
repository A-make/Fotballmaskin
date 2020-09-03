function [kd_new,kl_new,kw_new] = calibrate(speed,theta,psi,omega,kd_old,kl_old,kw_old,p_a)
%calibrate takes in the inital conditions for a given shot and the landing
%spot. It then optimizes the constants of the equation to get the actual
%constants of the system and returns the new constants.

global p_f
lb=zeros(9,1); %lower bound of the conditions x
ub=zeros(9,1); %upper bound of the conditions x
x_0=zeros(9,1); %initial values of x
p_f=p_a; % the desired point
lb(1)=5
lb(2)=-pi;
lb(4)=-10;

ub=[27;pi;pi/3;10;pi/2;pi/2;10;10];

Aeq=[1 0 0 0 0 0 0 0 0 ;
     0 1 0 0 0 0 0 0 0 ;
     0 0 1 0 0 0 0 0 0 ;
     0 0 0 1 0 0 0 0 0 ;
     0 0 0 0 1 0 0 0 0 ;
     0 0 0 0 0 1 0 0 0 ;
     0 0 0 0 0 0 0 0 0 ;
     0 0 0 0 0 0 0 0 0 ;
     0 0 0 0 0 0 0 0 0];
  


 
 beq=[speed;theta;psi;omega;0;0;0;0;0;];
x_0=[speed,theta,psi,omega,0,0,kd_old,kd_old,kd_old];

x=fmincon('minfunction',x_0,[],[],Aeq,beq,lb,ub);
kd_new=x(7);
kl_new=x(8);
kw_new=x(9);
end

