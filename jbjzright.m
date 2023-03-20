clear all;
close all;
clc;
load('右路calibrationSession.mat');
I=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\右\右原.jpg');
J=undistortImage(I,calibrationSession.CameraParameters);
figure;
imshow(J);
imwrite(J,'C:\Users\Yanan\Desktop\毕业设计\四路照片\右\右畸正.jpg');