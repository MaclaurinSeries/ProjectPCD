clc; clear; close all;

rubik = imread('gambar1.jpg');
rubik = im2double(rubik);

rubikgray = rgb2gray(rubik);

rubikgray = fftshift(fft2(rubikgray));

[x, y] = size(rubikgray);
[X, Y] = meshgrid(1:x,1:y);
mesh = transpose((X - x/2).^2 + (Y - y/2).^2 < 25600);
rubikgray = rubikgray .* mesh;

filtered = abs(ifft2(fftshift(rubikgray)));

bw = imbinarize(filtered, 0.2);
bw = 1 - bw;

CC = bwconncomp(bw);
cData = regionprops(CC, 'BoundingBox');

rubik = imcrop(rubik, cData(1).BoundingBox);
rubik = imresize(rubik, [50, 50]);

imshow(rubik);

%imshow(bw);