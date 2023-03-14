%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                            UNIVERSIT DEGLI STUDI DI GENOVA
%                                           COMPUTER VISION: FIRST ASSIGNMENT
%                                                Giacomo Lugano S5400573
%                                              Claudio Tomaiuolo S5630055 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% upload images:
picture1 = double(imread("tree.png"));
picture2 = double(imread("i235.png"));

% set noise parameters:
nstdev = 20; % standard deviation for the gaussian noise
nrate = 0.2; % noise rate of the salt & pepper noise

% set filter parametrs:
kdim = [3 , 7];

% 1)add Gaussian (stdev = 20) and salt & pepper (nrate = 20%) noise to the provided images:

% computing noise:
[gnpicture1, sppicture1] = noise(picture1, nstdev, nrate);
[gnpicture2, sppicture2] = noise(picture2, nstdev, nrate);

% 2) remove the noise by using a moving average, a low-pass Gaussian filter and a median filter:

% filtering:

% filter 3x3
[afpicturegn13, aKgn13, gfpicturegn13, gKgn13, mfpicturegn13] = filterim(gnpicture1, kdim(1));
[afpicturegn23, aKgn23, gfpicturegn23, gKgn23, mfpicturegn23] = filterim(gnpicture2, kdim(1));

[afpicturesp13, aKsp13, gfpicturesp13, gKsp13, mfpicturesp13] = filterim(sppicture1, kdim(1));
[afpicturesp23, aKsp23, gfpicturesp23, gKsp23, mfpicturesp23] = filterim(sppicture2, kdim(1));

% filter 7x7
[afpicturegn17, aKgn17, gfpicturegn17, gKgn17, mfpicturegn17] = filterim(gnpicture1, kdim(2));
[afpicturegn27, aKgn27, gfpicturegn27, gKgn27, mfpicturegn27] = filterim(gnpicture2, kdim(2));

[afpicturesp17, aKsp17, gfpicturesp17, gKsp17, mfpicturesp17] = filterim(sppicture1, kdim(2));
[afpicturesp27, aKsp27, gfpicturesp27, gKsp27, mfpicturesp27] = filterim(sppicture2, kdim(2));

% 3) implement the slides 41-45 "practice with linear filters":

% linear filtering:
[K11, f1picture1, K21, f2picture1, K31, f3picture1, K41, f4picture1, K51, detail1, sharpicture1] = lifilter(picture1);
[K12, f1picture2, K22, f2picture2, K32, f3picture2, K42, f4picture2, K52, detail2, sharpicture2] = lifilter(picture2);

% 4) apply the fourier transform (FFT) on the provided images:
% defining the gaussian low-pass filter:
stdev = 5;
[X1,Y1] = meshgrid(1:101);
X = X1-101/2;
Y = Y1-101/2;
Glpf = 1/(2*pi*stdev).*exp(-((X.^2)+(Y.^2))/(2*stdev^2));

% define the sharpening filter:
Ks1 = zeros(7);
Ks1(4,4) = 2;
Ks2 = ones(7)/49;
Ks = Ks1 - Ks2;
support = zeros(101);
support(51, 51) = 1;
Ks = conv2(support,Ks,'same');

% compute the fast fourierr transformation:
[fftpicture1] = FastFourierrT (picture1);
[fftpicture2] = FastFourierrT (picture2);
[fftpictureGlpf] = FastFourierrT (Glpf);
[fftpictureKs] = FastFourierrT (Ks);

% display all the results obtained:

% display part 1 results and computing histograms:
figure(1); % part 1, noised pictures  of tree with histograms
subplot(2,3,1), imagesc(gnpicture1), title('gaussian noised picture'), colormap gray;
subplot(2,3,2), imagesc(picture1), title('original picture'), colormap gray;
subplot(2,3,3), imagesc(sppicture1), title('salt and pepper noised picture'), colormap gray;
subplot(2,3,4), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,3,5), imhist(uint8(picture1)), title('original picture histo'), colormap gray;
subplot(2,3,6), imhist(uint8(sppicture1)), title('salt and pepper noised histogram'), colormap gray;

