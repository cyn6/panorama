clear all;
close all;
clc;

load yingshebiao.mat TF TB TL TR JF JB JL JR%映射数据

F=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\前\前内.jpg');%先畸变矫正
F=undistortImage(F,JF);
B=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\后\后内.jpg');
B=undistortImage(B,JB);
L=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\左\左内.jpg');
L=undistortImage(L,JL);
R=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\实景\右\右内.jpg');
R=undistortImage(R,JR);

F=double(F);B=double(B);L=double(L);R=double(R);
S=zeros(1411,1633);%全景图尺寸
F_trans=imwarp(F,TF,'bilinear','OutputView',imref2d(size(S)));%直接变换到全景图
B_trans=imwarp(B,TB,'bilinear','OutputView',imref2d(size(S)));
L_trans=imwarp(L,TL,'bilinear','OutputView',imref2d(size(S)));
R_trans=imwarp(R,TR,'bilinear','OutputView',imref2d(size(S)));

t=80;
F4=0;F1=0;L1=0;L2=0;B2=0;B3=0;R3=0;R4=0;
F_transd=F_trans;
B_transd=B_trans;
L_transd=L_trans;
R_transd=R_trans;

%左前
c=[565 565 1+t 1 1 565-t];
r=[847 847+t 1411 1411 1411-t 847];
BW=roipoly(S,c,r);
[y1,x1]=find(BW==1);%第一个数是行坐标，第二个是列坐标
a1max=length(x1);
for a=1:a1max
    F1=F1+sqrt((F_transd(y1(a),x1(a),1))^2+(F_transd(y1(a),x1(a),2))^2+(F_transd(y1(a),x1(a),3))^2);
    L1=L1+sqrt((L_transd(y1(a),x1(a),1))^2+(L_transd(y1(a),x1(a),2))^2+(L_transd(y1(a),x1(a),3))^2);
end
F1=F1/a1max;%灰度均值
L1=L1/a1max;%灰度均值
vLFM=(F1+L1)/2;

%左后
c=[1069 1069 1633-t 1633 1633 1069+t];
r=[847 847+t 1411 1411 1411-t 847];
BW=roipoly(S,c,r);
[y2,x2]=find(BW==1);
a2max=length(x2);
for a=1:a2max
    L2=L2+sqrt((L_transd(y2(a),x2(a),1))^2+(L_transd(y2(a),x2(a),2))^2+(L_transd(y2(a),x2(a),3))^2);
    B2=B2+sqrt((B_transd(y2(a),x2(a),1))^2+(B_transd(y2(a),x2(a),2))^2+(B_transd(y2(a),x2(a),3))^2);
end
L2=L2/a2max;%灰度均值
B2=B2/a2max;%灰度均值
vBLM=(L2+B2)/2;

%右后
c=[1069 1069+t 1633 1633 1633-t 1069];
r=[565 565 1+t 1 1 565-t];
BW=roipoly(S,c,r);
[y3,x3]=find(BW==1);
a3max=length(x3);
for a=1:a3max
    B3=B3+sqrt((B_transd(y3(a),x3(a),1))^2+(B_transd(y3(a),x3(a),2))^2+(B_transd(y3(a),x3(a),3))^2);
    R3=R3+sqrt((R_transd(y3(a),x3(a),1))^2+(R_transd(y3(a),x3(a),2))^2+(R_transd(y3(a),x3(a),3))^2);
end
B3=B3/a3max;%灰度均值
R3=R3/a3max;%灰度均值
vRBM=(B3+R3)/2;

%右前
c=[565 565-t 1 1 1+t 565];
r=[565 565 1+t 1 1 565-t];
BW=roipoly(S,c,r);
[y4,x4]=find(BW==1);
a4max=length(x4);
for a=1:a4max
    R4=R4+sqrt((R_transd(y4(a),x4(a),1))^2+(R_transd(y4(a),x4(a),2))^2+(R_transd(y4(a),x4(a),3))^2);
    F4=F4+sqrt((F_transd(y4(a),x4(a),1))^2+(F_transd(y4(a),x4(a),2))^2+(F_transd(y4(a),x4(a),3))^2);
