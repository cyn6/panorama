clear all;
close all;
clc;
load fsbhr.mat TFromR  %导入俯视变换矩阵
load fsbhl.mat TFromL
load fsbhf.mat TFromF
load fsbhb.mat TFromB
load pbm.mat TF TB TL TR vFM vBM vLM vRM%导入拼接融合数据
load yingshe.mat BWF BWB BWR BWL ZF ZB ZR ZL%映射数据
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
S=zeros(1411,1633);%全景图尺寸
TF.T=TFromF.T*TF.T;%将两次变换矩阵结合，接下来只需一次变换,注意两矩阵位置不能颠倒
F=imwarp(F,TF,'bilinear','OutputView',imref2d(size(S)));%直接变换到全景图
TB.T=TFromB.T*TB.T;
B=imwarp(B,TB,'bilinear','OutputView',imref2d(size(S)));
TL.T=TFromL.T*TL.T;
L=imwarp(L,TL,'bilinear','OutputView',imref2d(size(S)));
TR.T=TFromR.T*TR.T;
R=imwarp(R,TR,'bilinear','OutputView',imref2d(size(S)));

for i=1:3%乘权值
    F(:,:,i)=immultiply(ZF,vFM*F(:,:,i));
    L(:,:,i)=immultiply(ZL,vLM*L(:,:,i));
    B(:,:,i)=immultiply(ZB,vBM*B(:,:,i));
    R(:,:,i)=immultiply(ZR,vRM*R(:,:,i));
end
%这两部顺序不影响
for i=1:3%裁取所需像素
   F(:,:,i)=immultiply(BWF,F(:,:,i));
   B(:,:,i)=immultiply(BWB,B(:,:,i));
   L(:,:,i)=immultiply(BWL,L(:,:,i));
   R(:,:,i)=immultiply(BWR,R(:,:,i));
end

F=uint8(F);B=uint8(B);L=uint8(L);R=uint8(R);%回到uint8型显示
Q=F+L+B+R;%全景图
imshow(Q);
%imwrite(Q,'C:\Users\Yanan\Desktop\毕业设计\四路照片\融合\my改良映射——标定板.jpg');