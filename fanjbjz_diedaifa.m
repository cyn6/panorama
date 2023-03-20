clear all;clc
%左路
fx=890.168122787187;
fy=891.076349672441;
cx=941.263820852075;
cy=506.563011145304;
k1=-0.311875642506090;k2=0.0962765096361836;
p1=0;p2=0;%忽略
I=imread('C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左畸正.jpg');
[m,n,p]=size(I);
J=zeros(m,n,p);
for xx=1:n%畸变图坐标
    for yy=1:m
        xc=(xx-cx)/fx;%换成物理坐标
        yc=(yy-cy)/fy;
        x0=xc;y0=yc;
        x=xc;y=yc;
        for j=1:30%迭代30次
        r2=x^2+y^2;
        x=x0-k1*x*r2-k2*x*r2^2;%减法减法函数迭代得到的值收敛！
        y=y0-k1*y*r2-k2*y*r2^2;
        end
        x=x*fx+cx;%换到图像坐标
        y=y*fy+cy;
         if xc<1||yc<1||xc>n||yc>m
            continue;
        end
        %if (x>=1&&y>=1&&x<n&&y<m) % 防止行列越界，此为最临近插值
        %  J(yy,xx,:) =I(round(y),round(x),:); %通过round函数取最近的数字
       %双线性插值,不行
       a=fix(x);b=fix(y);
       k1=abs(x-a);k2=abs(y-b);
       for i=1:3
       J(yy,xx,i)=I(b,a,i)*(1-k2)*(1-k1)...
       +I(b,a+1,i)*k1*(1-k2)...
       +I(b+1,a,i)*(1-k1)*k2...
       +I(b+1,a+1,i)*k1*k2;
       end
    end
end
   J=uint8(J);
   imshow(J);
   %imwrite(J,'C:\Users\Yanan\Desktop\毕业设计\四路照片\左\左原—迭代逆解.jpg');%迭代逆解得到