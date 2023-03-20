clear all;
close all;
clc;
load fsbhr.mat TFromR  %导入俯视变换矩阵
load fsbhl.mat TFromL
load fsbhf.mat TFromF
load fsbhb.mat TFromB
load pbm.mat TF TB TL TR vFM vBM vLM vRM%导入拼接融合数据
load yingshe.mat BWF2 BWB2 BWR2 BWL2 BWL2 ZF ZB ZR ZL%映射数据
%先畸变矫正
load('前路calibrationSession.mat');
F=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前原.jpg');
F=undistortImage(F,calibrationSession.CameraParameters);
load('后路calibrationSession.mat');
B=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\后\后原.jpg');
B=undistortImage(B,calibrationSession.CameraParameters);
load('左路calibrationSession.mat');
L=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左原.jpg');
L=undistortImage(L,calibrationSession.CameraParameters);
load('右路calibrationSession.mat');
R=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\右\右原.jpg');
R=undistortImage(R,calibrationSession.CameraParameters);

F=double(F);B=double(B);L=double(L);R=double(R);
for i=1:3%裁取所需像素
   F(:,:,i)=immultiply(BWF2,F(:,:,i));
   B(:,:,i)=immultiply(BWB2,B(:,:,i));
   L(:,:,i)=immultiply(BWL2,L(:,:,i));
   R(:,:,i)=immultiply(BWR2,R(:,:,i));
end

OR=zeros(1080,1920);%原图，透视图，俯视图尺寸
S=zeros(1411,1633);%全景图尺寸
F=imwarp(F,TFromF,'bilinear','OutputView',imref2d(size(OR)));%变换到俯视图
F=imwarp(F,TF,'bilinear','OutputView',imref2d(size(S)));%变换到全景图
B=imwarp(B,TFromB,'bilinear','OutputView',imref2d(size(OR)));
B=imwarp(B,TB,'bilinear','OutputView',imref2d(size(S)));
L=imwarp(L,TFromL,'bilinear','OutputView',imref2d(size(OR)));
L=imwarp(L,TL,'bilinear','OutputView',imref2d(size(S)));
R=imwarp(R,TFromR,'bilinear','OutputView',imref2d(size(OR)));
R=imwarp(R,TR,'bilinear','OutputView',imref2d(size(S)));
%乘权值
for i=1:3
    QF(:,:,i)=immultiply(ZF,vFM*F(:,:,i));
    QL(:,:,i)=immultiply(ZL,vLM*L(:,:,i));
    QB(:,:,i)=immultiply(ZB,vBM*B(:,:,i));
    QR(:,:,i)=immultiply(ZR,vRM*R(:,:,i));
end

QF=uint8(QF);QB=uint8(QB);QL=uint8(QL);QR=uint8(QR);
Q=QF+QL+QB+QR;%全景图
imshow(Q);
%imwrite(QF,'C:\Users\Yanan\Desktop\毕业设计\四路照片\融合\映射前路.jpg');
%imwrite(Q,'C:\Users\Yanan\Desktop\毕业设计\四路照片\融合\映射标定板.jpg');