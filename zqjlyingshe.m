clear all;
close all;
clc;

load fsbhr.mat TFromR  %导入俯视变换矩阵
load fsbhl.mat TFromL
load fsbhf.mat TFromF
load fsbhb.mat TFromB
load pbm.mat  t a1max a2max a3max a4max x1 y1 x2 y2 x3 y3 x4 y4 Q TF TB TL TR vFM vBM vLM vRM%导入拼接融合数据

OR=zeros(1080,1920);%原图，透视图，俯视图尺寸
%前
load 前路calibrationSession.mat
fx=calibrationSession.CameraParameters.IntrinsicMatrix(1,1);
fy=calibrationSession.CameraParameters.IntrinsicMatrix(2,2);
cx=calibrationSession.CameraParameters.IntrinsicMatrix(3,1);
cy=calibrationSession.CameraParameters.IntrinsicMatrix(3,2);
k1=calibrationSession.CameraParameters.RadialDistortion(1);
k2=calibrationSession.CameraParameters.RadialDistortion(2);
c=[1 1+t 565 565 1+t 1];
r=[1 1 565-t 847+t 1411 1411];
BWF=roipoly(Q,c,r);
[yF,xF]=find(BWF==1);%第一个数是行坐标，第二个是列坐标
aFmax=length(xF);
TYF=inv(TFromF.T')*inv(TF.T');%注意顺序，注意matlab里矩阵和算法里是转置的
for a=1:aFmax
    pix=TYF*[xF(a);yF(a);1];%由全景图变换到透视图坐标
    pix=pix/pix(3);
    %变换到畸变图
    x=(pix(1)-cx)/fx;%换成物理坐标
    y=(pix(2)-cy)/fy;
    r2=x^2+y^2;
    xc=x*(1+k1*r2+k2*r2^2);
    yc=y*(1+k1*r2+k2*r2^2);
    xcF(a)=xc*fx+cx;%换到图像坐标,畸变图坐标
    ycF(a)=yc*fy+cy;
end 
%左
load 左路calibrationSession.mat
fx=calibrationSession.CameraParameters.IntrinsicMatrix(1,1);
fy=calibrationSession.CameraParameters.IntrinsicMatrix(2,2);
cx=calibrationSession.CameraParameters.IntrinsicMatrix(3,1);
cy=calibrationSession.CameraParameters.IntrinsicMatrix(3,2);
k1=calibrationSession.CameraParameters.RadialDistortion(1);
k2=calibrationSession.CameraParameters.RadialDistortion(2);
c=[1 1 565-t 1069+t 1633 1633];
r=[1411 1411-t 847 847 1411-t 1411];
BWL=roipoly(Q,c,r);
[yL,xL]=find(BWL==1);%第一个数是行坐标，第二个是列坐标
aLmax=length(xL);
TYL=inv(TFromL.T')*inv(TL.T');%注意顺序，注意matlab里矩阵和算法里是转置的
for a=1:aLmax
    pix=TYL*[xL(a);yL(a);1];%由全景图变换到透视图坐标
    pix=pix/pix(3);
    %变换到畸变图
    x=(pix(1)-cx)/fx;%换成物理坐标
    y=(pix(2)-cy)/fy;
    r2=x^2+y^2;
    xc=x*(1+k1*r2+k2*r2^2);
    yc=y*(1+k1*r2+k2*r2^2);
    xcL(a)=xc*fx+cx;%换到图像坐标,畸变图坐标
    ycL(a)=yc*fy+cy;
end 
%后
load 后路calibrationSession.mat
fx=calibrationSession.CameraParameters.IntrinsicMatrix(1,1);
fy=calibrationSession.CameraParameters.IntrinsicMatrix(2,2);
cx=calibrationSession.CameraParameters.IntrinsicMatrix(3,1);
cy=calibrationSession.CameraParameters.IntrinsicMatrix(3,2);
k1=calibrationSession.CameraParameters.RadialDistortion(1);
k2=calibrationSession.CameraParameters.RadialDistortion(2);
c=[1633 1633-t 1069 1069 1633-t 1633];
r=[1411 1411 847+t 565-t 1 1];
BWB=roipoly(Q,c,r);
[yB,xB]=find(BWB==1);%第一个数是行坐标，第二个是列坐标
aBmax=length(xB);
TYB=inv(TFromB.T')*inv(TB.T');%注意顺序，注意matlab里矩阵和算法里是转置的
for a=1:aBmax
    pix=TYB*[xB(a);yB(a);1];%由全景图变换到透视图坐标
    pix=pix/pix(3);
    %变换到畸变图
    x=(pix(1)-cx)/fx;%换成物理坐标
    y=(pix(2)-cy)/fy;
    r2=x^2+y^2;
    xc=x*(1+k1*r2+k2*r2^2);
    yc=y*(1+k1*r2+k2*r2^2);
    xcB(a)=xc*fx+cx;%换到图像坐标,畸变图坐标
    ycB(a)=yc*fy+cy;
end 
%右
load 右路calibrationSession.mat
fx=calibrationSession.CameraParameters.IntrinsicMatrix(1,1);
fy=calibrationSession.CameraParameters.IntrinsicMatrix(2,2);
cx=calibrationSession.CameraParameters.IntrinsicMatrix(3,1);
cy=calibrationSession.CameraParameters.IntrinsicMatrix(3,2);
k1=calibrationSession.CameraParameters.RadialDistortion(1);
k2=calibrationSession.CameraParameters.RadialDistortion(2);
c=[1633 1633 1069+t 565-t 1 1];
r=[1 1+t 565 565 1+t 1];
BWR=roipoly(Q,c,r);
[yR,xR]=find(BWR==1);%第一个数是行坐标，第二个是列坐标
aRmax=length(xR);
TYR=inv(TFromR.T')*inv(TR.T');%注意顺序，注意matlab里矩阵和算法里是转置的
for a=1:aRmax
    pix=TYR*[xR(a);yR(a);1];%由全景图变换到透视图坐标
    pix=pix/pix(3);
    %变换到畸变图
    x=(pix(1)-cx)/fx;%换成物理坐标
    y=(pix(2)-cy)/fy;
    r2=x^2+y^2;
    xc=x*(1+k1*r2+k2*r2^2);
    yc=y*(1+k1*r2+k2*r2^2);
    xcR(a)=xc*fx+cx;%换到图像坐标,畸变图坐标
    ycR(a)=yc*fy+cy;
end 

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
xcF=round(xcF);xcB=round(xcB);xcL=round(xcL);xcR=round(xcR);
ycF=round(ycF);ycB=round(ycB);ycL=round(ycL);ycR=round(ycR);
ZF=vFM*ZF;ZB=vBM*ZB;ZR=vRM*ZR;ZL=vLM*ZL;
save zqyingshe.mat xF xB xL xR yF yB yL yR xcF xcB xcL xcR ycF ycB ycL ycR ZF ZB ZR ZL%保存映射表