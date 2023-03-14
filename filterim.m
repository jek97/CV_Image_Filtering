function [afpicture, aK, gfpicture, gK, mfpicture] = filterim(picture, kdim)

% average filter:
aK = ones(kdim)/(kdim^2);
afpicture = conv2(picture,aK,'same');
% aK = fspecial('average',kdim);

% gaussian filter:
stdev = kdim/6;
[X,Y] = meshgrid(-kdim/2:+kdim/2,-kdim/2:+kdim/2);
gK = 1/(2*pi*stdev).*exp(-((X.^2)+(Y.^2))/(2*stdev^2));
gfpicture = conv2(picture,gK,'same');
% gK = fspecial('gaussian',kdim,(kdim/6));

% median filter:
mfpicture = medfilt2(picture,[kdim, kdim]);

end