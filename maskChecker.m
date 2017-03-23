%% Histology Image Proc Checker
% Jonathan Macoskey, University of Michigan
% Image-Guided Ultrasound Therapy Laboratory
%
% Purpose: allow for quick check of mask functions on histology - meant to
% help correct for varying histology stainings from batch to batch
%
% Created: 3/21/17



main = 'E:\Research\Studies\Histology\DopBck_Study\TiledSamples';

%% col/tri
TC_files = ['S02'; 'S15'; 'S16'; 'S32'; 'S48'; 'S49';...
            'S04'; 'S17'; 'S18'; 'S35'; 'S36'; 'S50';...
            'S06'; 'S20'; 'S38'; 'S39'; 'S52'; 'S53';...
            'S08'; 'S21'; 'S22'; 'S40'; 'S41'; 'S55';... 
            'S10'; 'S23'; 'S24'; 'S43'; 'S57'; 'S58';... 
            'S11'; 'S25'; 'S26'; 'S44'; 'S45'; 'S60';... 
            'S14'; 'S28'; 'S30'; 'S31'; 'S46'; 'S62';... 
            'CO1'; 'CO2'; 'CO3'; 'CO4'; 'CO5'; 'CO6';...
            ];
figure;
for fi = 1:length(TC_files)
    path = [main,'\',TC_files(fi,:),'_tri\'];
    tiles = dir([path,'Da*.jpg']);
    I = imread([path,tiles(randi([1 225],1)).name]);
    [bw,rgb] = createCollagenMask_norm(I);
    subplot(121), imagesc(I), axis equal tight
    subplot(122), imagesc(rgb), axis equal tight
    title(TC_files(fi,:))
    pause;
end

%%
fi = 42;
path = [main,'\',TC_files(fi,:),'_tri\'];
I = imread([path,tiles(randi([1 225],1)).name]);
[bw,rgb] = createCollagenMask3(I);
subplot(121), imagesc(I), axis equal tight
subplot(122), imagesc(rgb), axis equal tight
title(TC_files(fi,:),'FontSize',24)


%% ret
RT_files = ['S02'; 'S15'; 'S16'; 'S32'; 'S48'; 'S49';...
            'S04'; 'S17'; 'S51'; 'S35'; 'S36'; 'S50';...
            'S06'; 'S54'; 'S38'; 'S39'; 'S52'; 'S53';...
            'S08'; 'S21'; 'S22'; 'S40'; 'S41'; 'S55';... 
            'S10'; 'S23'; 'S24'; 'S43'; 'S57'; 'S58';... 
            'S11'; 'S25'; 'S26'; 'S59'; 'S45'; 'S60';... 
            'S14'; 'S28'; 'S30'; 'S31'; 'S46'; 'S62';... 
            'CO1'; 'CO2'; 'CO3'; 'CO4'; 'CO5'; 'CO6';...
            ];
figure;
for fi = 1:length(RT_files)
    path = [main,'\',RT_files(fi,:),'_ret\'];
    tiles = dir([path,'Da*.jpg']);
    I = imread([path,tiles(randi([1 225],1)).name]);
    [bw,rgb] = createReticulinMask(I);
    subplot(121), imagesc(I), axis equal tight
    subplot(122), imagesc(bw), axis equal tight
    title(RT_files(fi,:))
    pause;
end

%%
fi = 45;
path = [main,'\',RT_files(fi,:),'_ret\'];
I = imread([path,tiles(randi([1 225],1)).name]);
[bw,rgb] = createReticulinMask3(I);
subplot(121), imagesc(I), axis equal tight
subplot(122), imagesc(bw), colormap gray, axis equal tight
title(RT_files(fi,:),'FontSize',24)






