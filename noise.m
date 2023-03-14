function [gnpicture, sppicture] = noise(picture, nstdev, nrate)

% gaussian noise
gnpicture = picture + nstdev * randn(size(picture));

% salt and pepper noise:
[rr,cc] = size(picture);
maxv = max(max(picture));
rnoise = full(sprand(rr,cc,nrate));
brnoise = rnoise > 0 & rnoise < 0.5;
wrnoise = rnoise >= 0.5;
ppicture = picture .* ~brnoise;
sppicture = ppicture .* ~wrnoise + maxv * wrnoise;

end