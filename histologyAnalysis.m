%% Histology Image Analysis
% Jonathan Macoskey, University of Michigan
% Image-Guided Ultrasound Therapy Laboratory
%
% Purpose: analyze collagen and reticulum from histology images chosen from
% histologySelector.m to get an estimation of the collagen and reticulum
% concentration in the tiles
%
% Created: 1/26/17
% Edited: 3/8/17

%% TRI-CHROME COLLAGEN

main = 'E:\Research\Studies\Histology\DopBck_Study\TiledSamples';
files = ['CO1_tri';...
         'S02_tri';...
         'S04_tri';...
         'S06_tri';...
         'S08_tri';...
         'S10_tri';...
         'S11_tri';...
         'S14_tri';...
         ];
meanPercentCol = zeros(length(files),1);
stddevPercentCol = zeros(length(files),1);

for fi = 1:length(files)
    path = [main,'\',files(fi,:),'\'];
    tiles = dir([path,'Da*.jpg']);
    im_res      = 0.253;                    % microns per pixel (length)
    pixel_area  = im_res^2;                 % microns^2 per pixel
    
    for ni = 1:length(tiles)
        disp(['Evaluating ',files(fi,:),' tile ',num2str(ni)])
        I = imread([path,tiles(ni).name]);
        if strcmp(files(fi,:),'S04_tri') == 1
            [tiles(ni).collagenBW,tiles(ni).collagenRGB] = createCollagenMask_lite(I);
        else
            [tiles(ni).collagenBW,tiles(ni).collagenRGB] = createCollagenMask_norm(I);
        end
        tiles(ni).collagenCount   = sum(sum(tiles(ni).collagenBW));
        tiles(ni).collagenPercent = tiles(ni).collagenCount./(1024*1024);
        tiles(ni).collagenArea    = tiles(ni).collagenCount.*pixel_area;
    end
    meanPercentCol(fi,1) = mean([tiles.collagenPercent]);
    stddevPercentCol(fi,1) = std([tiles.collagenPercent]);
    disp('saving...')
    save(['E:\Research\Studies\Histology\DopBck_Study\Structures\',files(fi,:),'_struct.mat'],'tiles')
end

%% RETICULIN

main = 'E:\Research\Studies\Histology\DopBck_Study\TiledSamples';
files = ['CO1_ret';...
         'S02_ret';...
         'S04_ret';...
         'S06_ret';...
         'S08_ret';...
         'S10_ret';...
         'S11_ret';...
         'S14_ret';...
         ];
meanPercentRet = zeros(length(files),1);
stddevPercentRet = zeros(length(files),1);

for fi = 1:length(files)
     path = [main,'\',files(fi,:),'\'];
     tiles = dir([path,'Da*.jpg']);
     im_res      = 0.253;                    % microns per pixel (length)
     pixel_area  = im_res^2;                 % microns^2 per pixel

     for ni = 1:length(tiles)
         disp(['Evaluating ',files(fi,:),' tile ',num2str(ni)])
         I = imread([path,tiles(ni).name]);
         [tiles(ni).reticulinBW,tiles(ni).reticulinRGB] = createReticulinMask(I);
         tiles(ni).reticulinCount   = sum(sum(tiles(ni).reticulinBW));
         tiles(ni).reticulinPercent = tiles(ni).reticulinCount./(1024*1024);
         tiles(ni).reticulinArea    = tiles(ni).reticulinCount.*pixel_area;
     end
     meanPercentRet(fi,1) = mean([tiles.reticulinPercent]);
     stddevPercentRet(fi,1) = std([tiles.reticulinPercent]);
     disp('saving...')
     save(['E:\Research\Studies\Histology\DopBck_Study\Structures\',files(fi,:),'_struct.mat'],'tiles')
end
     
%% RELOAD DATA
reload_main = 'E:\Research\Studies\Histology\DopBck_Study\Structures';
for fi = 1:length(files)
    path = [main,'\',files(fi,:),'_struct.mat'];
    load(path)
    
end

%% CELL COUNT FIGURE

meanCells   = [149.9 108.4 36.7 44.2 4.5 0.4 0.5 0];        % from Excel sheet
stddevCells = [12.54 18.08 44.87 33.15 10.06 1.26 1.58 0];  % from Excel sheet
dose = [0 30 60 100 200 300 500 1000];

% least-squares curve fit
fun = @(x,xdata)x(1)*exp(x(2)*xdata);
x0 = [200,-0.1];
x = lsqcurvefit(fun,x0,dose,meanCells);
dose_fit = dose(1):1:dose(end);
cellfit = fun(x,dose_fit);

% residuals
datamean = mean(meanCells);
SStot = sum((meanCells - datamean).^2);
SSreg = sum((cellfit(dose + 1) - datamean).^2);
SSres = sum((meanCells - cellfit(dose + 1)).^2);
Rsq = 1 - SSres/SStot;

figure(500), clf, set(500,'Position',[546 336 1100 411])
plot(dose_fit,cellfit,'LineWidth',3)
hold on, err = errorbar(dose,meanCells,stddevCells,'.','MarkerSize',40,'LineWidth',2);

title 'Non-Lysed Cells Remaining Throughout Treatment'
xlabel 'Pulse Number', ylabel 'Mean Cells per Tile'
xlim([-20 1020]), ylim([0 170])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 40 80 120 160])
set(gca,'FontSize',14)

legend('Nonlinear least-squares fit','Count \pm \sigma')
text(700,20,['R^2 = ',num2str(Rsq)],'FontSize',12);

%% RETICULIN FIGURE
retData = meanPercentRet'.*100;
retStddev = stddevPercentRet.*100';

% least-squares curve fit
fun = @(x,xdata)x(1)*exp(x(2)*xdata);
x0 = [.01,0];
x = lsqcurvefit(fun,x0,dose,retData);
dose_fit = dose(1):1:dose(end);
retfit = fun(x,dose_fit);

% residuals
datamean = mean(retData);
SStot = sum((retData - datamean).^2);
SSreg = sum((retfit(dose + 1) - datamean).^2);
SSres = sum((retData - retfit(dose + 1)).^2);
Rsq = 1 - SSres/SStot;

figure(600), clf, set(600,'Position',[546 336 1100 411])
plot(dose_fit,retfit,'LineWidth',3)
hold on, err = errorbar(dose,retData,retStddev,'.','MarkerSize',40,'LineWidth',2);
title 'Percent Area Covered by Reticulin Throughout Treatment'
xlabel 'Pulse Number', ylabel 'Mean Percent Area Covered'
xlim([-20 1020]), ylim([-0.25 5])
xtick([0 30 60 100 200 300 500 1000])
ytick([0 1 2 3 4 5])
set(gca,'FontSize',14)


legend('Nonlinear least-squares fit','Percent Reticulin')
text(700,0.75,['R^2 = ',num2str(Rsq)],'FontSize',12);


%% COLLAGEN FIGURE
colData = meanPercentCol'.*100;
colStddev = stddevPercentCol.*100';

% least-squares curve fit
fun = @(x,xdata)x(1)*exp(x(2)*xdata);
x0 = [.01,0];
x = lsqcurvefit(fun,x0,dose,colData);
dose_fit = dose(1):1:dose(end);
colfit = fun(x,dose_fit);

% residuals
datamean = mean(colData);
SStot = sum((colData - datamean).^2);
SSreg = sum((colfit(dose + 1) - datamean).^2);
SSres = sum((colData - colfit(dose + 1)).^2);
Rsq = 1 - SSres/SStot;

figure(700), clf, set(700,'Position',[546 336 1100 411])
plot(dose_fit,colfit,'LineWidth',3)
hold on, err = errorbar(dose,colData,colStddev,'.','MarkerSize',40,'LineWidth',2);
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
    plot(dose_fit,cellfit,'LineWidth',2), hold on
    ylabel 'Cells Remaining'
    ylim([0 170])
    ytick([0 40 80 120 160])
    
yyaxis right
    plot(dose_fit,retfit,'LineWidth',2)
    plot(dose_fit,colfit,'LineWidth',2)
    ylim([0 2.5])
    ytick([0 1 2 3])
    ylabel 'Percent Area Coverage'

legend('Cell Count','Reticulin Area','Collagen Area','Location','SW');

title 'Comparison of Histological Changes Throughout Treatment'


%%
%{
cells = [130	174	148	149	145	142	154	158	161	138;	
         104	126	95	88	127	122	128	120	82	92;	
         77	    3	115	106	2	6	7	5	20	26;
         2	    114	51	32	31	47	23	13	82	47;
         0	    5	0	0	0	8	32	0	0	0;
         0	    4	0	0	0	0	0	0	0	0;
         0	    0	0	5	0	0	0	0	0	0;
         0	    0	0	0	0	0	0	0	0	0];
%}








