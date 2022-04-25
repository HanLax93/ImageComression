function [Q,code_length]=GerComCode(I,hint)
%����ѹ�����벢�洢�ڶ�Ӧ���ı��ĵ��У��Թ��鿴
% �����������Ȼ�ɫ��ѹ�����벢�洢
% IΪ��������Ȼ�ɫ�����飬��hintֵ���ж�
% ��hint=1ʱ����ʾ�����������Y����
% ��hint=2ʱ����ʾ�������ɫ��Cb����
% ��hint=3ʱ����ʾ�������ɫ��Cr����

if hint==1
    fid=fopen('D:\MATLAB\Compression_byHB\Code_Y.txt','a');
elseif hint==2
    fid=fopen('D:\MATLAB\Compression_byHB\Code_Cb.txt','a');
else
    fid=fopen('D:\MATLAB\Compression_byHB\Code_Cr.txt','a');
end

%% zigzag�����������
load('Table.mat','zigzag');
load('Table.mat','Ytable');%��׼����������
load('Table.mat','Ctable');%��׼ɫ��������

%% 8x8 DCT
DCT=blkproc(I,[8  8],'dct2');
    
%% ����
if hint==1
    Q=round(blkproc(DCT,[8 8],'x./P1',Ytable));
elseif hint==2
    Q=round(blkproc(DCT,[8 8],'x./P1',Ctable));
else
    Q=round(blkproc(DCT,[8 8],'x./P1',Ctable));
end

%% �ֿ鴦��
[H,L]=size(I);%��ȡͼ��ߺͳ�
%��ͼ��ֳ�8*8�Ŀ�
num=0;
for h=1:H/8
    for l=1:L/8
        num=num+1;
        block88(:,:,num)=Q(((h-1)*8+1):((h-1)*8+8),...
        ((l-1)*8+1):((l-1)*8+8)); 
    end
end

%% ���벿��
code_length=0;
for i=1:num
    blockbit_seq=[];AC_seq=[];
    m=block88(:,:,i);
    m=m';m=m(:);m=m';%��8*8��ת����һά����
    for j=1:64
        z(j)=m(zigzag(j));%��8*8�����zigzag����
    end       
    %�ҳ����һλ��Ϊ0��zigzag������±�
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
    %indexΪ���һ����Ϊ0��ϵ�����±꣬eΪzigzagɨ����tȥ��ĩβ��0��õ���һά������
    if index==0
        index=1;
    end
    for k=1:index
           e(k)=z(k);
    end
    %��DCϵ������Huffman����
    DC_seq=DCEncoding(e(1));
    eob=dec2bin(10,4);%EOB����ֵ
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