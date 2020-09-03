function [ T_s,Y_s ] = Simulate_ballpath(x)
%Simulate_ballpath takes in the optimized variable and startposition of the
%machine
% x=[V_0,theta,psi,omega,lambda,gamma,k_d,k_l,k_w]
% and uses it to simulate the ballpath
% y_0=[x_0,y_0,z_0,dx_0,dy_0,dz_0;v_0;omega_0;lambda;gamma;k_d;k_l;k_w];
global t_p startpoint
v_0=x(1);
dx_0=x(1)*cos(x(3))*sin(x(2));
dy_0=x(1)*cos(x(3))*cos(x(2));
dz_0=x(1)*sin(x(3));
omega_0=x(4);
lambda=x(5);
gamma=x(6);
k_d=x(7);
k_l=x(8);
k_w=x(9);
y_0=[startpoint(1);startpoint(2);startpoint(3);dx_0;dy_0;dz_0;v_0;omega_0;lambda;gamma;k_d;k_l;k_w];
[T_s,Y_s]=ode45('ballpathfunction',t_p,y_0);
end

