function num=str2num0(str)
%将字符串按顺序转化为一维数组
% num为输出的数组，str为入的字符串
num=str2num(str(:))';