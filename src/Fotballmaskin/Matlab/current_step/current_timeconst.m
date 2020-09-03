currents_m1=zeros(100,9);
currents_m2=zeros(100,9);
max_values_m1=zeros(9,1);
max_values_m2=zeros(9,1);
timeconst_values_m1=zeros(9,1);
timeconst_values_m2=zeros(9,1);
t_m1=zeros(9,1);
t_m2=zeros(9,1);
l_1=zeros(9,1);
l_2=zeros(9,1);

time_m1=current_m1_1(:,1);
time_m2=current_m2_1(:,1);
currents_m1(1:100,1)=current_m1_1(:,2);
currents_m1(1:100,2)=current_m1_2(:,2);
currents_m1(1:100,3)=current_m1_3(:,2);
currents_m1(1:100,4)=current_m1_4(:,2);
currents_m1(1:100,5)=current_m1_5(:,2);
currents_m1(1:100,6)=current_m1_6(:,2);
currents_m1(1:100,7)=current_m1_7(:,2);
currents_m1(1:100,8)=current_m1_8(:,2);

currents_m1(1:100,9)=current_m1_10(:,2);

currents_m2(1:100,1)=current_m2_1(:,2);
currents_m2(1:100,2)=current_m2_2(:,2);
currents_m2(1:100,3)=current_m2_3(:,2);
currents_m2(1:100,4)=current_m2_4(:,2);
currents_m2(1:100,5)=current_m2_5(:,2);
currents_m2(1:100,6)=current_m2_6(:,2);
currents_m2(1:100,7)=current_m2_7(:,2);
currents_m2(1:100,8)=current_m2_8(:,2);

currents_m2(1:100,9)=current_m2_10(:,2);

currents_m1=currents_m1;
currents_m2=currents_m2;
figure(1)
plot(time_m1,currents_m1,'Linewidth',3)
figure(2)
plot(time_m2,currents_m2,'Linewidth',3)
max_values_m1=mean(currents_m1(60:100,1:9))';
max_values_m2=mean(currents_m2(60:100,1:9))';
timeconst_values_m1=max_values_m1*0.632;
timeconst_values_m2=max_values_m2*0.632;

for i=1:9
   
    t_m1(i)=interp1(currents_m1(9:18,i),time_m1(9:18,1),timeconst_values_m1(i))-1.0618
    t_m2(i)=interp1(currents_m2(9:18,i),time_m2(9:18,1),timeconst_values_m2(i))-1.0618
    
end
for i=1:9
    l_1(i)=t_m1(i)*0.5;
    l_2(i)=t_m2(i)*0.5;
end
L_m1=mean(l_1)
L_m2=mean(l_2)
Tc_m1=mean(t_m1)
Tc_m2=mean(t_m2)
