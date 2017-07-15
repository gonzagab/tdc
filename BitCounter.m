filename='tdl.txt';
fileid = fopen(filename,'rt');
C = textscan(fileid,'%s');
fclose(fileid);
numOfRows = 8000;          %6220;


%320


%celldisp(C)
len = cellfun('length',C);
y = zeros(len,1);
maxTime = 0;
minTime = 0;
for x = 1:len
 count=sum(C{1}{x}=='1');
 if(count==320)
     fprintf('ANSWER== %i\n', x)
     maxTime = x;
 end
 if(count==1)
     fprintf('ANSWER== %i\n', x)
     minTime = x;
 end
 y(x,1)=count;
end
 fprintf('MaxTime: %i\n', maxTime);
 fprintf('MinTime: %i\n', minTime);

x = linspace(1,numOfRows,numOfRows);
x1 = linspace(0,numOfRows);

figure
plot(x,y)
p = polyfit(x,y',1)
y1 = polyval(p,x1);
hold on
plot(x1,y1,'--r')
slope = p(1)
clear C



