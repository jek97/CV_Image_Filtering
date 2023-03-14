function [K1, f1picture, K2, f2picture, K3, f3picture, K4, f4picture, K5, detail, sharpicture] = lifilter(picture)
% filter1: (pag. 41)
K1 = zeros(7);
K1(4,4) = 1;
f1picture = conv2(picture, K1, 'same');

% filter2: (pag. 42)
K2 = zeros(7);
K2(4,1) = 1;
f2picture = conv2(picture, K2, 'same');

% filter3: (pag. 43)
K3 = ones(7)/49;
f3picture = conv2(picture, K3, 'same');

% filter4: (pag. 44)
K41 = zeros(7);
K41(4,4) = 2;
K42 = ones(7)/49;
K4 = K41 - K42;
f4picture = conv2(picture, K4, 'same');

% filter5: (pag. 45)
K5 = ones(7)/49;
smotpicture = conv2(picture, K5, 'same');
detail = picture - smotpicture;
sharpicture = picture + (2 .* detail);

end