function out = cx_which3HRTF(point)
%function [path1, path2, path3] = cx_which3HRTF(point)
%   Given a legal point in our space, gives out three existing locations
%   for HRTF. This script is designed specifically for the IRCAM HRTF set
%   that we are using for this project.
%   input is row vec [x,y], output is [x1,y1; x2,y2; x3,y3]

% IRCAM's HRTF sets are nicely mapped onto the latice points of the sphere.
% They all happen to be 15 degrees apart from each other.

% Pick out the 4 HRTFs surrounding the point first:
pa = mod(point(1),360); pe = point(2);
if pe > 45 || pe < -45
    error('Error: elevation of the point must be between -45 and 45.')
end

aLow = mod(floor(pa/15) * 15, 360);
aHigh = mod((floor(pa/15) + 1) * 15, 360);
aRel = mod(pa,15);

eLow = mod(floor(pe/15) * 15, 360);
eHigh = mod((floor(pe/15) + 1) * 15, 360);
eRel = mod(pe,15);

% four corners of the grid
h_ul = [aLow, eHigh]; % upper left
h_ur = [aHigh, eHigh]; % upper right
h_ll = [aLow, eLow]; % lower left
h_lr = [aHigh, eLow]; % lower right



if eRel < 7.5
    if aRel < 7.5 % Lower Left quardrant
       out = [h_ul; h_ll; h_lr];
    else % Lower Right 
       out = [h_ur; h_ll; h_lr];
    end
else % pa >= 7.5
    if aRel < 7.5 % Upper Left quardrant
       out = [h_ul; h_ll; h_ur];
    else % Upper Right quardrant
       out = [h_ul; h_lr; h_ur];
    end
end
end

