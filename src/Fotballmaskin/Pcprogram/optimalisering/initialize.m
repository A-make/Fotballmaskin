clear all
global t_p p_f startpos
t_p=0:0.001:4;
startpos=[0,0,0];
p_f=zeros(3,1); %wanted point to be included in the trajectory
p_f=[-3.33;11;2.22];
lb=zeros(6,1); %lower bound of the conditions x
ub=zeros(6,1); %upper bound of the conditions x
x_0=zeros(6,1); %initial values of x
Aeq=zeros(6,6);
beq=zeros(6,1);

ub=[29;2*pi;pi/2;10*2*pi;2*pi;2*pi;];

Aeq(4,4)=1;
Aeq(5,5)=1;
Aeq(6,6)=1;
theta_0= asin(p_f(1)/sum(p_f))
psi_0=pi/4;
x_0=[20,theta_0,psi_0,0,0,0];
