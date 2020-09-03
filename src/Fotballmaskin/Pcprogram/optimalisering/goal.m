goalwidth=7.32;
goalheight=2.44;

goalpost1z=0:0.01:goalheight;
goalpost1x=ones(size(goalpost1z))*-goalwidth/2;
goalpost1y=ones(size(goalpost1z))*11;

goalpost2z=0:0.01:goalheight;
goalpost2x=ones(size(goalpost1z))*goalwidth/2;
goalpost2y=ones(size(goalpost1z))*11;

crossbarx=-goalwidth/2:0.01:goalwidth/2;
crossbary=ones(size(crossbarx))*11;
crossbarz=ones(size(crossbarx))*2.44;

plot3(crossbarx,crossbary,crossbarz,'black');
plot3(goalpost2x,goalpost2y,goalpost2z,'black');
plot3(goalpost1x,goalpost1y,goalpost1z,'black');