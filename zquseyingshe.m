clear all;
close all;
clc;
load zqyingshe.mat xF xB xL xR yF yB yL yR xcF xcB xcL xcR ycF ycB ycL ycR ZF ZB ZR ZL%读取映射表
QF=zeros(1411,1633,3);QR=zeros(1411,1633,3);QL=zeros(1411,1633,3);QB=zeros(1411,1633,3);
F=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前原.jpg');%映射坐标
for i=1:length(xcF)
    QF(yF(i),xF(i),:)=F(ycF(i),xcF(i),:);
end
B=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\后\后原.jpg');
for i=1:length(xcB)
    QB(yB(i),xB(i),:)=B(ycB(i),xcB(i),:);
end
L=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左原.jpg');
for i=1:length(xcL)
    QL(yL(i),xL(i),:)=L(ycL(i),xcL(i),:);
end
R=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\右\右原.jpg');
for i=1:length(xcR)
    QR(yR(i),xR(i),:)=R(ycR(i),xcR(i),:);
end

QF=QF.*ZF;%乘权值映射表
QB=QB.*ZB;
QL=QL.*ZL;
QR=QR.*ZR;
QL(:,:,3)=1.04*QL(:,:,3);QB(:,:,3)=1.04*QB(:,:,3);QR(:,:,1)=1.02*QR(:,:,1);%手动调整相机原有颜色偏差

QF=uint8(QF);QB=uint8(QB);QL=uint8(QL);QR=uint8(QR);
Q=QF+QL+QB+QR;%全景图
imshow(Q);
%imwrite(Q,'C:\Users\Yanan\Desktop\毕业设计\四路照片\融合\正确使用映射-标定板.jpg');