figure(2); % part 1, noised pictures of i235 with histograms
subplot(2,3,1), imagesc(gnpicture2), title('gaussian noised picture'), colormap gray;
subplot(2,3,2), imagesc(picture2), title('original picture'), colormap gray;
subplot(2,3,3), imagesc(sppicture2), title('salt and pepper noised picture'), colormap gray;
subplot(2,3,4), imhist(uint8(gnpicture2)), title('gaussian noised histogram'), colormap gray;
subplot(2,3,5), imhist(uint8(picture2)), title('original picture histo'), colormap gray;
subplot(2,3,6), imhist(uint8(sppicture2)), title('salt and pepper noised histogram'), colormap gray;

% display part 2 results and computing histograms (filter dimension 3x3):
figure(3); % part 2, gaussian noised picture tree filtered by an average filter (dim 3x3)
subplot(2,2,1), imagesc(gnpicture1), title('gaussian noised picture1'), colormap gray;
subplot(2,2,2), imagesc(afpicturegn13), title('average filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturegn13)), title('average filtered histogram'), colormap gray;

figure(4); % part 2, gaussian noised picture tree filtered by a gaussian filter (dim 3x3)
subplot(2,4,1), imagesc(gnpicture1), title('gaussian noised picture1'), colormap gray;
subplot(2,4,2), imagesc(gKgn13), title('gaussian filter kdim=3x3'), colormap gray;
subplot(2,4,3), surf(gKgn13), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturegn13), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturegn13)), title('gaussian filtered histogram'), colormap gray;

figure(5); % part 2, gaussian noised picture tree filtered by a median filter
subplot(2,2,1), imagesc(gnpicture1), title('gaussian noised picture1'), colormap gray;
subplot(2,2,2), imagesc(mfpicturegn13), title('median filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturegn13)), title('median filtered histogram'), colormap gray;

figure(6); % part 2, gaussian noised picture i235 filtered by an average filter (dim 3x3)
subplot(2,2,1), imagesc(gnpicture2), title('gaussian noised picture2'), colormap gray;
subplot(2,2,2), imagesc(afpicturegn23), title('average filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture2)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturegn23)), title('average filtered histogram'), colormap gray;

figure(7); % part 2, gaussian noised picture i235 filtered by a gaussian filter (dim 3x3)
subplot(2,4,1), imagesc(gnpicture2), title('gaussian noised picture2'), colormap gray;
subplot(2,4,2), imagesc(gKgn23), title('gaussian filter kdim=3x3'), colormap gray;
subplot(2,4,3), surf(gKgn23), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturegn23), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(gnpicture2)), title('gaussian noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturegn23)), title('gaussian filtered histogram'), colormap gray;

figure(8); % part 2, gaussian noised picture i235 filtered by a median filter 
subplot(2,2,1), imagesc(gnpicture2), title('gaussian noised picture2'), colormap gray;
subplot(2,2,2), imagesc(mfpicturegn23), title('median filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturegn23)), title('median filtered histogram'), colormap gray;

figure(9); % part 2, salt & pepper noised picture tree filtered by an average filter (dim 3x3)
subplot(2,2,1), imagesc(sppicture1), title('salt & pepper noised picture1'), colormap gray;
subplot(2,2,2), imagesc(afpicturesp13), title('average filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture1)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturesp13)), title('average filtered histogram'), colormap gray;

figure(10); % part 2, salt & pepper noised picture tree filtered by a gaussian filter (dim 3x3)
subplot(2,4,1), imagesc(sppicture1), title('salt & pepper noised picture1'), colormap gray;
subplot(2,4,2), imagesc(gKsp13), title('gaussian filter kdim=3x3'), colormap gray;
subplot(2,4,3), surf(gKsp13), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturesp13), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(sppicture1)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturesp13)), title('gaussian filtered histogram'), colormap gray;

