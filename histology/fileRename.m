% J. Macoskey, UofM, I-GUTL
% 1/27/17
%%
path = 'E:\Research\Studies\Histology\DopBck_Study\Liver_121516\MT\S14_TRI\';
fileList = dir([path,'\Ss*.jpg']);
for n = 1:length(fileList)
   disp(num2str(n))
   I = imread([path,'\',fileList(n).name]);
   formatSpec = ['save ',path,'\',sprintf('Da%.1d.jpg',n),' I'];
   eval(formatSpec)
end