end
R4=R4/a4max;%灰度均值
F4=F4/a4max;%灰度均值
vFRM=(R4+F4)/2;

vM=(vLFM+vBLM+vRBM+vFRM)/4;
vF=(F1+F4)/2;
vL=(L1+L2)/2;
vB=(B2+B3)/2;
vR=(R3+R4)/2;

vFM=vM/vF;
vLM=vM/vL;
vBM=vM/vB;
vRM=vM/vR;

F_trans=vFM*F_trans;%三个通道像素值都乘
L_trans=vLM*L_trans;
B_trans=vBM*B_trans;
R_trans=vRM*R_trans;

%非重叠区域拼接
%前
c=[565 565 565-t 1 1 565-t];%列坐标，x
r=[565 847 847 1411-t 1+t 565];%行坐标，y
BW=roipoly(F_trans,c,r);
for i=1:3
   QF(:,:,i)=immultiply(BW,F_trans(:,:,i));
end
%后
c=[1069 1069 1069+t 1633 1633 1069+t];%列坐标，x
r=[565 847 847 1411-t 1+t 565];%行坐标，y
BW=roipoly(B_trans,c,r);
for i=1:3
   BF(:,:,i)=immultiply(BW,B_trans(:,:,i));
end
%左
c=[1069 565 565 1+t 1633-t 1069];%列坐标，x
r=[847 847 847+t 1411 1411 847+t];%行坐标，y
BW=roipoly(L_trans,c,r);
for i=1:3
   LF(:,:,i)=immultiply(BW,L_trans(:,:,i));
end
%右
c=[1069 565 565 1+t 1633-t 1069];%列坐标，x
r=[565 565 565-t 1 1 565-t];%行坐标，y
BW=roipoly(R_trans,c,r);
for i=1:3
   RF(:,:,i)=immultiply(BW,R_trans(:,:,i));
end
Q1=QF+BF+LF+RF;

%重叠区域融合
%左前
A1=[1,1411-t];
A2=[565-t,847];
for a=1:a1max
    P=[x1(a),y1(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
    alph=1-d/(sqrt(2)*t);
    for i=1:3
        Q2(y1(a),x1(a),i)=alph*F_trans(y1(a),x1(a),i)+(1-alph)*L_trans(y1(a),x1(a),i);
    end
end

%左后
A1=[1069,847+t];
A2=[1633-t,1411];
for a=1:a2max
    P=[x2(a),y2(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
    alph=1-d/(sqrt(2)*t);
    for i=1:3
        Q2(y2(a),x2(a),i)=alph*L_trans(y2(a),x2(a),i)+(1-alph)*B_trans(y2(a),x2(a),i);
    end
end
%右后
A1=[1069+t,565];
A2=[1633,1+t];
for a=1:a3max
    P=[x3(a),y3(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
    alph=1-d/(sqrt(2)*t);
    for i=1:3
        Q2(y3(a),x3(a),i)=alph*B_trans(y3(a),x3(a),i)+(1-alph)*R_trans(y3(a),x3(a),i);
    end
end
%右前
A1=[565,565-t];
A2=[1+t,1];
for a=1:a4max
    P=[x4(a),y4(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
   alph=1-d/(sqrt(2)*t);
    for i=1:3
        Q2(y4(a),x4(a),i)=alph*R_trans(y4(a),x4(a),i)+(1-alph)*F_trans(y4(a),x4(a),i);
    end
end

Q=uint8(Q1+Q2);
imshow(Q);
imwrite(Q,strcat('C:\Users\Yanan\Desktop\毕业设计\四路照片\渐入渐出法拼接融合内t=',num2str(t),'.jpg'));