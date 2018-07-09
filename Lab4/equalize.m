% Input Img I
% Output Z
function Z = equalize(I)
n = 256;

[r, c]   = size (I);
I        = mat2gray (I);
[X, map] = gray2ind (I, n); % converts the grayscale image I to an indexed image X
[nn, xx] = imhist (I, n); % returns the histogram counts in nn and the bin locations in xx
Icdf     = 1 / prod (size (I)) * cumsum (nn);
Z        = reshape (Icdf(X + 1), r, c);

