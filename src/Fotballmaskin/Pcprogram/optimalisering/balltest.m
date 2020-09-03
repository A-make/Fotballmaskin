clear all
global minindex fplot p_f t_p startpoint
t_p=0:0.001:10;
startpoint=[0,0,0.20];
Cd=0.28;
Cw=0.001;
r=0.70/(2*pi);
rho=1.2041;
m=0.45;
A=2*pi*r^2;
k_l=8*rho*pi^2*r^3/3*m;
k_d=rho*A*Cd/2*m;
%x=[v_0;theta;psi;omega;lambda;gamma;k_d;k_l]
%initialize containers
fplot=[]
p_f=zeros(3,1); %wanted point to be included in the trajectory
lb=zeros(9,1); %lower bound of the conditions x
ub=zeros(9,1); %upper bound of the conditions x
x_0=zeros(9,1); %initial values of x
p_f=[0;20;0]; % the desired point
lb(1)=1
lb(2)=-pi;
lb(4)=-10;

ub=[27;pi;pi/3;10;pi/2;pi/2;10;10;10];

Aeq=[1 0 0 0 0 0 0 0 0;
     0 1 0 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0 0;
     0 0 0 1 0 0 0 0 0;
     0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 1 0 0 0;
     0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 1];


 
 beq=[18.9835;0;0.8455;0;0;0;0;0;];
 
theta_0=acos(p_f(2)/sqrt(p_f(1)^2+p_f(2)^2));
if p_f(3)== 0
    psi_0=45*pi/180;
else
    psi_0=asin(p_f(3)/sqrt(p_f(2)^2+p_f(3)^2));
end

x_0=[18,theta_0,0.8455,0,0,0,k_d,k_l];
x_0
x=fmincon('minfunction',x_0,[],[],Aeq,beq,lb,ub);
x
[T_s,Y_s]=Simulate_ballpath(x);
p_path=Y_s(:,1:3);
length=size(p_path);
answerindex=Inf;
abovegroundpath=aboveground(p_path);
comp=component_path(abovegroundpath);


figure(1)
hold on
%field
%goal
plot3(abovegroundpath(:,1),abovegroundpath(:,2),abovegroundpath(:,3),'')
plot3(p_f(1),p_f(2),p_f(3),'o');
grid on

figure(2)
hold on
plot(fplot,'o-')
grid on