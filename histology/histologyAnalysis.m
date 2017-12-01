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

main = 'E:\Box Sync\Research\Studies\0303_20171215\TiledSamples';
% addpath('E:\Box Sync\Research\Studies\0403_20171215\threshFuncs')

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
fileKey = repmat([30*ones(1,6) 60 100 200 300 500 1000 0]',1,6);

% due to inconsistent histology protocol (both with staining and
% potentially scanning), multiple color thresholders had to be made to
% account for variabilities in the color spectra of the various samples.
maskKeyCol = [1  1	 1	1	3	9	
    2	4	1	1	4	9
    1	1	3	4	6	9
    1	1	5	1	5	1
    1	1	5	1	6	7
    8	1	1	1	1	1
    1	1	1	1	1	3
    1	1	1	1	1	9]';
maskKeyCol = maskKeyCol(:);

%meanPercentCol = zeros(length(TC_files),1);
%stddevPercentCol = zeros(length(TC_files),1);

for fi = [6 12 18 24 30 36 42 48]
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

%% RETICULIN
main = 'E:\Box Sync\Research\Studies\0303_20171215\TiledSamples';
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
    1	5	1	3	4	3
    1	2	5	1	1	1
    1	5	1	1	1	1
    1	1	1	1	1	1
    1	3	3	3	3	3]';
maskKeyRet = maskKeyRet(:);

%meanPercentRet = zeros(length(RT_files),1);
%stddevPercentRet = zeros(length(RT_files),1);

for fi = 20 % 1:length(RT_files)
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
reload_main = 'E:\Box Sync\Research\Studies\0303_20171215\Structures';

for fi = 1:length(TC_files)
    fprintf('loading file %.1d of %.1d... \n',fi,length(TC_files))
    TC_path = [reload_main,'\',TC_files(fi,:),'_tri_struct.mat'];
    RT_path = [reload_main,'\',RT_files(fi,:),'_ret_struct.mat'];
    TC_tmp = load(TC_path); RT_tmp = load(RT_path);
    for si = 1:length(TC_tmp.tiles)
        meanPercentCol(fi,1) = meanPercentCol(fi,1) + TC_tmp.tiles(si).collagenPercent;
        meanPercentRet(fi,1) = meanPercentRet(fi,1) + RT_tmp.tiles(si).reticulinPercent;
    end
    meanPercentCol(fi,1) = meanPercentCol(fi,1)./si;
    meanPercentRet(fi,1) = meanPercentRet(fi,1)./si;
end
fprintf('complete \n')

%% QUICK RELOAD
load('E:\Box Sync\Research\Studies\0303_20171215\d0403_reloadedRawData.mat')

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
x0 = [200,-0.1 0 -0.1];
[doseFit,cellFit] = nls_curve(dose2,meanCells,x0);

% residuals
datamean = mean(mean(meanCells));
SStot = sum(sum((meanCells - datamean).^2));
SSreg = sum((cellFit(dose + 1) - datamean).^2);
cellFit2 = cellFit(ones(1,6),dose + 1)';
SSres = sum(sum((meanCells - cellFit2).^2));
Rsq_cel = round((1 - SSres/SStot)*100)/100;

clf
figure(500), clf, set(500,'Position',[546 336 900 400])
plot(dose,meanCells,'.','Color',[0.3 0.3 0.3],'MarkerSize',25), hold on
plot(doseFit,cellFit,'k-','LineWidth',3)
% err = errorbar(dose,meanCells,stddevCells,'.','MarkerSize',40,'LineWidth',2);

title 'Non-Lysed Cells Remaining Throughout Treatment'
xlabel 'Pulse Number', ylabel 'Mean Cells per Tile'
xlim([-20 1020]), ylim([-5 180])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 40 80 120 160])
box on
grid on
set(gca,'GridLineStyle','--')
set(gca,'LineWidth',1.5)
set(gca,'FontSize',20)
xtickangle(-90)

