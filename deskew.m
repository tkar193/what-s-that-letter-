function [deskewed_image] = deskew(image, precision)
%Takes an image as input and calculates the angle that it needs to be rotated by
% angle is a range from (-45, 45), image is a black and white image (use
% rgb2gray), lower precision value results in better calculation

%Theory: http://homepages.inf.ed.ac.uk/rbf/HIPR2/fourier.htm
%   Example:
% image = rgb2gray(imread('rotated-text.png'));
% angle = EECS351Project_Deskew(image, 0.1)
% imshow(imrotate(image, -angle, 'bicubic'))
% Depending on orientation of original image (when image is tilted by
% -degrees aka clockwise), may have to use +angle rather than -angle in imshow(imrotate(...))


% Get logarithmic magnitude of the Fourier Transform of the image
maxsize = max(size(image));

%Make into square image
T = fftshift(fft2(image, maxsize, maxsize)); 
T = log(abs(T)+1);              

% Combine FFT quadrants into 1,removes additive noise
center = ceil((maxsize+1)/2);
is_even = mod(maxsize+1, 2);

T_orig = T;
T = (rot90(T_orig(center:end, 1+is_even:center), 1) + T_orig(center:end, center:end));
T = T + rot90(T_orig(1+is_even:center, 1+is_even:center),2);
T = T + rot90(T_orig(1+is_even:center, center:end),3);
T = T(2:end, 2:end);  

% Find the angle of the highest magnitude ft
angles = floor(90/precision);
highest_mag = zeros(angles, 1);
maxDist = maxsize/2-1;

% For each angle, calculate all magnitudes of the image on a line of the
% that angle
for angle = 0:angles-1
    [y,x] = pol2cart(deg2rad(angle*precision), 0:maxDist-1); % all [x,y]
    for i = 1:maxDist
        highest_mag(angle+1) = highest_mag(angle+1) + T(round(y(i)+1), round(x(i)+1));
    end
end

% Return the angle of the frequency of highest magnitude
[dc, angle_position] = max(highest_mag);
angle = (angle_position-1)*precision;

% angle is in range of [-45,45]
angle = mod(45+angle,90)-45;            

 if (angle == -45) 
%     imshow(imrotate(image, angle, 'bicubic'))
    deskewed_image = imrotate(image,angle,'bicubic');
 else
%      imshow(imrotate(image, -angle, 'bicubic'))
     deskewed_image = imrotate(image,-angle,'bicubic');
end

