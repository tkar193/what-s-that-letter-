function[K] = despeckle(I, nx, ny) %assuming odd dimension neighborhood

%First, extend J so we can apply median filter to it.
J = zeros(size(I,1) + nx-1, size(I,2) + ny-1);
J(ceil(nx/2):(end+1-ceil(nx/2)), ceil(ny/2):(end+1-ceil(ny/2))) = I;
J(ceil(nx/2):(end+1-ceil(nx/2)), 1) = I(:,1);
J(1, ceil(ny/2):(end+1-ceil(ny/2))) = I(1,:);
J(1,1) = I(1,1);
J(1,end) = I(1,end);
J(end,1) = I(end,1);
J(end,end) = I(end,end);
K = zeros(size(J));
for i = ceil(nx/2):(size(J,1)+1-ceil(nx/2))
    for j = ceil(ny/2):(size(J,2)+1-ceil(ny/2))
        L = J(i-floor(nx/2):i+floor(nx/2), j-floor(ny/2):j+floor(ny/2));
        K(i,j) = median(L(:));
    end
end

