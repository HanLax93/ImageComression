%% 实验初始化
close all;clc;
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp'},'File Selector','Select an Image');
if filename == 0
else
name = filename(1:end-4);
Im=imread([pathname,filename]);%读入图像
load('Table.mat','zigzag');
load('Table.mat','Ytable');%标准亮度量化表
load('Table.mat','Ctable');%标准色差量化表

%% 将RGB图像转换为YCbCr图像并分解成Y、Cb、Cr三个部分（亮度，色差）
ycbcr=rgb2ycbcr(Im);
y=ycbcr(:,:,1);
% figure(1);imshow(y);
cb=ycbcr(:,:,2);
% figure(2);imshow(cb);
cr=ycbcr(:,:,3);
% figure(3);imshow(cr);

%% 调用子函数生成压缩编码并存储压缩图像
[Q,Code_length1]=GerComCode(y,1);
Q=round(blkproc(Q,[8 8],'x.*P1',Ytable));%反量化
y=blkproc(Q,[8  8],'idct2');%DCT反变换

[Q,Code_length2]=GerComCode(cb,2);
Q=round(blkproc(Q,[8 8],'x.*P1',Ctable));
cb=blkproc(Q,[8  8],'idct2');

[Q,Code_length3]=GerComCode(cr,3);
Q=round(blkproc(Q,[8 8],'x.*P1',Ctable));
cr=blkproc(Q,[8  8],'idct2');

%% 生成压缩后图像
ycbcr(:,:,:)=cat(3,y,cb,cr);
y=ycbcr(:,:,1);
rgb2=ycbcr2rgb(ycbcr);
imwrite(rgb2,[pathname,[filename,'_compressed.jpg']]);
end
