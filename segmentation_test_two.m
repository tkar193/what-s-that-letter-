colorImage = imread('stopsign.jpg');
I = rgb2gray(colorImage);
I = imresize(I, .3);

    % Detect MSER regions.
    [mserRegions, mserConnComp] = detectMSERFeatures(I, ... 
        'RegionAreaRange',[smallest 8000],'ThresholdDelta',0.8);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Use regionprops to measure MSER properties
    mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
        'Solidity', 'Extent', 'Euler', 'Image');

%     % Compute the aspect ratio using bounding box data.
%     bbox = vertcat(mserStats.BoundingBox);
%     w = bbox(:,3);
%     h = bbox(:,4);
%     aspectRatio = w./h;
% 
%     % Threshold the data to determine which regions to remove. These thresholds
%     % may need to be tuned for other images.
%     filterIdx = aspectRatio' > 3; 
%     filterIdx = filterIdx | [mserStats.Eccentricity] > .995 ;
%     filterIdx = filterIdx | [mserStats.Solidity] < .3;
%     filterIdx = filterIdx | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.9;
%     filterIdx = filterIdx | [mserStats.EulerNumber] < -4;
% 
%     % Remove regions
%     mserStats(filterIdx) = [];
%     mserRegions(filterIdx) = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Get bounding boxes for all the regions
    bboxes = vertcat(mserStats.BoundingBox);
    
    % Convert from the [x y width height] bounding box format to the [xmin ymin
    % xmax ymax] format for convenience.
    xmin = bboxes(:,1);
    ymin = bboxes(:,2);
    xmax = xmin + bboxes(:,3) - 1;
    ymax = ymin + bboxes(:,4) - 1;

    % Expand the bounding boxes by a small amount.
    expansionAmount = 0.02;
    xmin = (1-expansionAmount) * xmin;
    ymin = (1-expansionAmount) * ymin;
    xmax = (1+expansionAmount) * xmax;
    ymax = (1+expansionAmount) * ymax;

    % Clip the bounding boxes to be within the image bounds
    xmin = max(xmin, 1);
    ymin = max(ymin, 1);
    xmax = min(xmax, size(I,2));
    ymax = min(ymax, size(I,1));
    
     % Split the bounding boxes vectors into separate vectors for however many
     % boxes there are
 
     vsize = size(xmin);
     first = xmin(1);
     count = 2;
     final(1,:) = [xmin(1) ymin(1) xmax(1) ymax(1)];
 
     % Find the four vertices of each box
     for v = 1:vsize-1
         if (abs((xmin(v+1)-xmin(v))) > .05 * xmin(v))
             final(count,:) = [xmin(v+1) ymin(v+1) xmax(v+1) ymax(v+1)];
             count = count + 1;
         end
     end
 
     % Sort the first column
     firstColumnFinal = sort(final(:,1));
     vsize = size(firstColumnFinal);
     finalTwo = final;
 
     % Sort all the rows according to each row's 1st column element
     for i = 1:vsize
         for j = 1:vsize
             if (firstColumnFinal(i) == final(j,1))
                 finalTwo(i,:) = final(j,:);
                 break
             end
         end
     end
 
     final = finalTwo;
 
     % Getting rid of unwanted bounding boxes
     count = 1;
     for i = count:vsize-1
         if (count > vsize - 1) 
             break
         end
 
         if ((final(count+1,1) > final(count,1)) && (final(count+1,2) > final(count,2)) && (final(count+1,3) < final(count,3)) && (final(count+1,4) < final(count,4)))
             finalThree(i,:) = final(count,:);
             count = count + 1;
         else
             finalThree(count,:) = final(count,:);
             finalThree(count+1,:) = final(count+1,:);
         end
         count = count + 1;
     end
 
     final = finalThree;
    
    % Segement individual characters and create outputs
    BBoxes = [final(:,1) final(:,2) final(:,3)-final(:,1)+1 final(:,4)-final(:,2)+1];