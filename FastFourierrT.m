function [fftpicture] = FastFourierrT (picture)
picture1 = fft2(picture);
fftpicture = log(fftshift(abs(picture1)));
end