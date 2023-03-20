clear all;
close all;
clc;
load('前路calibrationSession.mat');
I=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前原.jpg');
J=undistortImage(I,calibrationSession.CameraParameters);
figure;
imshow(J);
imwrite(J,'C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前畸正.jpg');