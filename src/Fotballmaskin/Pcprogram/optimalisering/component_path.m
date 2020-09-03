function [ x,y ] = component_path( path )
%UNTITLED3 Summary of this function goes here
%   
x=path;
x(:,3)=0*x(:,3);
y=path;
y(:,2)=0*y(:,2);
y(:,3)=0*y(:,3);

end

