clear all;
close all;
clc;

I= imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左畸正.jpg');
ip=[703,432;1113,431;724,658;1095,654];%四个原坐标，由角点检测得到
op=[792,435;1128,435;792,645;1128,645];%四个变换后坐标，由标定板尺寸计算得到,固定
TFromL=fitgeotrans(ip,op,'projective');%计算变换矩阵

I_trans = imwarp(I,TFromL,'bilinear','OutputView',imref2d(size(I)));%双线性插值，原图像尺寸
imshow(I_trans);

%imwrite(I_trans,'C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左俯视.jpg');

save fsbhl.mat TFromL