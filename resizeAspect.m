function newImage = resizeAspect(aspectRatio, newHeight, newWidth, oldImage)
    %if aspectRatio is not set, 
    if aspectRatio == 0
        newImage = imresize(oldImage, [newHeight, newWidth]);
    else
        [oldHeight, ~] = size(oldImage);
        newHeight = oldHeight;
        newWidth = oldHeight * aspectRatio;
        newImage = imresize(oldImage, [newHeight, newWidth]);
    end
end