[h,p,stats] = chi2gof(mean(meanCells'),'nbins',2,'cdf',@normcdf)
text(800,30,['R^2 = ',num2str(Rsq_cel)],'FontSize',12);
text(800,15,'p < 0.001','FontSize',12);
% saveas(500,'E:\Box Sync\Research\Studies\0302_20171215\Figures\cellCount.png')
% saveas(500,'E:\Box Sync\Research\Studies\0302_20171215\Figures\cellCount.fig')


%% RETICULIN FIGURE

retData = circshift(reshape(meanPercentRet.*100,6,8)',1,1);
retDose = [30 60 100 200 300 500 1000 0].*ones(1,6)'; retDoseVec = retDose(:);
retDose2 = circshift(reshape(retDoseVec,6,8)',1,1);

% least-squares curve fit
x0 = [0.1,0 0 -0.1];
[doseFit,retFit] = nls_curve(retDose2,retData,x0);

% residuals
datamean = mean(mean(retData));
SStot = sum(sum((retData - datamean).^2));
SSreg = sum((retFit(retDose + 1) - datamean).^2);
retFit2 = retFit(ones(1,6),dose + 1)';
SSres = sum(sum((retData - retFit2).^2));
Rsq_ret = round((1 - SSres/SStot)*100)/100;

figure(600), clf, set(600,'Position',[2000 336 900 400])
plot(retDose2,retData,'.','Color',[0.3 0.3 0.3],'MarkerSize',25), hold on;
plot(doseFit,retFit,'k-','LineWidth',3)
% err = errorbar(dose,retData,retStddev,'.','MarkerSize',40,'LineWidth',2);
title 'Percent Area Covered by Reticulin'
xlabel 'Pulse Number', ylabel 'Mean Percent Area Covered'
xlim([-20 1020]), ylim([-0.25 5])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 1 2 3 4 5])
box on
grid on
set(gca,'GridLineStyle','--')
set(gca,'LineWidth',1.5)
set(gca,'FontSize',20)
xtickangle(-45)

[h,p_ret,stats] = chi2gof(mean(retData'),'nbins',2,'cdf',@normcdf);
text(800,1.25,['R^2 = ',num2str(Rsq_ret)],'FontSize',12);
text(800,0.8,'p = 0.013','FontSize',12);
% saveas(600,'E:\Box Sync\Research\Studies\0302_20171215\Figures\reticulin.png')
% saveas(600,'E:\Box Sync\Research\Studies\0302_20171215\Figures\reticulin.fig')


%% COLLAGEN FIGURE
colData = circshift(reshape(meanPercentCol.*100,6,8)',1,1);
colDose2 = retDose2;

% least-squares curve fit
x0 = [100,-.00001 0 0];
[doseFit,colFit] = nls_curve(colDose2,colData,x0);

% residuals
datamean = mean(mean(colData));
SStot = sum(sum((colData - datamean).^2));
SSreg = sum((colFit(dose + 1) - datamean).^2);
colFit2 = colFit(ones(1,6),dose + 1)'; % plus 1 because
SSres = sum(sum((colData - colFit2).^2));
Rsq_col = round((1 - SSres/SStot)*100)/100;

figure(700), clf, set(700,'Position',[2000 336 900 400])
plot(dose,colData,'.','Color',[0.3 0.3 0.3],'MarkerSize',25), hold on;
plot(doseFit,colFit,'k','LineWidth',3)
% err = errorbar(dose,colData,colStddev,'.','MarkerSize',40,'LineWidth',2);
title 'Percent Area Covered by Collagen'
xlabel 'Pulse Number', ylabel 'Mean Percent Area Covered'
xlim([-20 1020]), ylim([-0.25 8])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 1 2 3 4 5 6 7 8])
box on
grid on
set(gca,'GridLineStyle','--')
set(gca,'LineWidth',1.5)
set(gca,'FontSize',20)
xtickangle(-70)

[h,p,stats] = chi2gof(mean(colData'),'nbins',2,'cdf',@normcdf);
text(800,1.5,['R^2 = ',num2str(Rsq_col)],'FontSize',12);
text(800,0.75,'p < 0.001','FontSize',12);
% saveas(700,'E:\Box Sync\Research\Studies\0302_20171215\Figures\triChromeCollagen.png')
% saveas(700,'E:\Box Sync\Research\Studies\0302_20171215\Figures\triChromeCollagen.fig')

%% ALL THREE
figure(800), clf, set(gca,'FontSize',14) %set(800,'Position',[546 336 700 411]), 
set(gca,'xscale','log')
xlabel 'Pulse Number'
yyaxis left
    plot(doseFit,cellFit,'LineWidth',2), hold on
    ylabel('Cells Remaining')
    ylim([0 170])
    ytick([0 40 80 120 160])
    
yyaxis right
    plot(doseFit,retFit,'LineWidth',2)
    plot(doseFit,colFit,'LineWidth',2)
    ylim([0 3.3])
    ytick([0 1 2 3])
    ylabel('Percent Area Coverage')

xlim([0 1000])
box on
set(gca,'LineWidth',3)
legend('Cell Count','Reticulin Area','Collagen Area','Location','SW');
title 'Histological Changes Throughout Treatment'
saveas(800,'E:\Box Sync\Research\Studies\0302_20171215\Figures\allThreeLog.png')
saveas(800,'E:\Box Sync\Research\Studies\0302_20171215\Figures\allThreeLog.fig')

%% ALL THREE SUBPLOT
hand=figure('Name', 'subplot_tight');
set(hand,'Position',[2046 50 750 600])
marg = [0.05 0.08];
fontSize = 12;
markSize = 20;

% cells
subplot_tight(3,1,1,marg)
plot(doseFit,cellFit,'r-','LineWidth',3), hold on
plot(dose,meanCells,'k.','MarkerSize',markSize,'Color','k')

ylabel 'Cells per Tile'
xlim([0 1000]), ylim([0 180])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 40 80 120 160])
set(gca,'FontSize',fontSize)
legend('Nonlinear least-squares fit','Cell Count')

str1 = sprintf('R^2 = %.2f',Rsq_cel);
text(700,35,str1,'FontSize',12);
text(700,18.5,'p < 0.001','FontSize',12);


% retic
subplot_tight(3,1,2,marg)
plot(doseFit,retFit,'r-','LineWidth',3), hold on
plot(retDose2,retData,'k.','MarkerSize',markSize);

ylabel 'Reticulin Area(%)'
xlim([0 1000]), ylim([-0.25 5])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 1 2 3 4 5])
set(gca,'FontSize',fontSize)
legend('Nonlinear least-squares fit','Percent Reticulin')

str2 = sprintf('R^2 = %.2f',Rsq_ret);
text(700,1.2,str2,'FontSize',12);
text(700,0.7,'p < 0.001','FontSize',12);


% coll
subplot_tight(3,1,3,[0.09 marg(2)])
plot(doseFit,colFit,'r-','LineWidth',3), hold on
plot(dose,colData,'k.','MarkerSize',markSize);

xlabel 'Pulse Number', ylabel 'Collagen Area (%)'
xlim([0 1000]), ylim([-0.25 8])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 2 4 6 8])
set(gca,'FontSize',fontSize)
legend('Nonlinear least-squares fit','Percent Collagen')

