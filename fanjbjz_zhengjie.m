clear all;clc
%左路
fx=890.168122787187;
fy=891.076349672441;
cx=941.263820852075;
cy=506.563011145304;
k1=-0.311875642506090;k2=0.0962765096361836;
p1=0;p2=0;
I=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左畸正.jpg');
imshow(I);
[m,n,p]=size(I);
J=zeros(m,n,p);
for xx=1:n%矫正后的坐标I
    for yy=1:m
        x=(xx-cx)/fx;%换成物理坐标
        y=(yy-cy)/fy;
   
        r2=x^2+y^2;
        xc=x*(1+k1*r2+k2*r2^2);
        yc=y*(1+k1*r2+k2*r2^2);
        
        xc=xc*fx+cx;%换到图像坐标。畸变图坐标
        yc=yc*fy+cy;
       
        if (xc>=1&&yc>=1&&xc<=n&&yc<=m) %此为最邻近插值
           J(round(yc),round(xc),:) =I(yy,xx,:); %通过round函数取最近的数字
        end
    end
end
   J=uint8(J);
   imshow(J);  
   %imwrite(J,'C:\Users\Yanan\Desktop\毕业设计\四路照片\左\反畸正.jpg');%正向求解，最后反坐标，较为简单但不能双线性插值,不用