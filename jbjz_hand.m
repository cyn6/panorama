clear all;clc
%左路
fx=890.168122787187;
fy=891.076349672441;
cx=941.263820852075;
cy=506.563011145304;
k1=-0.311875642506090;k2=0.0962765096361836;
p1=0;p2=0;
I=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左原.jpg');
[m,n,p]=size(I);
for u=1:n
    for v=1:m
        x=(u-cx)/fx;%归一化，得到物理坐标
        y=(v-cy)/fy;
   
        r2=x^2+y^2;
        xc=x*(1+k1*r2+k2*r2^2);
        yc=y*(1+k1*r2+k2*r2^2);
        
        xc=xc*fx+cx;%去归一化，换到图像坐标
        yc=yc*fy+cy;
        if (xc>=0&&yc>=0&&xc<n&&yc<m) % 防止行列越界
           %J(round(yc),round(xc),:) =I(yy,xx,:); % 通过round函数取最近的数字
      J(v,u,:) =I(round(yc),round(xc),:);%不能反
        end
    end
end
   imshow(J);  
   %imwrite(J,'C:\Users\Yanan\Desktop\毕业设计\四路照片\左\手动畸正.jpg');