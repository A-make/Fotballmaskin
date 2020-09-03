
speeds_m1=zeros(100,9);
speeds_m2=zeros(100,9);
currents_m1=zeros(100,9);
currents_m2=zeros(100,9);
time_m1=speed_m1_2(:,1);
time_m2=speed_m2_2(:,1);


speeds_m1(:,1)=speed_m1_2(:,2);
speeds_m1(:,2)=speed_m1_3(:,2);
speeds_m1(:,3)=speed_m1_4(:,2);
speeds_m1(:,4)=speed_m1_5(:,2);
speeds_m1(:,5)=speed_m1_6(:,2);
speeds_m1(:,6)=speed_m1_7(:,2);
speeds_m1(:,7)=speed_m1_8(:,2);
speeds_m1(:,8)=speed_m1_9(:,2);
speeds_m1(:,9)=speed_m1_10(:,2);

speeds_m2(:,1)=speed_m2_2(:,2);
speeds_m2(:,2)=speed_m2_3(:,2);
speeds_m2(:,3)=speed_m2_4(:,2);
speeds_m2(:,4)=speed_m2_5(:,2);
speeds_m2(:,5)=speed_m2_6(:,2);
speeds_m2(:,6)=speed_m2_7(:,2);
speeds_m2(:,7)=speed_m2_8(:,2);
speeds_m2(:,8)=speed_m2_9(:,2);
speeds_m2(:,9)=speed_m2_10(:,2);

currents_m1(:,1)=current_m1_2(:,2);
currents_m1(:,2)=current_m1_3(:,2);
currents_m1(:,3)=current_m1_4(:,2);
currents_m1(:,4)=current_m1_5(:,2);
currents_m1(:,5)=current_m1_6(:,2);
currents_m1(:,6)=current_m1_7(:,2);
currents_m1(:,7)=current_m1_8(:,2);
currents_m1(:,8)=current_m1_9(:,2);
currents_m1(:,9)=current_m1_10(:,2);

currents_m2(:,1)=current_m2_2(:,2);
currents_m2(:,2)=current_m2_3(:,2);
currents_m2(:,3)=current_m2_4(:,2);
currents_m2(:,4)=current_m2_5(:,2);
currents_m2(:,5)=current_m2_6(:,2);
currents_m2(:,6)=current_m2_7(:,2);
currents_m2(:,7)=current_m2_8(:,2);
currents_m2(:,8)=current_m2_9(:,2);
currents_m2(:,9)=current_m2_10(:,2);


max_values_s1=zeros(9,1);
max_values_s2=zeros(9,1);
max_values_c1=zeros(9,1);
max_values_c2=zeros(9,1);

speeds_m1=speeds_m1*2*pi/4;
dspeeds_m1=diff(speeds_m1);

speeds_m2=speeds_m2*2*pi/4;
dspeeds_m2=diff(speeds_m2);

currents_m1(:,:)=currents_m1/1000;
currents_m2(:,:)=currents_m2/1000;
for i=1:9
    max_values_s1(i)=mean(speeds_m1(80:100,i));
    max_values_s2(i)=mean(speeds_m2(80:100,i));
    max_values_c1(i)=mean(currents_m1(80:100,i));
    max_values_c2(i)=mean(currents_m2(80:100,i));
end

volt_inn_1=[0.87,1.25,1.82,2.36,2.73,3.26,3.84,4.19,4.70];
volt_inn_2=[0.87,1.23,1.78,2.36,2.70,3.26,3.82,4.19,4.69];
k_1=zeros(9,1);
k_2=zeros(9,1);
B_1=zeros(9,1);
B_2=zeros(9,1);
J_1=zeros(9,1);
J_2=zeros(9,1);
for i=1:9
    k_1(i)=(volt_inn_1(i))/max_values_s1(i);
    k_2(i)=(volt_inn_2(i))/max_values_s2(i);
    B_1(i)=(volt_inn_1(i)-0.5*max_values_c1(i))*max_values_c1(i)/max_values_s1(i)^2;
    B_2(i)=(volt_inn_2(i)-0.5*max_values_c2(i))*max_values_c2(i)/max_values_s2(i)^2;
end

timeconst_values_1=zeros(9,1);
timeconst_values_2=zeros(9,1);
timeconst1_m1=zeros(9,1);
timeconst1_m2=zeros(9,1);
timeconst_values_1=0.632*max_values_s1;
timeconst_values_2=0.632*max_values_s2;
for i=1:9
   
    timeconst1_m1(i)=interp1(speeds_m1(5:25,i),time_m1(5:25,1),timeconst_values_1(i))-1;
    timeconst1_m2(i)=interp1(speeds_m2(5:25,i),time_m2(5:25,1),timeconst_values_2(i))-1;
    
end
for i=1:9
    J_1(i)=k_1(i)^2 *timeconst1_m1(i)/0.5;
    J_2(i)=k_2(i)^2 *timeconst1_m2(i)/0.5;
end
var_km1=var(k_1)
var_km2=var(k_2)
var_bm1=var(B_1(1:9))
var_bm2=var(B_2(1:9))
var_jm1=var(J_1)
var_jm2=var(J_2)
K_m1=mean(k_1)
K_m2=mean(k_2)
B_m1=mean(B_1(1:9))
B_m2=mean(B_2(2:9))
J_m1=mean(J_1)
J_m2=mean(J_2)

ownfreq_m1=K_m1/sqrt(J_m1*L_m1)
ownfreq_m2=K_m2/sqrt(J_m2*L_m2)
damp_m1=0.5*sqrt(J_m1*L_m1)/(K_m1*L_m1)
damp_m2=0.5*sqrt(J_m2*L_m2)/(K_m2*L_m2)
T_m1=mean(timeconst1_m1)
T_m2=mean(timeconst1_m2)
num_m1=[1/K_m1];
num_m2=[1/K_m2];
den_m1=[(J_m1*L_m1)/K_m1^2 (J_m1*0.5)/K_m1^2 1];
den_m2=[(J_m2*L_m2)/K_m1^2 (J_m2*0.5)/K_m2^2 1];

M1=tf(num_m1,den_m1)
M2=tf(num_m2,den_m2)
