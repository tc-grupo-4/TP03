function [data,label,units] = LTspiceBodeMontecarloLoader( filename )
tempdata = importdata(filename,' ');
label = char(strsplit(strjoin(tempdata(1))));
temp = strjoin(tempdata(2));
temp = temp(strfind(strjoin(tempdata(2)),'/')+1:length(temp)-1);
total_runs = str2double(temp);
total_lines = length(tempdata);
samples_per_run = (total_lines-1)/total_runs-1;
data = zeros(total_runs,3,samples_per_run);
%Get units
un1 = textscan(strjoin(tempdata(3))','%*f	(%*f%[^,]s',1);
temp = strjoin({'%*f	(%*f' char(un1{1}) ',%*f%[^)]s'},'');
un2 = textscan(strjoin(tempdata(3))',temp,1);
scantemplate = strjoin({'%f	(%f' char(un1{1}) ',%f' char(un2{1}) ')'},'');
units = char({char(un1{1}) char(un2{1})});
for i=1:total_runs
    data(i,:,:) = cell2mat(textscan(strjoin(tempdata((2+(samples_per_run+1)*(i-1)+1):(2+(samples_per_run+1)*(i)-1)))',scantemplate,samples_per_run))';
end
end