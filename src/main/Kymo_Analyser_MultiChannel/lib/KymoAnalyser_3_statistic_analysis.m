function KymoAnalyser_3_statistic_analysis()
%% Version_date: 20230404 CB ProCeD/Micalis/INRAE
% Comments: the current version is adapted from version '20201127 CB
% ProCeD/Micalis/INRAE' to take into account acquisition with 2 channels.
% The goal is to compare kymographs generated using two fluorescent markers
% (in Channel #1 and #2), quantify speed on each kymographs.

clear all;
lstFolder=uipickfiles();
nFolder=numel(lstFolder);

maxSpeed=100;% Max speed to display

tab_qKymo=[];
for iFolder=1:nFolder
    curFolder=lstFolder{iFolder};
    cd(curFolder)
    if (exist('Quantif_Kymo.txt','file')==2);
        qKymo=load('Quantif_Kymo.txt');
        tab_qKymo=[tab_qKymo;iFolder*ones(size(qKymo,1),1),qKymo];
    end%if
    
end%for
cd ..
tab_qKymo(:,3)=abs(tab_qKymo(:,3));
switch size(tab_qKymo,2)
    case 5
        tab_qKymo=[tab_qKymo(:,[1,5,2,3,4]),ones(size(tab_qKymo,1),1)];% re-order column 'folder / kymo / intMax / speed / direction / Channel ID
        nCh=1;
    case 6
        tab_qKymo=tab_qKymo(:,[1,5,2,3,4,6]);% re-order column 'folder / kymo / intMax / speed / direction / ChannelID        
        nCh=2;
end%switch

f=figure(100);clf;
f.Position=[100 100 900 300];

E_Color='w';
F_Color=['k','g'];
F_AlphA=0.7;

for iCh=1:nCh
    subplot(1,3,1); hold on
    %nBinFluo=floor(2*sqrt(numel(tab_qKymo(:,3))));
    maxFluo=max(tab_qKymo(:,3));
    rangeFluo=100;
    binFluo=rangeFluo/5;
    maxFluo=rangeFluo*round(0.5+maxFluo/rangeFluo);
    h1=histogram(tab_qKymo(tab_qKymo(:,6)==iCh,3),[0:binFluo:maxFluo]);
    xlabel('patch max fluorescence');
    
    subplot(1,3,2); hold on
    h2=histogram(tab_qKymo(tab_qKymo(:,6)==iCh,4),[0:5:maxSpeed]);
    xlabel('rotation speed');
    
    subplot(1,3,3); hold on
    h3=histogram(tab_qKymo(tab_qKymo(:,6)==iCh,5),3);
    xlabel('direction');
    
    
    h1.EdgeColor=E_Color;
    h2.EdgeColor=E_Color;
    h3.EdgeColor=E_Color;
    
    h1.FaceColor=F_Color(iCh);
    h2.FaceColor=F_Color(iCh);
    h3.FaceColor=F_Color(iCh);    
    
    h1.FaceAlpha=F_AlphA;
    h2.FaceAlpha=F_AlphA;
    h3.FaceAlpha=F_AlphA;
end%for iCh

% Get the name of the file that the user wants to save.
% Note, if you're saving an image you can use imsave() instead of uiputfile().
startingFolder = pwd
defaultFileName = fullfile(startingFolder, '*.*');
[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');

if baseFileName == 0
    % User clicked the Cancel button.
    return;
end
fullFileName = fullfile(folder, baseFileName);
fullFileNameXLS=strcat([fullFileName,'.xls']);

labelXLS={'FolderKymo ID','Kymo ID','patch fluorescence','rotation speed','direction','Channel ID'};
xlswrite(fullFileNameXLS,labelXLS,'resultsKymo','A1');
xlswrite(fullFileNameXLS,tab_qKymo,'resultsKymo','A2');

%xlswrite(strcat([baseFileName,'.xls']),labelXLS,'resultsKymo','A1');
%xlswrite(strcat([baseFileName,'.xls']),tab_qKymo,'resultsKymo','A2');

% length(trace)
% save trace_data trace
disp('Export to XLS fils: done');

disp('================== END (3) ==================');

end%function