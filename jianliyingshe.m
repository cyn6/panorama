clear all;
close all;
clc;

load fsbhr.mat TFromR  %导入俯视变换矩阵
load fsbhl.mat TFromL
load fsbhf.mat TFromF
load fsbhb.mat TFromB
load pbm.mat  t a1max a2max a3max a4max x1 y1 x2 y2 x3 y3 x4 y4 Q TF TB TL TR%导入拼接融合数据

OR=zeros(1080,1920);%原图，透视图，俯视图尺寸
%前
c=[1 1+t 565 565 1+t 1];
r=[1 1 565-t 847+t 1411 1411];
BWF=roipoly(Q,c,r);
TF.T=inv(TF.T)*inv(TFromF.T);
BWF2=imwarp(BWF,TF,'cubic','OutputView',imref2d(size(OR)));%直接变换到透视图，采用三次插值提高精度

%变换到畸变图过于复杂，且有误差，因此不变
%左
c=[1 1 565-t 1069+t 1633 1633];
r=[1411 1411-t 847 847 1411-t 1411];
BWL=roipoly(Q,c,r);
TL.T=inv(TL.T)*inv(TFromL.T);
BWL2=imwarp(BWL,TL,'cubic','OutputView',imref2d(size(OR)));%直接变换到透视图
%后
c=[1633 1633-t 1069 1069 1633-t 1633];
r=[1411 1411 847+t 565-t 1 1];
BWB=roipoly(Q,c,r);
TB.T=inv(TB.T)*inv(TFromB.T);
BWB2=imwarp(BWB,TB,'cubic','OutputView',imref2d(size(OR)));%直接变换到透视图
%右
c=[1633 1633 1069+t 565-t 1 1];
r=[1 1+t 565 565 1+t 1];
BWR=roipoly(Q,c,r);
TR.T=inv(TR.T)*inv(TFromR.T);
BWR2=imwarp(BWR,TR,'cubic','OutputView',imref2d(size(OR)));%直接变换到透视图

%建立融合权值系数表
ZF=ones(1411,1633);
ZB=ones(1411,1633);
ZL=ones(1411,1633);
ZR=ones(1411,1633);
%左前
A1=[1,1411-t];
A2=[565-t,847];
for a=1:a1max
    P=[x1(a),y1(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
    alph=0.5*cos(d*pi/(sqrt(2)*t))+0.5;
        ZF(y1(a),x1(a))=alph;
        ZL(y1(a),x1(a))=1-alph;
end
%左后
A1=[1069,847+t];
A2=[1633-t,1411];
for a=1:a2max
    P=[x2(a),y2(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
    alph=0.5*cos(d*pi/(sqrt(2)*t))+0.5;
        ZL(y2(a),x2(a))=alph;
        ZB(y2(a),x2(a))=1-alph;
end
%右后
A1=[1069+t,565];
A2=[1633,1+t];
for a=1:a3max
    P=[x3(a),y3(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
    alph=0.5*cos(d*pi/(sqrt(2)*t))+0.5;
        ZB(y3(a),x3(a))=alph;
        ZR(y3(a),x3(a))=1-alph;
end
%右前
A1=[565,565-t];
A2=[1+t,1];
for a=1:a4max
    P=[x4(a),y4(a)];
    d=abs(det([A2-P;A1-P]))/norm(A2-A1);
    alph=0.5*cos(d*pi/(sqrt(2)*t))+0.5;
        ZR(y4(a),x4(a))=alph;
        ZF(y4(a),x4(a))=1-alph;
end
save yingshe.mat BWF2 BWB2 BWR2 BWL2 ZF ZB ZR ZL BWF BWB BWR BWL