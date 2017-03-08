%% Histology Image Analysis - Data Update
% Jonathan Macoskey, University of Michigan
% Image-Guided Ultrasound Therapy Laboratory
%
% Purpose: load data structure and update with new information
%
% Created: 1/30/17
%
% Inputs:
% Svec           Vector of sample index numbers, e.g,. [2 4 6 8 10]
% collagenBW     Stack of BW masks for collagen segmentation for Svec samples
% collagenBW     RGB version of collagenBW
% reticulumBW    Reticulum version of collagenBW
% reticculumRGB  RGB version of reticulumBW
%
% Outputs:
% response       confirmation that things worked
function response = histoDataUpdate(Svec,collagenBW,collagenRGB,reticulumBW,reticulumRGB)
    load([pwd,'\DopBck_Study_Data.mat'])
    ns = length(Svec);
    pix = (0.253)^2; % 0.253 microns per pixel (length)
    for i = 1:ns
        s = Svec(i);
        eval(sprintf('data.S%.2d.collagenBW = collagenBW(:,:,%.1d);',s,i))
        eval(sprintf('data.S%.2d.collagenRGB = collagenRGB(:,:,%.1d);',s,i))
        
        colCount    = sum(sum(collagenBW(:,:,i)));
        colPercent  = colCount/(1024^2);
        colArea     = colCount.*pix;
        eval(sprintf('data.S%.2d.collagenCount = colCount;',s))
        eval(sprintf('data.S%.2d.collagenPercent = colPercent;',s))
        eval(sprintf('data.S%.2d.collagenArea = colArea;',s))
        
        eval(sprintf('data.S%.2d.reticulumBW = reticulumBW(:,:,%.1d);',s,i))
        eval(sprintf('data.S%.2d.reticulumRGB = reticulumRGB(:,:,%.1d);',s,i))
        
        retCount    = sum(sum(reticulumBW(:,:,i)));
        retPercent  = retCount/(1024^2);
        retArea     = retCount.*pix;
        eval(sprintf('data.S%.2d.reticulumCount = retCount;',s))
        eval(sprintf('data.S%.2d.reticulumPercent = retPercent;',s))
        eval(sprintf('data.S%.2d.reticulumArea = retArea;',s))
        response = i;
    end
    save([data.dataPathHome,'\DopBck_Study_Data.mat'],'data')
    save([data.dataPathBackup,'\DopBck_Study_Data.mat'],'data')
    disp('Data saved and backed-up')
end