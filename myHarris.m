%Harris�ǵ���ȡ�㷨                                        
clear all;
close all;
clc;

I='C:\Users\Yanan\Desktop\��ҵ���\��·��Ƭ\ǰ\ǰ����.jpg';
X = imread(I);     %��ȡͼ��
Info = imfinfo(I); %��ȡͼ�������Ϣ
if (Info.BitDepth > 8)
    f = rgb2gray(X);  %ת��Ϊ�Ҷ�ͼ��
end

ori_im = double(f) / 255;          %unit8ת��Ϊ64λ˫����double64��������һ������
%fx = [5 0 -5;8 0 -8;5 0 -5];         % x�����˹�����(��˹�߶ȿռ�Ķ�߶��Ż�)(���ڸĽ���Harris�ǵ���ȡ�㷨)
fx = [-2 -1 0 1 2];                 % ��˹����һ��΢�֣�x�����ݶ�����(����Harris�ǵ���ȡ�㷨)
Ix = filter2(fx, ori_im);           % x�����˲�
%fy = [5 8 5;0 0 0;-5 -8 -5];         % ��˹����һ��΢�֣�y����(���ڸĽ���Harris�ǵ���ȡ�㷨)
fy = [-2; -1; 0; 1; 2];             % ��˹����һ��΢�֣�y�����ݶ�����(����Harris�ǵ���ȡ�㷨)
Iy = filter2(fy, ori_im);           % y�����˲�
%��������ؾ���
Ix2 = Ix .^ 2;
Iy2 = Iy .^ 2;
Ixy = Ix .* Iy;
clear Ix;
clear Iy;
h= fspecial('gaussian', [7 7], 2);        % ��fspecial���������˲�����
%����7*7�ĸ�˹��������sigmaΪ�˲����ı�׼ֵ����λΪ���أ�Ĭ��ֵΪ0.5���˴�����Ϊ2
Ix2 = filter2(h,Ix2);  %filter2����h�˲���������Ix2�ƶ�����ģ���˲�
Iy2 = filter2(h,Iy2);  %����y�����ϵ�ͻأ��
Ixy = filter2(h,Ixy);
%��ȡ������
height = size(ori_im, 1);%����ͼ��������������
width = size(ori_im, 2);%����ͼ�����������
result = zeros(height, width);  % ��zeros�����¼�ǵ�λ�ã��ǵ㴦ֵΪ1
R = zeros(height, width);  %������ͼ������С��ͬ�������
Rmax = 0;                  % ͼ��������Rֵ
k = 0.06;            %kΪ��ϵ��������ȡֵ��ΧΪ0.04~0.06
for i = 1 : height
    for j = 1 : width
        M = [Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];             % ����ؾ���
        R(i,j) = det(M) - k * (trace(M)) ^ 2;                     % ����R
        if R(i,j) > Rmax
            Rmax = R(i, j);
        end
    end
end
T = 0.01 * Rmax;%�̶���ֵ����R(i, j) > Tʱ�����ж�Ϊ��ѡ�ǵ�

%�ڼ���������ֵ�󣬽��оֲ��Ǽ���ֵ����
cnt = 0; %�ǵ����
for i = 2 : height-1
    for j = 2 : width-1   % ���зǼ������ƣ����ڴ�С3*3
        if (R(i, j) > T && R(i, j) > R(i-1, j-1) && R(i, j) > R(i-1, j) && R(i, j) > R(i-1, j+1) && R(i, j) > R(i, j-1) && ...
                R(i, j) > R(i, j+1) && R(i, j) > R(i+1, j-1) && R(i, j) > R(i+1, j) && R(i, j) > R(i+1, j+1))
            result(i, j) = 1;
            cnt = cnt+1;
        end
    end
end

%%%%%��һ�������Ǽ�������%%%%%%%%%
%corner_peaks=imregionalmax(R);
%imregionalmax�Զ�άͼƬ������8����Ĭ�ϣ�Ҳ��ָ�������Ҽ�ֵ����άͼƬ����26����
%��ֵ��Ϊ1��������Ϊ0
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
 
[posc, posr] = find(result == 1);  %ȷ���ǵ�λ�ã�
K1=filter2(fspecial('average',3),[posc, posr])/255;%����ƽ������������
figure,imshow(ori_im);
hold on;
plot(posr, posc, '.r');
%n=size(posc);   %Ҳ��������ǵ����
%A={1:n};
%text(posr+0.001,posc-0.01,A);     %Ȼ����д����Ժ�ɫ�ĵ���б�Ǳ��