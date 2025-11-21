% Load the image
a = imread('moon.jpg');

% Add Gaussian noise to the image
noiseLevel = 0.01;  
noise = noiseLevel * randn(size(a));  
img_noisy = im2double(a) + noise;
img_noisy = min(max(img_noisy, 0), 1); 

% Display the noisy image
figure;
imshow(img_noisy, []);
title('Noisy Image');

% Create a Gaussian filter (low-pass filter)
H = fspecial('gaussian', [9 9], 2);  

% Compute the frequency spectrum of the noisy image
ma = abs(fft2(img_noisy)); 

% Compute the frequency spectrum of the Gaussian filter
[nblig, nbcol] = size(img_noisy);
mH = abs(fft2(H, nblig, nbcol)); 

% Apply the filter in the frequency domain
maf = ma .* mH;  
phase = angle(fft2(img_noisy)); 
z = maf .* exp(1i * phase); 
z2 = ifft2(z); 
img_filtered = real(z2); 

% Display the filtered image using Fourier Transform (TF)
figure;
imshow(img_filtered, []);
title('Filtered Image using Gaussian Filter in Frequency Domain');

% Apply wavelet denoising
[thr, sorh, kp] = ddencmp('den', 'wv', img_noisy); 
imgden_wavelet = wdencmp('gbl', img_noisy, 'sym4', 2, thr, sorh, kp);

% Display the wavelet filtered image
figure;
imshow(imgden_wavelet, []);
title('Filtered Image using Wavelet Denoising');

% Compute PSNR (Peak Signal-to-Noise Ratio) between the original and the filtered images
mse_filtered = mean((im2double(a(:)) - img_filtered(:)).^2); 
psnr_filtered = 10 * log10(1 / mse_filtered); 

mse_wavelet = mean((im2double(a(:)) - imgden_wavelet(:)).^2);
psnr_wavelet = 10 * log10(1 / mse_wavelet); 

% Display the PSNR values
disp(['PSNR of the image filtered using Fourier Transform: ' num2str(psnr_filtered, '%.2f') ' dB']);
disp(['PSNR of the image filtered using Wavelet Denoising: ' num2str(psnr_wavelet, '%.2f') ' dB']);
