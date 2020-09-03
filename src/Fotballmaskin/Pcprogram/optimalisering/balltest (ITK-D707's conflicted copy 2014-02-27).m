clear all
global minindex fplot p_f t_p
t_p=0:0.001:10;
%x=[v_0;theta;psi;omega;lambda;gamma]
%initialize containers
fplot=[]
p_f=zeros(3,1); %wanted point to be included in the trajectory
lb=zeros(6,1); %lower bound of the conditions x
ub=zeros(6,1); %upper bound of the conditions x
x_0=zeros(6,1); %initial values of x
p_f=[0;100;0]; % the desired point
lb(4)=-10;
lb(2)=-pi;
lb(3)=pi/6
ub=[29;pi;pi/3;10;pi/2;pi/2];

Aeq=[1 0 0 0 0 0 ;
     0 1 0 0 0 0 ;
     0 0 0 0 0 0 ;
     0 0 0 0 0 0 ;
     0 0 0 0 1 0 ;
     0 0 0 0 0 1 ];
  


 
 beq=[13;0;0;0;pi/2;0;];
 
theta_0=acos(p_f(2)/sqrt(p_f(1)^2+p_f(2)^2));
if p_f(3)== 0
    psi_0=pi/4;
else
    psi_0=asin(p_f(3)/sqrt(p_f(2)^2+p_f(3)^2));
end

x_0=[20,theta_0,psi_0,0,0,0];
x_0
x=fmincon('minfunction',x_0,[],[],Aeq,beq,lb,ub);
x
[T_s,Y_s]=Simulate_ballpath(x,[0,0,0]);
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
axis([-10 10 0 120 0 20]);
figure(2)
hold on
plot(fplot,'o-')
grid on