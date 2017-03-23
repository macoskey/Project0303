%% Histology Image Analysis
% Jonathan Macoskey, University of Michigan
% Image-Guided Ultrasound Therapy Laboratory
%
% Purpose: analyze collagen and reticulum from histology images chosen from
% histologySelector.m to get an estimation of the collagen and reticulum
% concentration in the tiles
%
% Created: 1/26/17
% Edited: 3/21/17

%% TRI-CHROME COLLAGEN

main = 'E:\Research\Studies\Histology\DopBck_Study\TiledSamples';
% I know this is awful - get over it:
TC_files = ['S02'; 'S15'; 'S16'; 'S32'; 'S48'; 'S49';...
         'S04';	'S17'; 'S18'; 'S35'; 'S36'; 'S50';...
         'S06'; 'S20'; 'S38'; 'S39'; 'S52'; 'S53';...
         'S08';	'S21'; 'S22'; 'S40'; 'S41'; 'S55';... 
         'S10'; 'S23'; 'S24'; 'S43'; 'S57';	'S58';... 
         'S11'; 'S25'; 'S26'; 'S44'; 'S45'; 'S60';... 
         'S14'; 'S28'; 'S30'; 'S31'; 'S46';	'S62';... 
         'CO1'; 'CO2'; 'CO3'; 'CO4'; 'CO5'; 'CO6';...
         ];
