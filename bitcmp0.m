function numcmp=bitcmp0(num)
%������Ϊ0��1�������ֵ��λȡ��
% numΪ��������� numcmpΪ���������
l=length(num);
for i=1:l
    if num(i)==1
        numcmp(i)=0;
    else
        numcmp(i)=1;
    end
end