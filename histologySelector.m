%% Histology Tile Selector Script
% Jonathan Macoskey, University of Michigan
% Image-Guided Ultrasound Therapy Laboratory
%
%
%
% Purpose: randomly pick X number of histology slides from all tiles
% extracted from Aperio large files. GUI allows user to select which tiles
% are good ones. This is NOT meant to enable statistical interference, this
% is meant to be used for making sure that no histological artifacts, e.g.,
% tissue tearing, get into the final analysis. GUI automatically makes a
% structure with the filenames of each tile chosen.
%
%
% Created: 1/25/17

function histologySelector(data)
clc; 
close all
num_tiles_needed = 10;
im_res = 0.253; % microns per pixel

%% Functional figure items
mainFig = figure('MenuBar','none',...
                 'Toolbar','none',...
                 'units','normalized',...
                 'outerposition',[1.2 0.1 0.52 0.8],...
                 'Color',[000/255 041/255 102/255],... % Michigan Blue: [000/255 041/255 102/255] 
                 ...                                   % Michigan Maize: [255/255 209/255 000/255]
                 'Visible','on');
             set(mainFig,'Name','Histology Tile Selector')

dir_btn = uicontrol(mainFig,... 
                     'Style','pushbutton',...
                     'String','Directory',...
                     'Units','Normalized',...
                     'Position',[0.05 0.08 0.07 0.07],...
                     'Callback',@dir_callback);
             
next_btn = uicontrol(mainFig,...
                     'Style','pushbutton',...
                     'String','Next',...
                     'Units','Normalized',...
                     'Position',[0.15 0.08 0.07 0.07],...
                     'Callback',@next_callback);

yes_btn = uicontrol(mainFig,...
                     'Style','pushbutton',...
                     'String','YES',...
                     'Units','Normalized',...
                     'Position',[0.25 0.08 0.07 0.07],...
                     'Callback',@yes_callback);
                 
fin_btn = uicontrol(mainFig,...
                     'Style','pushbutton',...
                     'String','Finish Sample',...
                     'Units','Normalized',...
                     'Position',[0.35 0.08 0.07 0.07],...
                     'Callback',@finish);

count_txt = uicontrol(mainFig,...
                     'Style','text',...
                     'FontSize',14,...
                     'String','Chosen: 0',...
                     'HorizontalAlignment','left',...
                     'Units','Normalized',...
                     'Position',[0.45 0.1 0.5 0.07]);
                 
path_txt = uicontrol(mainFig,...
                     'Style','text',...
                     'FontSize',14,...
                     'String','Path: ',...
                     'HorizontalAlignment','left',...
                     'Units','Normalized',...
                     'Position',[0.45 0.04 0.5 0.1]);
                 
count_text = uicontrol(mainFig,...
                     'Style','text',...
                     'FontSize',14,...
                     'BackgroundColor',[255/255 209/255 000/255],...
                     'String','Count: ',...
                     'HorizontalAlignment','center',...
                     'Units','Normalized',...
                     'Position',[0.86 0.6 0.1 0.1]);

count_num = uicontrol(mainFig,...
                     'Style','text',...
                     'FontSize',14,...
                     'BackgroundColor',[255/255 209/255 000/255],...
                     'String','0',...
                     'FontSize',20,...
                     'HorizontalAlignment','center',...
                     'Units','Normalized',...
                     'Position',[0.86 0.61 0.1 0.05]);

anno_btn = uicontrol(mainFig,...
                     'Style','pushbutton',...
                     'String','annotate',...
                     'Units','Normalized',...
                     'Position',[0.875 0.51 0.07 0.07],...
                     'Callback',@annotate); 

instr_text = uicontrol(mainFig,...
                     'Style','text',...
                     'FontSize',14,...
                     'ForegroundColor',[1 1 1],...
                     'BackgroundColor',[000/255 041/255 102/255],...
                     'String','press enter when done',...
                     'FontSize',14,...
                     'HorizontalAlignment','center',...
                     'Units','Normalized',...
                     'Position',[0.86 0.45 0.1 0.05]);
                 
display.handles = axes('Parent',mainFig,...
                       'units','pixels',...
                       'Xtick',[],...
                       'Ytick',[],...
                       'Box','on',...
                       'Position',[200 200 600 600]);

