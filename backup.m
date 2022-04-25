close all;clc;
Im=imread('Ord.png');%����ͼ��
load('Table.mat','zigzag');
load('Table.mat','Ytable');%��׼����������
load('Table.mat','Ctable');%��׼ɫ��������

%% ��RGBͼ��ת��ΪYCbCrͼ�񲢷ֽ��Y��Cb��Cr�������֣����ȣ�ɫ�
ycbcr=rgb2ycbcr(Im);
y1=ycbcr(:,:,1);
cb=ycbcr(:,:,2);
cr=ycbcr(:,:,3);

%% �����Ӻ�������ѹ�����벢�洢ѹ��ͼ��
[Q,Code_length1]=GerComCode(y,1);
Q=round(blkproc(Q,[8 8],'x.*P1',Ytable));
y=blkproc(Q,[8  8],'idct2');

[Q,Code_length2]=GerComCode(cb,2);
Q=round(blkproc(Q,[8 8],'x.*P1',Ctable));
cb=blkproc(Q,[8  8],'idct2');

[Q,Code_length3]=GerComCode(cr,3);
Q=round(blkproc(Q,[8 8],'x.*P1',Ctable));
cr=blkproc(Q,[8  8],'idct2');

%����ѹ����ͼ��
ycbcr(:,:,:)=cat(3,y,cb,cr);
y=ycbcr(:,:,1);
rgb2=ycbcr2rgb(ycbcr);
imwrite(rgb2,'D:\MATLAB\Compression_byHB\Ord_compressed.jpg');