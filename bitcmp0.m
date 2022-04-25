function numcmp=bitcmp0(num)
%将内容为0和1的数组的值按位取反
% num为输入的数组 numcmp为输出的数组
l=length(num);
for i=1:l
    if num(i)==1
        numcmp(i)=0;
    else
        numcmp(i)=1;
    end
end