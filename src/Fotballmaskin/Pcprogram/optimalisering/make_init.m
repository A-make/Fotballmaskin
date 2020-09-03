g=9.81;
vis=1.84*10^-5;

Cd=0.28;
Cw=0.001;
r=0.70/(2*pi);
rho=1.2041;
m=0.45;
A=pi*r^2;
k_l=8*rho*pi^2*r^3/3*m;
k_d=rho*A*Cd/2*m;
k_w=20*pi*vis*r/m;
k_d_new=0.005;
global startpoint
startpoint=[0;0;0.1];
p_w=[0;15;0];
x_init=find_initvalues(p_w,k_d_new,k_l,k_w,1)
speed=x_init(1)
psi=x_init(3)*180/pi
[T_s,Y_s]=Simulate_ballpath(x_init);
path=aboveground(Y_s(:,1:3));
figure(1);
plot(path(:,2),path(:,3))
grid on