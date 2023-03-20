clear all;
close all;
clc;
load yingshebiao.mat ZF ZB ZR ZL BWF BWB BWR BWL TF TB TL TR JF JB JL JR%映射数据

F=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\前\前外.jpg');%先畸变矫正
F=undistortImage(F,JF);
B=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\后\后外.jpg');
B=undistortImage(B,JB);
L=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\左\左外.jpg');
L=undistortImage(L,JL);
R=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\右\右外.jpg');
R=undistortImage(R,JR);

F=double(F);B=double(B);L=double(L);R=double(R);
S=zeros(1411,1633);%全景图尺寸
F=imwarp(F,TF,'bilinear','OutputView',imref2d(size(S)));%直接变换到全景图
B=imwarp(B,TB,'bilinear','OutputView',imref2d(size(S)));
L=imwarp(L,TL,'bilinear','OutputView',imref2d(size(S)));
R=imwarp(R,TR,'bilinear','OutputView',imref2d(size(S)));

L(:,:,3)=1.065*L(:,:,3);B(:,:,3)=1.075*B(:,:,3);R(:,:,1)=1.02*R(:,:,1);R=0.87*R;%手动调整相机原有颜色偏差（外）
F=F.*ZF.*BWF;%乘权值并裁取所需像素
B=B.*ZB.*BWB;
L=L.*ZL.*BWL;
R=R.*ZR.*BWR;

F=uint8(F);B=uint8(B);L=uint8(L);R=uint8(R);%回到uint8型显示
Q=F+L+B+R;%全景图
imshow(Q);
%imwrite(Q,'C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\融合\室外效果.jpg');