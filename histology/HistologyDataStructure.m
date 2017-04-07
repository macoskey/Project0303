%% Histology Image Analysis - Data Structure
% Jonathan Macoskey, University of Michigan
% Image-Guided Ultrasound Therapy Laboratory
%
% Purpose: make data structure for storing statistics and all other useful
% information from the histology feedback papers
%
% Created: 1/30/17


clear

data.dataPathHome = pwd;
data.dataPathBackup = uigetdir();

for n = 1:7*6 % 7 doses x 6 samples per dose
   eval(sprintf('data.S%.2d.collagenBW = '''';',n))
   eval(sprintf('data.S%.2d.collagenRGB = '''';',n))
   eval(sprintf('data.S%.2d.collagenCount = '''';',n))
   eval(sprintf('data.S%.2d.collagenPercent = '''';',n))
   eval(sprintf('data.S%.2d.collagenArea = '''';',n))
   
   eval(sprintf('data.S%.2d.reticulumBW = '''';',n))
   eval(sprintf('data.S%.2d.reticulumRGB = '''';',n))
   eval(sprintf('data.S%.2d.reticulumCount = '''';',n))
   eval(sprintf('data.S%.2d.reticulumPercent = '''';',n))
   eval(sprintf('data.S%.2d.reticulumArea = '''';',n))
end

save([data.dataPathHome,'\DopBck_Study_Data.mat'],'data')
save([data.dataPathBackup,'\DopBck_Study_Data.mat'],'data')