clear all;
close all;
clc;
load('后路calibrationSession.mat');
I=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\后\后原.jpg');
J=undistortImage(I,calibrationSession.CameraParameters);
figure;
imshow(J);
imwrite(J,'C:\Users\Yanan\Desktop\毕业设计\四路照片\后\后畸正.jpg');