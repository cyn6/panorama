clear all;
close all;
clc;
load yingshebiao.mat ZF ZB ZR ZL BWF BWB BWR BWL TF TB TL TR JF JB JL JR%导入映射数据表

F=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前原.jpg');%先畸变矫正
F=undistortImage(F,JF);
B=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\后\后原.jpg');
B=undistortImage(B,JB);
L=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左原.jpg');
L=undistortImage(L,JL);
R=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\右\右原.jpg');
R=undistortImage(R,JR);

F=double(F);B=double(B);L=double(L);R=double(R);
S=zeros(1411,1633);%全景图尺寸
F=imwarp(F,TF,'bilinear','OutputView',imref2d(size(S)));%直接变换到全景图
B=imwarp(B,TB,'bilinear','OutputView',imref2d(size(S)));
L=imwarp(L,TL,'bilinear','OutputView',imref2d(size(S)));
R=imwarp(R,TR,'bilinear','OutputView',imref2d(size(S)));

L(:,:,3)=1.04*L(:,:,3);B(:,:,3)=1.04*B(:,:,3);R(:,:,1)=1.02*R(:,:,1);%手动调整相机原有颜色偏差
F=F.*ZF.*BWF;%乘权值并裁取所需像素
B=B.*ZB.*BWB;
L=L.*ZL.*BWL;
R=R.*ZR.*BWR;

F=uint8(F);B=uint8(B);L=uint8(L);R=uint8(R);%回到uint8型显示
Q=F+L+B+R;%全景图
imshow(Q);
%imwrite(Q,'C:\Users\Yanan\Desktop\毕业设计\四路照片\融合\my使用映射—标定板.jpg');
%平均1.5秒