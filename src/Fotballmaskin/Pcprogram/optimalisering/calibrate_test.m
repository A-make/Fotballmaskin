clear all
global minindex fplot p_f t_p startpoint
startpoint=[0,0,0.23];
t_p=0:0.001:10;
%x=[v_0;theta;psi;omega;lambda;gamma]
%initialize containers
fplot=[]
p_f=zeros(3,1); %wanted point to be included in the trajectory
lb=zeros(6,1); %lower bound of the conditions x
ub=zeros(6,1); %upper bound of the conditions x
x_0=zeros(6,1); %initial values of x
p_f=[0;5;0]; % the desired point
lb(1)=0
lb(4)=-10;
lb(2)=-pi;
lb(3)=0
ub=[20;pi;pi/2;10;pi/2;pi/2];

Aeq=[0 0 0 0 0 0 ;
     0 1 0 0 0 0 ;
     0 0 0 0 0 0 ;
     0 0 0 1 0 0 ;
     0 0 0 0 1 0 ;
     0 0 0 0 0 1 ];
 
  beq=[0;0;0;0;0;0;];
  
theta_0=acos(p_f(2)/sqrt(p_f(1)^2+p_f(2)^2));
if p_f(3)== 0
    psi_0=45*pi/180;
else
    psi_0=asin(p_f(3)/sqrt(p_f(2)^2+p_f(3)^2));
end

  
  
x_0=[1,theta_0,psi_0,0,0,0];
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


 x_0=[1,theta_0,psi_0,0,0,0];
 x_0
 p_f=[0,2,0]
 
Aeq=[0 0 0 0 0 0 ;
     0 1 0 0 0 0 ;
     0 0 1 0 0 0 ;
     0 0 0 1 0 0 ;
     0 0 0 0 1 0 ;
     0 0 0 0 0 1 ];
 
  beq=[0;0;x(3);0;0;0;];
 x_new=fmincon('minfunction',x_0,[],[],Aeq,beq,lb,ub);
 
 [T_new,Y_new]=Simulate_ballpath(x_new);
 p_path_new=Y_new(:,1:3);
 length=size(p_path);
 answerindex=Inf;
 abovegroundpath_new=aboveground(p_path_new);
 comp=component_path(abovegroundpath_new);
 
 figure(1)
 hold on
 %field goal
 plot3(abovegroundpath_new(:,1),abovegroundpath_new(:,2),abovegroundpath_new(:,3),'')
 plot3(p_f(1),p_f(2),p_f(3),'o');
 grid on

