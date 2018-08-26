function output = binarization(greyImg, intensity)
    greyImg = im2double(greyImg);
    [L,H] = size(greyImg);
    output = ones(L,H);
    s = floor(L/8);
    t = intensity;
    integralM = [];

    % Creating Integral Matrix
    for width = 1:L
        sum = 0;
        for height = 1:H
            sum = sum + greyImg(width,height);
            if width == 1
                integralM(width,height) = sum;
            else
                integralM(width,height) = integralM(width-1,height)+sum;
            end
        end
    end

    % Calculation each Pixel's surrounding average
    for width1 = 1:L
        for height1 = 1:H
            %Border Checks for Square Limits
            if (width1 - s/2) >= 1
                x1 = width1 - floor(s/2);
            else
                x1 = 1;
            end
            if (width1 + s/2) <= L
                x2 = width1 + ceil(s/2);
            else
                x2 = L;
            end
            if (height1 - s/2) >= 1
                y1 = height1 - floor(s/2);
            else
                y1 = 1;
            end
            if (height1 + s/2) <= H
                y2 = height1 + ceil(s/2);
            else
                y2 = H;
            end
            count =(x2-x1)*(y2-y1);

            %Border Limits for Square Sum
            if ((x1 ~= 1) && (y1 ~= 1))
                sum = integralM(x2,y2) - integralM(x2,y1-1) - integralM(x1-1,y2) + integralM(x1-1,y1-1);
            elseif ((x1 ~= 1) && (y1 == 1))
                sum = integralM(x2,y2) - integralM(x1-1, y2);
            elseif ((x1 == 1) && (y1 ~= 1))
                sum = integralM(x2,y2) - integralM(x2, y1-1);
            else
                sum = integralM(x2,y2);
            end
            if (greyImg(width1,height1)*count) <= (sum*(100-t)/100)
                output(width1,height1) = 0;
            else
                output(width1,height1) = 1;
            end

        end
    end
    % figure
    % imshow(output)
    % title('Binarization')
end