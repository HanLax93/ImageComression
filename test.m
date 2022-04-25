close all;clc;
Im=imread('Ord.png');%读入图像
load('Table.mat','zigzag');
load('Table.mat','Ytable');%标准亮度量化表
load('Table.mat','Ctable');%标准色差量化表

%% 将RoIGoIBoI图像分为3个部分，并转化为YC亮度色差图像
RoI=Im(:,:,1);
GoI=Im(:,:,2);
BoI=Im(:,:,3);

%% 转化为YC亮度色差图像
y = 0.299 * RoI + 0.587 * GoI + 0.114 * BoI ;
cb = -0.1687 * RoI - 0.3313 * GoI + 0.5 * BoI ;
cr = 0.5 * RoI - 0.4187 * GoI - 0.0813 * BoI;

%%
[Q,Code_length1]=GerComCode(y,1);
Q=round(blkproc(Q,[8 8],'x.*P1',Ytable));
y=blkproc(Q,[8  8],'idct2');

[Q,Code_length2]=GerComCode(cb,2);
Q=round(blkproc(Q,[8 8],'x.*P1',Ctable));
cb=blkproc(Q,[8  8],'idct2');

[Q,Code_length3]=GerComCode(cr,3);
Q=round(blkproc(Q,[8 8],'x.*P1',Ctable));
cr=blkproc(Q,[8  8],'idct2');

ycbcr(:,:,:)=cat(3,y,cb,cr);
y=ycbcr(:,:,1);
rgb2=ycbcr2rgb(ycbcr);
imwrite(rgb2,'D:\MATLAB\Compression_byHB\Ord_compressed.jpg');