str3 = sprintf('R^2 = %.2f',Rsq_col);
text(700,2.5,str3,'FontSize',12);
text(700,1.5,'p < 0.001','FontSize',12);

saveas(hand,'E:\Box Sync\Research\Studies\0402_20171215\Figures\allThree_subplot.png')
saveas(hand,'E:\Box Sync\Research\Studies\0402_20171215\Figures\allThree_subplot.fig')



%% time constants
cell63 = max(cellFit)./exp(1);
col63 = max(colFit)./exp(1);
ret63 = max(retFit)./exp(1);

ACE1_63 = max(envFit)./exp(1);
ACE2_63 = max(lagsFit).*(1-1/exp(1));
ACE3_63 = max(corrFit)./exp(1);

cell_tc = find(abs(cellFit-cell63) < 1);
col_tc = find(abs(colFit-col63) < 0.005);
ret_tc = find(abs(retFit-ret63) < 0.005);

ACE1_tc = find(abs(envFit-ACE1_63) < 0.01);
ACE2_tc = find(abs(lagsFit-ACE2_63) < 0.0005);
ACE3_tc = find(abs(corrFit-ACE3_63) < 0.1);

fprintf('cell tau = %.f \ncoll tau = %.f \nretic tau = %.f \n',cell_tc(1),col_tc(1),ret_tc(1))
fprintf('max tau = %.f \nlags tau = %.f \ncorr tau = %.f \n',ACE1_tc(1),ACE2_tc(1),inf)