figure(11); % part 2, salt & pepper noised picture tree filtered by a median filter
subplot(2,2,1), imagesc(sppicture1), title('salt & pepper noised picture1'), colormap gray;
subplot(2,2,2), imagesc(mfpicturesp13), title('median filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture1)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturesp13)), title('median filtered histogram'), colormap gray;

figure(12); % part 2, salt & pepper noised picture i235 filtered by an average filter (dim 3x3)
subplot(2,2,1), imagesc(sppicture2), title('salt & pepper noised picture2'), colormap gray;
subplot(2,2,2), imagesc(afpicturesp23), title('average filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture2)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturesp23)), title('average filtered histogram'), colormap gray;

figure(13); % part 2, salt & pepper noised picture i235 filtered by a gaussian filter (dim 3x3)
subplot(2,4,1), imagesc(sppicture2), title('salt & pepper noised picture2'), colormap gray;
subplot(2,4,2), imagesc(gKsp23), title('gaussian filter kdim=3x3'), colormap gray;
subplot(2,4,3), surf(gKsp23), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturesp23), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(sppicture2)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturesp23)), title('gaussian filtered histogram'), colormap gray;

figure(14); % part 2, salt & pepper noised picture i235 filtered by a median filter (dim 3x3)
subplot(2,2,1), imagesc(sppicture2), title('salt & pepper noised picture2'), colormap gray;
subplot(2,2,2), imagesc(mfpicturesp23), title('median filtered picture kdim=3x3'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture2)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturesp23)), title('median filtered histogram'), colormap gray;

% display part 2 results and computing histograms (filter dimension 7x7):
figure(15); % part 2, gaussian noised picture tree filtered by an average filter (dim 7x7)
subplot(2,2,1), imagesc(gnpicture1), title('gaussian noised picture1'), colormap gray;
subplot(2,2,2), imagesc(afpicturegn17), title('average filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturegn17)), title('average filtered histogram'), colormap gray;

figure(16); % part 2, gaussian noised picture tree filtered by a gaussian filter (dim 7x7)
subplot(2,4,1), imagesc(gnpicture1), title('gaussian noised picture1'), colormap gray;
subplot(2,4,2), imagesc(gKgn17), title('gaussian filter kdim=7x7'), colormap gray;
subplot(2,4,3), surf(gKgn17), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturegn17), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturegn17)), title('gaussian filtered histogram'), colormap gray;

figure(17); % part 2, gaussian noised picture tree filtered by a median filter
subplot(2,2,1), imagesc(gnpicture1), title('gaussian noised picture1'), colormap gray;
subplot(2,2,2), imagesc(mfpicturegn17), title('median filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturegn17)), title('median filtered histogram'), colormap gray;

figure(18); % part 2, gaussian noised picture i235 filtered by an average filter (dim 7x7)
subplot(2,2,1), imagesc(gnpicture2), title('gaussian noised picture2'), colormap gray;
subplot(2,2,2), imagesc(afpicturegn27), title('average filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture2)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturegn27)), title('average filtered histogram'), colormap gray;

figure(19); % part 2, gaussian noised picture i235 filtered by a gaussian filter (dim 7x7)
subplot(2,4,1), imagesc(gnpicture2), title('gaussian noised picture2'), colormap gray;
subplot(2,4,2), imagesc(gKgn27), title('gaussian filter kdim=7x7'), colormap gray;
subplot(2,4,3), surf(gKgn27), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturegn27), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(gnpicture2)), title('gaussian noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturegn27)), title('gaussian filtered histogram'), colormap gray;

figure(20); % part 2, gaussian noised picture i235 filtered by a median filter
subplot(2,2,1), imagesc(gnpicture2), title('gaussian noised picture2'), colormap gray;
subplot(2,2,2), imagesc(mfpicturegn27), title('median filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(gnpicture1)), title('gaussian noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturegn27)), title('median filtered histogram'), colormap gray;