fileKey = repmat([30 60 100 200 300 500 1000 0]',6,1);

% due to inconsistent histology protocol (both with staining and
% potentially scanning), multiple color thresholders had to be made to
% account for variabilities in the color spectra of the various samples.
maskKeyCol = [1  1	 1	1	3	3	
    2	4	1	1	4	1
    1	1	3	4	6	6
    1	1	5	1	5	1
    1	1	5	1	6	7
    8	1	1	1	1	1
    1	1	1	1	1	3
    1	1	1	1	1	1]';
maskKeyCol = maskKeyCol(:);

meanPercentCol = zeros(length(TC_files),1);
stddevPercentCol = zeros(length(TC_files),1);

for fi = 1:length(TC_files)
    path = [main,'\',TC_files(fi,:),'_tri\'];
    tiles = dir([path,'Da*.jpg']);
    im_res      = 0.253;                    % microns per pixel (length)gnu
    pixel_area  = im_res^2;                 % microns^2 per pixel
    
    for ni = 1:length(tiles)
        disp(['Evaluating ',TC_files(fi,:),'_tri tile ',num2str(ni)])
        I = imread([path,tiles(ni).name]);
        eval(sprintf('[tiles(%.1d).collagenBW,tiles(%.1d).collagenRGB] = createCollagenMask%.1d(I);',ni,ni,maskKeyCol(fi)));
        tiles(ni).collagenCount   = sum(sum(tiles(ni).collagenBW));
        tiles(ni).collagenPercent = tiles(ni).collagenCount./(1024*1024);
        tiles(ni).collagenArea    = tiles(ni).collagenCount.*pixel_area;
    end
    meanPercentCol(fi,1) = mean([tiles.collagenPercent]);
    stddevPercentCol(fi,1) = std([tiles.collagenPercent]);
    disp('saving...')
    save(['E:\Research\Studies\Histology\DopBck_Study\Structures\',TC_files(fi,:),'_tri_struct.mat'],'tiles')
end

% RETICULIN
main = 'E:\Research\Studies\Histology\DopBck_Study\TiledSamples';
RT_files = ['S02'; 'S15'; 'S16'; 'S32'; 'S48'; 'S49';...
            'S04'; 'S17'; 'S51'; 'S35'; 'S36'; 'S50';...
            'S06'; 'S54'; 'S38'; 'S39'; 'S52'; 'S53';...
            'S08'; 'S21'; 'S22'; 'S40'; 'S41'; 'S55';... 
            'S10'; 'S23'; 'S24'; 'S43'; 'S57'; 'S58';... 
            'S11'; 'S25'; 'S26'; 'S59'; 'S45'; 'S60';... 
            'S14'; 'S28'; 'S30'; 'S31'; 'S46'; 'S62';... 
            'CO1'; 'CO2'; 'CO3'; 'CO4'; 'CO5'; 'CO6';...
            ];
maskKeyRet = [1	2	3	1	2	1
    1	3	1	3	1	1
    1	1	4	3	1	1
    1	3	1	3	4	3
    1	2	2	1	1	1
    1	2	1	1	1	1
    1	1	1	1	1	1
    1	3	3	3	3	3]';
maskKeyRet = maskKeyRet(:);

meanPercentRet = zeros(length(RT_files),1);
stddevPercentRet = zeros(length(RT_files),1);

for fi = 1:length(RT_files)
     path = [main,'\',RT_files(fi,:),'_ret\'];
     tiles = dir([path,'Da*.jpg']);
     im_res      = 0.253;                    % microns per pixel (length)
     pixel_area  = im_res^2;                 % microns^2 per pixel

     for ni = 1:length(tiles)
         disp(['Evaluating ',RT_files(fi,:),'_ret tile ',num2str(ni)])
         I = imread([path,tiles(ni).name]);
         eval(sprintf('[tiles(%.1d).reticulinBW,tiles(%.1d).reticulinRGB] = createReticulinMask%.1d(I);',ni,ni,maskKeyRet(fi)));
         tiles(ni).reticulinCount   = sum(sum(tiles(ni).reticulinBW));
         tiles(ni).reticulinPercent = tiles(ni).reticulinCount./(1024*1024);
         tiles(ni).reticulinArea    = tiles(ni).reticulinCount.*pixel_area;
     end
     meanPercentRet(fi,1) = mean([tiles.reticulinPercent]);
     stddevPercentRet(fi,1) = std([tiles.reticulinPercent]);
     disp('saving...')
     save(['E:\Research\Studies\Histology\DopBck_Study\Structures\',RT_files(fi,:),'_ret_struct.mat'],'tiles')
end
     
%% RELOAD DATA
meanPercentCol = zeros(length(TC_files),1); stddevPercentCol = zeros(length(TC_files),1);
meanPercentRet = zeros(length(RT_files),1); stddevPercentRet = zeros(length(RT_files),1);
reload_main = 'E:\Research\Studies\Histology\DopBck_Study\Structures';

for fi = 1:length(TC_files)
    fprintf('loading file %.1d of %.1d... \n',fi,length(TC_files))
    TC_path = [reload_main,'\',TC_files(fi,:),'_struct.mat'];
    RT_path = [reload_main,'\',RT_files(fi,:),'_struct.mat'];
    TC_tmp = load(TC_path); RT_tmp = load(RT_path);
    for si = 1:length(TC_tmp.tiles)
        meanPercentCol(fi,1) = meanPercentCol(fi,1) + TC_tmp.tiles(si).collagenPercent;
        meanPercentRet(fi,1) = meanPercentRet(fi,1) + RT_tmp.tiles(si).reticulinPercent;
    end
    meanPercentCol(fi,1) = meanPercentCol(fi,1)./si;
    meanPercentRet(fi,1) = meanPercentRet(fi,1)./si;
end
fprintf('complete \n')
%% CELL COUNT FIGURE

meanCells = [149.9	175.5	180.6	165.9	167.7	171.3
             108.4	126.1	 50.1	 61.4	 60.2	   57
              36.7     15	 88.4	 25.8	 25.9	  6.9
              44.2	 40.3	  0.3	 26.3	  4.2	  1.7
               4.5	 11.9	    6	    2	  2.7	  3.4
               0.4	    6	  3.1	    0	    0	  1.2
               0.5	    0	  0.1	  0.1 	    0	    0
                 0	    0	    0	    0	    0	    0];
dose = [0 30 60 100 200 300 500 1000];
dose2 = dose(ones(1,6),:)';

% least-squares curve fit
x0 = [200,-0.1];
[doseFit,cellFit] = nls_curve(dose2,meanCells,x0);

% residuals
datamean = mean(mean(meanCells));
SStot = sum(sum((meanCells - datamean).^2));
SSreg = sum((cellFit(dose + 1) - datamean).^2);
cellFit2 = cellFit(ones(1,6),dose + 1)';
SSres = sum(sum((meanCells - cellFit2).^2));
Rsq = 1 - SSres/SStot;

figure(500), clf, set(500,'Position',[546 336 1100 411])
plot(doseFit,cellFit,'k-','LineWidth',3), hold on
plot(dose,meanCells,'.','MarkerSize',20,'Color','k')
% err = errorbar(dose,meanCells,stddevCells,'.','MarkerSize',40,'LineWidth',2);

title 'Non-Lysed Cells Remaining Throughout Treatment'
xlabel 'Pulse Number', ylabel 'Mean Cells per Tile'
xlim([-20 1020]), ylim([0 170])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 40 80 120 160])
set(gca,'FontSize',14)

legend('Nonlinear least-squares fit','Count \pm \sigma')
text(700,20,['R^2 = ',num2str(Rsq)],'FontSize',12);
text(700,10,'n = 6','FontSize',12);

%% RETICULIN FIGURE

retData = circshift(reshape(meanPercentRet,8,6).*100,1,1);
retDose = [30 60 100 200 300 500 1000 0];
retDose2 = circshift(repmat(retDose',1,6),1,1);

% least-squares curve fit
x0 = [0.1,0];
[doseFit,retFit] = nls_curve(retDose2,retData,x0);

% residuals
datamean = mean(mean(retData));
SStot = sum(sum((retData - datamean).^2));
SSreg = sum((retFit(retDose + 1) - datamean).^2);
retFit2 = retFit(ones(1,6),dose + 1)';
SSres = sum(sum((retData - retFit2).^2));
Rsq = 1 - SSres/SStot;

figure(600), clf, set(600,'Position',[546 336 1100 411])
plot(doseFit,retFit,'k-','LineWidth',3), hold on
plot(retDose,retData,'.','MarkerSize',40);
% err = errorbar(dose,retData,retStddev,'.','MarkerSize',40,'LineWidth',2);
title 'Percent Area Covered by Reticulin Throughout Treatment'
xlabel 'Pulse Number', ylabel 'Mean Percent Area Covered'
xlim([-20 1020]), ylim([-0.25 5])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 1 2 3 4 5])
set(gca,'FontSize',14)

legend('Nonlinear least-squares fit','Percent Reticulin')
text(700,0.75,['R^2 = ',num2str(Rsq)],'FontSize',12);


%% COLLAGEN FIGURE
colData = circshift(reshape(meanPercentCol,8,6).*100,1,1);
colDose2 = retDose2;

% least-squares curve fit
x0 = [.01,0];
[doseFit,colFit] = nls_curve(colDose2,colData,x0);

% residuals
datamean = mean(mean(colData));
SStot = sum(sum((colData - datamean).^2));
SSreg = sum((colFit(dose + 1) - datamean).^2);
colFit2 = colFit(ones(1,6),dose + 1)';
SSres = sum(sum((colData - colFit2).^2));
Rsq = 1 - SSres/SStot;

figure(700), clf, set(700,'Position',[546 336 1100 411])
plot(doseFit,colFit,'LineWidth',3), hold on
plot(dose,colData,'.','MarkerSize',40);
% err = errorbar(dose,colData,colStddev,'.','MarkerSize',40,'LineWidth',2);
title 'Percent Area Covered by Collagen Throughout Treatment'
xlabel 'Pulse Number', ylabel 'Mean Percent Area Covered'
xlim([-20 1020]), ylim([-0.25 6])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 1 2 3 4 5])
set(gca,'FontSize',14)

legend('Nonlinear least-squares fit','Percent Collagen')
text(700,1.2,['R^2 = ',num2str(Rsq)],'FontSize',12);

%% ALL THREE
figure(800), clf, set(800,'Position',[546 336 700 411]), set(gca,'FontSize',14)
set(gca,'xscale','log')
xlabel 'Pulse Number'
yyaxis left
    plot(doseFit,cellFit,'LineWidth',2), hold on
    ylabel 'Cells Remaining'
    ylim([0 170])
    ytick([0 40 80 120 160])
    
yyaxis right
    plot(doseFit,retFit,'LineWidth',2)
    plot(doseFit,colFit,'LineWidth',2)
    ylim([0 2.5])
    ytick([0 1 2 3])
    ylabel 'Percent Area Coverage'

legend('Cell Count','Reticulin Area','Collagen Area','Location','SW');

title 'Comparison of Histological Changes Throughout Treatment'






