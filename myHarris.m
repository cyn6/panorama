%Harris角点提取算法                                        
clear all;
close all;
clc;

I='C:\Users\Yanan\Desktop\毕业设计\四路照片\前\前俯视.jpg';
X = imread(I);     %读取图像
Info = imfinfo(I); %获取图像相关信息
if (Info.BitDepth > 8)
    f = rgb2gray(X);  %转化为灰度图像
end

ori_im = double(f) / 255;          %unit8转化为64位双精度double64，并作归一化处理
%fx = [5 0 -5;8 0 -8;5 0 -5];         % x方向高斯卷积核(高斯尺度空间的多尺度优化)(用于改进的Harris角点提取算法)
fx = [-2 -1 0 1 2];                 % 高斯函数一阶微分，x方向梯度算子(用于Harris角点提取算法)
Ix = filter2(fx, ori_im);           % x方向滤波
%fy = [5 8 5;0 0 0;-5 -8 -5];         % 高斯函数一阶微分，y方向(用于改进的Harris角点提取算法)
fy = [-2; -1; 0; 1; 2];             % 高斯函数一阶微分，y方向梯度算子(用于Harris角点提取算法)
Iy = filter2(fy, ori_im);           % y方向滤波
%构造自相关矩阵
Ix2 = Ix .^ 2;
Iy2 = Iy .^ 2;
Ixy = Ix .* Iy;
clear Ix;
clear Iy;
h= fspecial('gaussian', [7 7], 2);        % 用fspecial函数建立滤波算子
%产生7*7的高斯窗函数，sigma为滤波器的标准值，单位为像素，默认值为0.5，此处定义为2
Ix2 = filter2(h,Ix2);  %filter2是用h滤波函数放在Ix2移动进行模板滤波
Iy2 = filter2(h,Iy2);  %消除y方向上的突兀点
Ixy = filter2(h,Ixy);
%提取特征点
height = size(ori_im, 1);%返回图像矩阵的行数给高
width = size(ori_im, 2);%返回图像的列数给宽
result = zeros(height, width);  % 用zeros矩阵纪录角点位置，角点处值为1
R = zeros(height, width);  %创建与图像矩阵大小相同的零矩阵
Rmax = 0;                  % 图像中最大的R值
k = 0.06;            %k为常系数，经验取值范围为0.04~0.06
for i = 1 : height
    for j = 1 : width
        M = [Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];             % 自相关矩阵
        R(i,j) = det(M) - k * (trace(M)) ^ 2;                     % 计算R
        if R(i,j) > Rmax
            Rmax = R(i, j);
        end
    end
end
T = 0.01 * Rmax;%固定阈值，当R(i, j) > T时，则被判定为候选角点

%在计算完各点的值后，进行局部非极大值抑制
cnt = 0; %角点个数
for i = 2 : height-1
    for j = 2 : width-1   % 进行非极大抑制，窗口大小3*3
        if (R(i, j) > T && R(i, j) > R(i-1, j-1) && R(i, j) > R(i-1, j) && R(i, j) > R(i-1, j+1) && R(i, j) > R(i, j-1) && ...
                R(i, j) > R(i, j+1) && R(i, j) > R(i+1, j-1) && R(i, j) > R(i+1, j) && R(i, j) > R(i+1, j+1))
            result(i, j) = 1;
            cnt = cnt+1;
        end
    end
end

%%%%%另一个方法非极大抑制%%%%%%%%%
%corner_peaks=imregionalmax(R);
%imregionalmax对二维图片，采用8领域（默认，也可指定）查找极值，三维图片采用26领域
%极值置为1，其余置为0
%num=sum(sum(corner_peaks));

%i = 1;
%   for j = 1 : height
%        for k = 1 : width
 %           if result(j, k) == 1
 %               corners1(i, 1) = j;
  %              corners1(i, 2) = k;
  %              i = i + 1;
  %          end
  %      end
 %   end
 
[posc, posr] = find(result == 1);  %确定角点位置，
K1=filter2(fspecial('average',3),[posc, posr])/255;%领域平均法消除噪声
figure,imshow(ori_im);
hold on;
plot(posr, posc, '.r');
%n=size(posc);   %也可这样求角点个数
%A={1:n};
%text(posr+0.001,posc-0.01,A);     %然后用写程序对红色的点进行标记编号