figure(21); % part 2, salt & pepper noised picture tree filtered by an average filter (dim 7x7)
subplot(2,2,1), imagesc(sppicture1), title('salt & pepper noised picture1'), colormap gray;
subplot(2,2,2), imagesc(afpicturesp17), title('average filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture1)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturesp17)), title('average filtered histogram'), colormap gray;

figure(22); % part 2, salt & pepper noised picture tree filtered by a gaussian filter (dim 7x7)
subplot(2,4,1), imagesc(sppicture1), title('salt & pepper noised picture1'), colormap gray;
subplot(2,4,2), imagesc(gKsp17), title('gaussian filter kdim=7x7'), colormap gray;
subplot(2,4,3), surf(gKsp17), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturesp17), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(sppicture1)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturesp17)), title('gaussian filtered histogram'), colormap gray;

figure(23); % part 2, salt & pepper noised picture tree filtered by a median filter
subplot(2,2,1), imagesc(sppicture1), title('salt & pepper noised picture1'), colormap gray;
subplot(2,2,2), imagesc(mfpicturesp17), title('median filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture1)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturesp17)), title('median filtered histogram'), colormap gray;

figure(24); % part 2, salt & pepper noised picture i235 filtered by an average filter (dim 7x7)
subplot(2,2,1), imagesc(sppicture2), title('salt & pepper noised picture2'), colormap gray;
subplot(2,2,2), imagesc(afpicturesp27), title('average filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture2)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(afpicturesp27)), title('average filtered histogram'), colormap gray;

figure(25); % part 2, salt & pepper noised picture i235 filtered by a gaussian filter (dim 7x7)
subplot(2,4,1), imagesc(sppicture2), title('salt & pepper noised picture2'), colormap gray;
subplot(2,4,2), imagesc(gKsp27), title('gaussian filter kdim=7x7'), colormap gray;
subplot(2,4,3), surf(gKsp27), title('gaussian filter'), colormap gray;
subplot(2,4,4), imagesc(gfpicturesp27), title('gaussian filtered picture'), colormap gray;
subplot(2,4,5), imhist(uint8(sppicture2)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,4,8), imhist(uint8(gfpicturesp27)), title('gaussian filtered histogram'), colormap gray;

figure(26); % part 2, salt & pepper noised picture i235 filtered by a median filter
subplot(2,2,1), imagesc(sppicture2), title('salt & pepper noised picture2'), colormap gray;
subplot(2,2,2), imagesc(mfpicturesp27), title('median filtered picture kdim=7x7'), colormap gray;
subplot(2,2,3), imhist(uint8(sppicture2)), title('salt & pepper noised histogram'), colormap gray;
subplot(2,2,4), imhist(uint8(mfpicturesp27)), title('median filtered histogram'), colormap gray;

% display part 3 results:
figure(27); % part 3, picture tree filtered by filter1 (pag.41)
subplot(1,4,1), imagesc(picture1), title('original picture1'), colormap gray;
subplot(1,4,2), imagesc(K11), title('filter1'), colormap gray;
subplot(1,4,3), surf(K11), title('filter1 3D'), colormap gray;
subplot(1,4,4), imagesc(f1picture1), title('filtered1 picture1'), colormap gray;

figure(28); % part 3, picture tree filtered by filter2 (pag.42)
subplot(1,4,1), imagesc(picture1), title('original picture1'), colormap gray;
subplot(1,4,2), imagesc(K21), title('filter2'), colormap gray;
subplot(1,4,3), surf(K21), title('filter2 3D'), colormap gray;
subplot(1,4,4), imagesc(f2picture1), title('filtered2 picture1'), colormap gray;

figure(29); % part 3, picture tree filtered by filter3 (pag.43)
subplot(1,4,1), imagesc(picture1), title('original picture1'), colormap gray;
subplot(1,4,2), imagesc(K31), title('filter3'), colormap gray;
subplot(1,4,3), surf(K31), title('filter3 3D'), colormap gray;
subplot(1,4,4), imagesc(f3picture1), title('filtered3 picture1'), colormap gray;

figure(30); % part 3, picture tree filtered by filter4 (pag.44)
subplot(1,4,1), imagesc(picture1), title('original picture1'), colormap gray;
subplot(1,4,2), imagesc(K41), title('filter4'), colormap gray;
subplot(1,4,3), surf(K41), title('filter4 3D'), colormap gray;
subplot(1,4,4), imagesc(f4picture1), title('filtered4 picture1'), colormap gray;

figure(31); % part 3, picture tree details and sharpened picture (a=2) (pag.45)
subplot(1,3,1), imagesc(picture1), title('original picture1'), colormap gray;
subplot(1,3,2), imagesc(detail1), title('detail picture1'), colormap gray;
subplot(1,3,3), imagesc(sharpicture1), title('sharpened picture1'), colormap gray;

figure(32); % part 3, picture i235 filtered by filter1 (pag.41)
subplot(1,4,1), imagesc(picture2), title('original picture2'), colormap gray;
subplot(1,4,2), imagesc(K12), title('filter1'), colormap gray;
subplot(1,4,3), surf(K12), title('filter1 3D'), colormap gray;
subplot(1,4,4), imagesc(f1picture2), title('filtered1 picture2'), colormap gray;

figure(33); % part 3, picture i235 filtered by filter2 (pag.42)
subplot(1,4,1), imagesc(picture2), title('original picture2'), colormap gray;
subplot(1,4,2), imagesc(K22), title('filter2'), colormap gray;
subplot(1,4,3), surf(K22), title('filter2 3D'), colormap gray;
subplot(1,4,4), imagesc(f2picture2), title('filtered2 picture2'), colormap gray;

figure(34); % part 3, picture i235 filtered by filter3 (pag.43)
subplot(1,4,1), imagesc(picture2), title('original picture2'), colormap gray;
subplot(1,4,2), imagesc(K32), title('filter3'), colormap gray;
subplot(1,4,3), surf(K32), title('filter3 3D'), colormap gray;
subplot(1,4,4), imagesc(f3picture2), title('filtered3 picture2'), colormap gray;

figure(35); % part 3, picture i235 filtered by filter4 (pag.44)
subplot(1,4,1), imagesc(picture2), title('original picture2'), colormap gray;
subplot(1,4,2), imagesc(K42), title('filter4'), colormap gray;
subplot(1,4,3), surf(K42), title('filter4 3D'), colormap gray;
subplot(1,4,4), imagesc(f4picture2), title('filtered4 picture2'), colormap gray;

figure(36); % part 3, picture i235 details and sharpened picture (a=2) (pag.45)
subplot(1,3,1), imagesc(picture2), title('original picture2'), colormap gray;
subplot(1,3,2), imagesc(detail2), title('detail picture2'), colormap gray;
subplot(1,3,3), imagesc(sharpicture2), title('sharpened picture2'), colormap gray;

% display part 4 results:
figure(37); % part 4, picture tree and his FFT
subplot(1,2,1), imagesc(picture1), title('original picture1'), colormap gray;
subplot(1,2,2), imagesc(fftpicture1), title('fast fourier transformed picture1'), colormap gray;

figure(38); % part 4, picture i235 and his FFT
subplot(1,2,1), imagesc(picture2), title('original picture2'), colormap gray;
subplot(1,2,2), imagesc(fftpicture2), title('fast fourier transformed picture2'), colormap gray;

figure(39); % part 4, gaussian low-pass filter and his FFT
subplot(2,2,1), imagesc(Glpf), title('original gaussian low-pass filter'), colormap gray;
subplot(2,2,2), imagesc(fftpictureGlpf), title('fast fourier transformed gaussian low-pass filter'), colormap gray;
subplot(2,2,3), surf(Glpf), colormap gray;
subplot(2,2,4), surf(fftpictureGlpf), colormap gray;

figure(40); % part 4, sharpening filter and his FFT
subplot(2,2,1), imagesc(Ks), title('original sharpening filter'), colormap gray;
subplot(2,2,2), imagesc(fftpictureKs), title('fast fourier transformed sharpening filter'), colormap gray;
subplot(2,2,3), surf(Ks), colormap gray;
subplot(2,2,4), surf(fftpictureKs), colormap gray;