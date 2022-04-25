function str=num2str0(num)
%将一维数组按顺序转换为字符串
% num为输入的数组，str为输出的字符串
str=num2str(num(:))';