%% App data
    numChosen = '';
    setappdata(mainFig,'numChosen',numChosen);
    
    files.val = '';
    setappdata(mainFig,'files',files);
    
    path.val = '';
    setappdata(mainFig,'path',path);
    
    vector.val = '';
    setappdata(mainFig,'vector',vector);
    
    current_image.val = '';
    setappdata(mainFig,'curIm',current_image);
    
    fileName.val = '';
    setappdata(mainFig,'fileName',fileName);
    
    chosenList.val = '';
    setappdata(mainFig,'chosenList',chosenList);
    
    cellCount.val = '';
    setappdata(mainFig,'cellCount',cellCount);
    
%% Functions
% DIRECTORY BUTTON CALLBACK
    function dir_callback(~,~)
        path            = getappdata(mainFig,'path');
        files           = getappdata(mainFig,'files');
        vector          = getappdata(mainFig,'vector');
        current_image   = getappdata(mainFig,'current_image');
        numChosen       = getappdata(mainFig,'numChosen');
        
        try tmp_path = uigetdir('E:\Research\Studies\Histology\DopBck_Study\TiledSamples'); catch
            tmp_path = uigetdir(); 
        end
        tmp_files = dir([tmp_path,'\Da*.jpg']);
        
        set(path_txt,'String',['Path: ',tmp_path]);
        set(count_txt,'String','Chosen: 0');
        
        % make random vector to randomly pick tiles
        num_files = length(tmp_files);
        rand_select = randperm(num_files);
        
        setappdata(mainFig,'vector',rand_select);
        setappdata(mainFig,'path',tmp_path);
        setappdata(mainFig,'files',tmp_files);
        setappdata(mainFig,'current_image',1);
        setappdata(mainFig,'numChosen',0);
    end

% NEXT BUTTON CALLBACK
    function next_callback(~,~)
        files    = getappdata(mainFig,'files');
        vector   = getappdata(mainFig,'vector');
        path     = getappdata(mainFig,'path');
        select   = getappdata(mainFig,'current_image');
        hold off
        % load and display next image:
        check = 0;
        while check == 0
            fileName = files(vector(select)).name;
            I = imread([path,'\',fileName]);
            if and(size(I,1) == 1024,size(I,2) == 1024)
                imagesc(I), hold on
                set(gca,'XTick',[]);
                set(gca,'YTick',[]);
                set(gca,'Box','on');
                set(path_txt,'String',['Path: ',path,'\',fileName]);
                check = 1;
            end
            select = select + 1;
        end
        setappdata(mainFig,'current_image',select);
        setappdata(mainFig,'fileName',fileName);
    end
    
% YES BUTTON CALLBACK
    function yes_callback(~,~)
        chosenList = getappdata(mainFig,'chosenList');
        numChosen  = getappdata(mainFig,'numChosen');
        pathstr    = getappdata(mainFig,'path');
        file       = getappdata(mainFig,'fileName');
        
        numChosen = numChosen + 1; % increase index
        set(count_txt,'String',['Chosen: ',num2str(numChosen)]);
        
        chosenList(numChosen).name = [pathstr,'\',file]; % save filename

        if numChosen == num_tiles_needed % check for final
           set(count_txt,'String',['Chosen: ',num2str(numChosen),' (COMPLETE)']);
           
        end
        setappdata(mainFig,'chosenList',chosenList)
        setappdata(mainFig,'numChosen',numChosen); 
    end

% ANNOTATE BUTTON CALLBACK
    function annotate(~,~)
        fileName = getappdata(mainFig,'fileName');
        path     = getappdata(mainFig,'path');
        
        [x,y] = ginput_mark(1000);
        count = length(x);
        
        setappdata(mainFig,'cellCount',count);
        set(count_num,'String',num2str(count))
        
        assignin('base','x',x);
        assignin('base','y',y);
        savename = uiputfile('.mat');
        save([savename],'x','y','path','fileName')
    end


% FINISH BUTTON CALLBACK
    function finish(~,~)
        pathstr    = getappdata(mainFig,'path');
        chosenList = getappdata(mainFig,'chosenList');
        assignin('base',['chosenList_',pathstr(end-6:end)],chosenList)
        if ~exist('savePath','var')
            savePath = uigetdir();
        end
        save([savePath,'\chosenList_',pathstr(end-6:end),'.mat'],'chosenList')
    end
end