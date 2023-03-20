clear all;
close all;
clc;

I= imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前畸正.jpg');
ip=[751,477;1156,470;773,695;1138,690];%四个原坐标，由角点检测得到
op=[792,435;1128,435;792,645;1128,645];%四个变换后坐标，由标定板尺寸计算得到,固定
TFromF=fitgeotrans(ip,op,'projective');%计算变换矩阵

I_trans = imwarp(I,TFromF,'bilinear','OutputView',imref2d(size(I)));%双线性插值，原图像尺寸
imshow(I_trans);

%imwrite(I_trans,'C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前俯视.jpg');

save fsbhf.mat TFromF