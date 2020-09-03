function [ pathabove ] = aboveground( path )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(path);
pathabove=zeros(m,n);
for i=1:m
    if path(i,3)>=0
        pathabove(i,:)=path(i,:);
    else
        break
    end
end
pathabove=pathabove(1:i-1,:);
