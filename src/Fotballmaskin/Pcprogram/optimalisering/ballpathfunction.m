function [ ydot ] = ballpathfunction( t,y )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here



g=9.81;
vis=1.84*10^-5;



Cd=0.28;
Cw=0.001;
r=0.70/(2*pi);
rho=1.2041;
m=0.45;
A=2*pi*r^2;
k_l=8*rho*pi^2*r^3/3*m;
k_d=rho*A*Cd/2*m;
k_w=20*pi*vis*r/m;
    
    ydot=zeros(10,1);
    ydot(1)=y(4);
    ydot(2)=y(5);
    ydot(3)=y(6);
    ydot(4)=y(12)*y(8)*(sin(y(9))*sin(y(10))*y(6)-cos(y(9))*y(5))-y(11)*y(7)*y(4);
    ydot(5)=y(12)*y(8)*(sin(y(9))*cos(y(10))*y(6)-cos(y(9))*y(4))-y(11)*y(7)*y(5);
    ydot(6)=y(12)*y(8)*(sin(y(9))*cos(y(10))*y(5)-sin(y(9))*sin(y(10))*y(4))-y(11)*y(7)*y(6)-g;
    ydot(7)=y(12)*y(8)*((sin(y(9))*sin(y(10))*y(6)-cos(y(9))*y(5))+(sin(y(9))*cos(y(10))*y(6)-cos(y(9))*y(4))+(sin(y(9))*cos(y(10))*y(5)-sin(y(9))*sin(y(10))*y(4)))/y(7) -y(11)*(y(4)+y(5)+y(6));
    ydot(8)=-y(13)*y(8)*y(8);
    ydot(9)=0;
    ydot(10)=0;
    ydot(11)=0;
    ydot(12)=0;
    ydot(13)=0;
    

end

