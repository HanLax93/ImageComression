function [comp,dict]=Huff_Coding(Data)
% by Mohammed M. Siddeq 
% 10/2/2007
%%% this function is very simple :-
% for coding using this function, with the floowing parameters:
% "Data" contains negative or posative or char
%  output :\ "comp"  - > stream of bits....
%         :\ "dict"  - > dictionary used for decoding
% Example : - X=[12 200 12 0 -9 8 8 -8 8 0 0 0];
%              [comp,dict]=Huff_Coding(x);
%
%Example2\
% For Decoding using the function - > Data = huffmandeco(comp,dict);
% this function return exact original data
%
HEAD=0;
%%%%%%%%%%%%%%%%%%%%
%--Compute Header--------
POS=0; 
S_=size(Data);        
for i=1:S_(2)
    if (POS~=0)
      S=size(HEAD); F=0;
      k=1;
      while (F==0 && k<=S(2))
         if (Data(i)==HEAD(k))  F=1; end;
         k=k+1;
      end;
    else F=0; 
    end;
    if (F==0)
      POS=POS+1;
      HEAD(POS)=Data(i);
    end;
end;
%%%%%%%%Compute probability for symbols%%%%%%%%%%%%
S_H=size(HEAD);
Count(1:S_H(2))=0;
for i=1:S_H(2)
    for j=1:S_(2)
        if (Data(j)==HEAD(i))
            Count(i)=Count(i)+1;
        end;
    end;
end;
Count=Count./S_(2);
%%% Sort accoridng to maximum number%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:S_H(2)-1
    for j=i+1:S_H(2)
        if (Count(j)>Count(i))
            T1=Count(i); Count(i)=Count(j); Count(j)=T1;
            T1=HEAD(i); HEAD(i)=HEAD(j); HEAD(j)=T1;
        end;
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[dict,avglen] = huffmandict(HEAD,Count); % Create dictionary.

comp = huffmanenco(Data,dict); % Encode the data.


end