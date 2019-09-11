function [data,label,units] = LTspiceBodeSimulationLoader( filename )
tempdata = importdata(filename,' ');
label = char(strsplit(strjoin(tempdata(1))));
samples = (length(tempdata)-1);
data = zeros(3,samples);
%Get units
un1 = textscan(strjoin(tempdata(2))','%*f	(%*f%[^,]s',1);
temp = strjoin({'%*f	(%*f' char(un1{1}) ',%*f%[^)]s'},'');
un2 = textscan(strjoin(tempdata(2))',temp,1);
scantemplate = strjoin({'%f	(%f' char(un1{1}) ',%f' char(un2{1}) ')'},'');
units = char({char(un1{1}) char(un2{1})});
data(:,:) = cell2mat(textscan(strjoin(tempdata(2:end))',scantemplate,samples))';
end