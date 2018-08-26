close all;
clear all;

% Intialization of Image
%   1. All functions will be passed a greyscale image; No need to perform code
%   yourself
%   2. Your code must be able to pass back the a image of the same size WITH THE
%   EXCEPTION of 'resizeAspect'
%   3. No functions should create a figure or image; All graphs or displays
%   should be created within the Driver
I_orig = imread('test.jpg');
I_new = rgb2gray(I_orig);
I_new = imrotate(I_new, 90);
% I_new = I_orig;

% % % % % % % % % % % % % % % % % % % % 
% % % Initialization of Variables % % %
% % % % % % % % % % % % % % % % % % % % 

% For Deskewing: Between
deskew_precision = 0.1;

% For Resizing: Only adjust height and aspect_ratio (default = 0)
aspect_ratio = 0;
height = 600; 
[h, w] = size(I_new);
width = height * w/h;

% For Denoising
nx = 3;
ny = 3;

% For Binarization
bin_intensity = 20;

% For Segementation
smallest = 50;

% % % % % % % % % % % % % % % % % % % %
% % % End Variable Initialization % % %
% % % % % % % % % % % % % % % % % % % %

% Despeckling/Denoise
% I_new = despeckle(I_new, nx, ny);
I_new = adaptivewienerfilter(I_new, nx, ny);


% Deskewing
I_new = deskew(I_new, deskew_precision);

% Resizing
I_new = resizeAspect(aspect_ratio, height, width, I_new);

% Binarization
I_new = binarization(I_new, bin_intensity);
imshow(I_new)

%Segementation
[I_le, I_w, bboxes,textBBoxes, cellLetters, cellWords] = segmentation(I_new, smallest);

IExpandedBBoxes = insertShape(I_new,'Rectangle',bboxes,'LineWidth',3);

figure
imshow(IExpandedBBoxes)
title('Expanded Bounding Boxes Text')

% Figure Plots
%montage({imrotate(I_orig, 90), imrotate(I_new, 90),imrotate(I_le,90),});
%suptitle('Stages of Pre-Processing')
%figure;
%for x = 1:8
%    subplot(2,4,x); imshow(imrotate(cellLetters{x}, 90));
%end
%suptitle('First 8 ''Detected'' Characters')