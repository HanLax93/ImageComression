%% °´Z×ÖÐÎ±àÂë
function [B]=zigzag(A)
sizeA=size(A);
B=zeros(sizeA(1),sizeA(2));
i=1;
j=1;
B(i,j)=A(i,j);
i=i+1;
index=0;
tag=1;
while (i+j)<=(sizeA(1)+sizeA(2))&&i<=sizeA(1)&&j<=sizeA(2)
if i==sizeA(1)&&j==sizeA(2)
 index=index+1;
B(fix(index/sizeA(2))+1,mod(index,sizeA(2))+1)=A(i,j);
 break;
end
 if tag==1
 while i<=sizeA(1)&&j<=sizeA(2)&&i>=1&&j>=1
 index=index+1;
 B(fix(index/sizeA(2))+1,mod(index,sizeA(2))+1)=A(i,j);
 i=i-1;
 j=j+1;
 end
 i=i+1;
j=j-1;
if j<sizeA(2)
 j=j+1;
 else
 i=i+1;
 end
tag=0;
 else if tag==0
while i<=sizeA(1)&&j<=sizeA(2)&&i>=1&&j>=1
 index=index+1;
 B(fix(index/sizeA(2))+1,mod(index,sizeA(2))+1)=A(i,j);
 i=i+1;
j=j-1;
end
 i=i-1;
j=j+1;
 if i<sizeA(1)
 i=i+1;
 else
j=j+1;
 end
tag=1;
 end
end
end
end

