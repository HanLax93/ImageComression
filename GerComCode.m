function [Q,code_length]=GerComCode(I,hint)
%生成压缩编码并存储在对应的文本文档中，以供查看
% 调用生成亮度或色差压缩编码并存储
% I为输入的亮度或色差数组，以hint值做判断
% 当hint=1时，表示输入的是亮度Y数组
% 当hint=2时，表示输入的是色差Cb数组
% 当hint=3时，表示输入的是色差Cr数组

if hint==1
    fid=fopen('D:\MATLAB\Compression_byHB\Code_Y.txt','a');
elseif hint==2
    fid=fopen('D:\MATLAB\Compression_byHB\Code_Cb.txt','a');
else
    fid=fopen('D:\MATLAB\Compression_byHB\Code_Cr.txt','a');
end

%% zigzag排序表、量化表
load('Table.mat','zigzag');
load('Table.mat','Ytable');%标准亮度量化表
load('Table.mat','Ctable');%标准色差量化表

%% 8x8 DCT
DCT=blkproc(I,[8  8],'dct2');
    
%% 量化
if hint==1
    Q=round(blkproc(DCT,[8 8],'x./P1',Ytable));
elseif hint==2
    Q=round(blkproc(DCT,[8 8],'x./P1',Ctable));
else
    Q=round(blkproc(DCT,[8 8],'x./P1',Ctable));
end

%% 分块处理
[H,L]=size(I);%获取图像高和长
%将图像分成8*8的块
num=0;
for h=1:H/8
    for l=1:L/8
        num=num+1;
        block88(:,:,num)=Q(((h-1)*8+1):((h-1)*8+8),...
        ((l-1)*8+1):((l-1)*8+8)); 
    end
end

%% 编码部分
code_length=0;
for i=1:num
    blockbit_seq=[];AC_seq=[];
    m=block88(:,:,i);
    m=m';m=m(:);m=m';%将8*8块转换成一维数组
    for j=1:64
        z(j)=m(zigzag(j));%将8*8块进行zigzag排序
    end       
    %找出最后一位不为0的zigzag矩阵的下标
    index=0;
    sum=64;
    while sum ~= 0
         if z(sum) ~= 0
            index=sum;
            break;
         else
             sum=sum-1;
         end
    end
    %index为最后一个不为0的系数的下标，e为zigzag扫描结果t去掉末尾的0后得到的一维行向量
    if index==0
        index=1;
    end
    for k=1:index
           e(k)=z(k);
    end
    %对DC系数进行Huffman编码
    DC_seq=DCEncoding(e(1));
    eob=dec2bin(10,4);%EOB编码值
    eob=str2num0(eob);
    zerolen=0;zeronum=0;
    if numel(e)==1
        blockbit_seq=[DC_seq,eob];
    else
        for g=2:index
            if e(g)==0 && zeronum<16
                zeronum=zeronum+1;
            elseif e(g)==0 && zeronum==16
                bit_seq=dec2bin(2041,11);
                zeronum=1;
                AC_seq=[AC_seq,bit_seq];
            elseif e(g)~=0 && zeronum==16
                zrl_seq=dec2bin(2041,11);
                amp=e(g);
                trt_seq=ACEncoding(0,amp);
                bit_seq=[zrl_seq,trt_seq];
                AC_seq=[AC_seq,bit_seq];
            elseif e(g)~=0 && zeronum<16
                zerolen=zeronum;
                amp=e(g);
                zeronum=0;
                bit_seq=ACEncoding(zerolen,amp);
                AC_seq=[AC_seq,bit_seq];
            end
        end
        blockbit_seq=[DC_seq,AC_seq,eob];
    end
    Image_seq=num2str0(blockbit_seq);
    code_length=code_length+length(Image_seq);
    fprintf(fid,'%s',Image_seq);
end
fclose(fid);