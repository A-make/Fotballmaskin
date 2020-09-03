sixteenwidth=40.3;
elevenwidth=18.32;
elevendepth=5.5;

shortlinex=[-45:0.1:45];
shortliney=ones(size(shortlinex))*11;
shortlinez=zeros(size(shortlinex));

longliney=[-20:0.1:11];
longlinex1=ones(size(longliney))*-45;
longlinex2=ones(size(longliney))*45;
longlinez=zeros(size(longliney));

eleveny=[5.5:0.1:11];
elevenx1=ones(size(eleveny))*-9.16;
elevenz=zeros(size(eleveny));
elevenx2=ones(size(eleveny))*9.16;

elevenwidthx=[-9.16:0.1:9.16];
elevenwidthy=ones(size(elevenwidthx))*5.5;
elevenwidthz=zeros(size(elevenwidthx));

sixteeny=[-5.5:0.1:11];
sixteenx1=ones(size(sixteeny))*-sixteenwidth/2;
sixteenx2=ones(size(sixteeny))*sixteenwidth/2;
sixteenz=zeros(size(sixteeny));

sixteenwidthx=[-sixteenwidth/2:0.1:sixteenwidth/2];
sixteenwidthy=ones(size(sixteenwidthx))*-5.5;
sixteenwidthz=zeros(size(sixteenwidthx));

plot3(shortlinex,shortliney,shortlinez,'k',eleveny,elevenx1,elevenz,'k',elevenx2,eleveny,elevenz,'k',elevenwidthx,elevenwidthy,elevenwidthz,'k');
plot3(elevenx1,eleveny,elevenz,'k',elevenx2,eleveny,elevenz,'k',elevenwidthx,elevenwidthy,elevenwidthz,'k');
plot3(sixteenx1,sixteeny,sixteenz,'k',sixteenx2,sixteeny,sixteenz,'k',sixteenwidthx,sixteenwidthy,sixteenwidthz,'k');
plot3(longlinex1,longliney,longlinez,'k',longlinex2,longliney,longlinez,'k')
