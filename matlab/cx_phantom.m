function out = cx_phantom(p, monoInfo)
%function out = cx_phantom(p, monoInfo)
%    p = [azim,elev], monoInfo can be a path or a col vector of sound.

if ischar(monoInfo)
    mono = audioread(monoInfo);
    mono = mono(:,1); % make sure it's really mono.
else
    mono = monoInfo(:,1);
end


% From p we need to get 3 closest HRTF that forms a triangle and encloses
% the point p:
hrtfs = cx_which3HRTF(p);
% read these three HRTFs in.
l1 = cx_HRTF(hrtfs(1,:)); 
l2 = cx_HRTF(hrtfs(2,:));
l3 = cx_HRTF(hrtfs(3,:));
%% calculating the gains
L = [l1.cart, l2.cart, l3.cart]; % L is a 3*3 matrix that has the three bases as column vectors
pCart = cx_sphere2cart(p(1), p(2)); % Get the right hand side by converting spherical to cartisian
g = L \ pCart; % solve for the weights
g = g / norm(g); % normalize accordingly equi-power rule.

%% Convolving and writing to output
sig1L = conv(mono, l1.ir(:,1));
sig1R = conv(mono, l1.ir(:,2));
sig2L = conv(mono, l2.ir(:,1));
sig2R = conv(mono, l2.ir(:,2));
sig3L = conv(mono, l3.ir(:,1));
sig3R = conv(mono, l3.ir(:,2));

outputL = [sig1L, sig2L, sig3L]*g;
outputR = [sig1R, sig2R, sig3R]*g;

out = [outputL, outputR];
end