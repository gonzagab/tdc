%# read the whole file to a temporary cell array
filename = 'tdc25nsPulseRe_rslt_txt.txt';
fileid = fopen(filename,'rt');
C = textscan(fileid,'%s');
fclose(fileid);
 
%celldisp(C)
len = cellfun('length',C);
eightBitNums = zeros((len/2), 1);
twentyBitNums = zeros((len/2), 1);
timeArray = zeros((len/2), 1);
lineArray = zeros((len/2), 1);
index8 = 1;
index20 = 1;

for x =  1 : 7000
    timeArray(x, 1) = 7001 - x;
    lineArray(x, 1) = 25000;
end

for x = 1 : len
    k = strfind(C{1}{x}, 'X');
    j = strfind(C{1}{x}, 'U');
    %if (mod(x, 2) ~= 0)
        if (isempty(k) && isempty(j))
            %convert eight bit number to decimal
            decNum = bin2dec(C{1}{x});
            eightBitNums(index8, 1) = decNum/100;
        else
            eightBitNums(index8, 1) = 25000;
        end;
        index8 = index8 + 1;
    %else
%         if (isempty(k) && isempty(j))
%             %convert twenty bit number to decimal
%             decNum = bin2dec(C{1}{x});
%             twentyBitNums(index20, 1) = decNum;
%         else
%             twentyBitNums(index20, 1) = 0;
%         end;
%         index20 = index20 + 1;
    %end
end
 
%plot(eightBitNums, twentyBitNums);
figure;
plot(timeArray, eightBitNums);
hold;
plot(timeArray, lineArray, '+');

% p = polyfit(eightBitNums, twentyBitNums, 1);
% slope = p(1);
