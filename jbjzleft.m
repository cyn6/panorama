clear all;
close all;
clc;
load('左路calibrationSession.mat');
I=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左原.jpg');
J=undistortImage(I,calibrationSession.CameraParameters);
figure;
imshow(J);
imwrite(J,'C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左畸正.jpg');