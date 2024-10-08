function KymoAnalyser_1_draw_track()
%% Version_date: 20230404 CB ProCeD/Micalis/INRAE
% Comments: the current version is adapted from version '20201127 CB
% ProCeD/Micalis/INRAE' to take into account acquisition with 2 channels.
% The goal is to compare kymographs generated using two fluorescent markers
% (in Channel #1 and #2), quantify speed on each kymographs.

clear all;

%% Parameters
lineWidthKymo=10;% Real size is 2*lineWidthKymo
timeImageStack=0.5;% interval time between two consecutive images in movie
projectionMovieType=1; %Projection mode for stack (1=max, 2=sum, 3=average)
doZoomBetweenImage=1; % Move Image before plot line on cell (1 = Yes / 0 = No)
displayMovie=0; % Show time-lapse sequence when multi-color acquisitions (1 = Yes / 0 = No)
prompt = {'Enter half width for kymo:',...
    'Enter internal time between two consecutive images in movie (in sec):',...
    'Projection mode for stack (1=max, 2=sum, 3=average)',...
    'Move Image before plot line on cell (1 = Yes / 0 = No)',...
    'Show time-lapse sequence when multi-color acquisitions (1 = Yes / 0 = No)'};
dlgtitle = 'Kymo parameters';
dims = [1 50];
definput = {num2str(lineWidthKymo),num2str(timeImageStack),num2str(projectionMovieType),num2str(doZoomBetweenImage),num2str(displayMovie)};
answer = inputdlg(prompt,dlgtitle,dims,definput);
lineWidthKymo=str2double(answer{1});
timeImageStack=str2double(answer{2});
projectionMovieType=str2double(answer{3});
doZoomBetweenImage=str2double(answer{4});
displayMovie=str2double(answer{5});
clear answer definput dims dlgtitle prompt;

nK=0;
dirGen='Kymo_00';
doLoadFig=0;
%% Data loading
[ImovieCh,filenameImg,pathImg,imgMetadata,infoImg,nCh]=loadImageSequence();

%% Select channel used to define multi_kymo (only for multi-color acq.)
[Imovie,ID_Ch]=selectChannelToDrawMultiKymo(ImovieCh,nCh,displayMovie);

%% Prepare results folder
if exist('_results_Kymo','dir')==0
    mkdir('_results_Kymo')
end%if

filenameImg_woExt=filenameImg(1:(max(strfind(filenameImg,'.'))-1));
cd('_results_Kymo');
if exist(filenameImg_woExt,'dir')==0
    mkdir(filenameImg_woExt);
end%if
pathRes=strcat(['_results_Kymo',filesep,filenameImg_woExt]);


%% Check if analysis already started
cd ../
cd(pathRes)
lst_KymoF=dir('Kymo_*');
if (exist('parametersKymo.txt','file')==2)
    
    paramK=load('parametersKymo.txt');
    nK=paramK(1);
    timeImageStack=paramK(2);
    
    if (nK==numel(lst_KymoF))
        
        previousRes=1;%
        prompt = {'Data found on the result folder. What would you like to do? 1=continue after last Kymo / 2=restart from begining and move previous result'};
        dlgtitle = 'About previsous kymo analysis';
        dims = [1 50];
        definput = {num2str(previousRes)};
        answer = inputdlg(prompt,dlgtitle,dims,definput);
        previousRes=str2double(answer{1});
        if (previousRes==1)
            dirGen=lst_KymoF(end).name;
            dirGen=dirGen(1:(strfind(dirGen,num2str(nK))-1));
            doLoadFig=1;
        end
        
        if (previousRes==2)
            cd ../
            pathResBak=strcat(['bak_',datestr(now,'yyyy_mmm_dd_HH_MM')]);
            [status,msg,msgID] = movefile(filenameImg_woExt,pathResBak);
            cd (pathResBak);
            z=0;
            save(filenameImg_woExt,'z','-ascii')
            cd ../..
            mkdir(pathRes)
            nK=0;
            dirGen='Kymo_00';
            cd(pathRes)
        end
    else
        nK=0;
        dirGen='Kymo_00';
    end%if
end%if


%%
cd(pathImg);

%% Display max proj of movie to draw median profile
kymo_t=[];c=[];
if (doLoadFig)
    cd(pathRes)
    openfig('imgKymoPos.fig');
    %figOpen=openfig('imgKymoPos.fig','invisible');    
    cd(pathImg);
else
    switch (projectionMovieType)
        case 1
            projMovie=max(Imovie,[],3);
            Ilo=quantile(projMovie(:),0.01);
            Iup=quantile(projMovie(:),0.999);
        case 2
            projMovie=sum(Imovie,3);
            Ilo=quantile(projMovie(:),0.01);
            Iup=quantile(projMovie(:),0.9999);
            
        case 3
            projMovie=mean(Imovie,3);
            Ilo=quantile(projMovie(:),0.01);
            Iup=quantile(projMovie(:),0.9999);
        otherwise
            disp('pameters for projection')
    end
    figure(11);clf;hPlot=histogram(projMovie(:),1000);hold on
    hMAX=max(hPlot.Values);
    plot(Ilo*[1 1],[0.1 hMAX],'b');
    plot(Iup*[1 1],[0.1 hMAX],'r');
    set(gca(),'YScale','log');
    
    f=figure(1);clf;
    imshow(projMovie,[Ilo,Iup]); hold on
    %colormap(jet)
    %figure('units','normalized','outerposition',[0 0 1 1])
    f.Units='normalized';
    f.OuterPosition=[0 0 1 1];
end%if


%% Draw median profile
doNewProfile=1;

while (doNewProfile)
    
    if (doZoomBetweenImage);
        figure(1)
        title('Zoom&Move in field-of view, then press any key');
        pause();
    end%if
    
    clear track
    title('Draw line');
    [cx,cy,c,xi,yi] = improfile;
    
    if( numel(cx) == 1)
        doNewProfile=0;
        disp(strcat(['Script terminated by user with ',num2str(nK),' Kymograph.']));
    else
        nK=nK+1;
        plot(cx,cy,'k-');
        plot(xi,yi,'ko'); hold on
        %labelImg=strcat(['Kymo F-ID: ',num2str(nK)]);
        labelImg=num2str(nK);
        xL=max(xi);yL=min(yi);
        text(xL,yL,labelImg,'Color','g');
        
        clength=sqrt((xi(2)-xi(1)).^2+(yi(2)-yi(1)).^2);
        
        k=(yi(2)-yi(1))/(xi(2)-xi(1));
        theta=abs(atan(k));
        
        if k<0
            
            for  i=1:length(cx)-2
                xi2=[cx(i+1)+lineWidthKymo*sin(theta);cx(i+1)-lineWidthKymo*sin(theta)];
                yi2=[cy(i+1)+lineWidthKymo*cos(theta);cy(i+1)-lineWidthKymo*cos(theta)];
                [cx2,cy2,c] = improfile(max(Imovie,[],3),xi2,yi2);
                plot(cx2,cy2,'r-');
                track(i).x=cx2;
                track(i).y=cy2;
            end
            
        elseif k>=0
            for  i=1:length(cx)-2
                xi2=[cx(i+1)+lineWidthKymo*sin(pi-theta);cx(i+1)-lineWidthKymo*sin(pi-theta)];
                yi2=[cy(i+1)+lineWidthKymo*cos(pi-theta);cy(i+1)-lineWidthKymo*cos(pi-theta)];
                [cx2,cy2,c] = improfile(max(Imovie,[],3),xi2,yi2);
                plot(cx2,cy2,'r-');
                track(i).x=cx2;
                track(i).y=cy2;
            end
        end
        
        fprintf('Number of tracks: %g\n', size(track,2))
        cd(pathRes)
        
        
        if (nK==10)
            dirGen=dirGen(1:(end-1));
        end
        if (nK==100)
            dirGen=dirGen(1:(end-1));
        end
        
        mkdir(strcat([dirGen,num2str(nK)]))
        cd(strcat([dirGen,num2str(nK)]))
        save track_data clength track
        cd ../
        paramK=[nK,timeImageStack];
        save('parametersKymo.txt','paramK','-ascii');
        cd(pathImg)
    end%if (numel)
end%while
cd(pathRes)
xlim([0 imgMetadata.imW]);
ylim([0 imgMetadata.imH]);
title('Final')
print(1,'imgKymoPos.png','-dpng');
savefig('imgKymoPos.fig')
close(1);
%paramK=[nK,timeImageStack];
paramK=[nK,timeImageStack,nCh,ID_Ch];
save('parametersKymo.txt','paramK','-ascii'); % add info for multi channel?
% Those next lines might be obsolete now, since I add the opportunity to
% relaod previous results and move old files.
% They are not doing bad things, so I let them here for the moment.
lstKDir=dir('Kymo_*');
if (nK<numel(lstKDir))    
    disp('/!\ previous Kymo folder were already created before running the script!');
    disp('You should remove:');
    for iiK=nK+1:numel(lstKDir)
        disp(lstKDir(iiK).name)
    end%for
end%if
cd(pathImg);
disp('================== END (1) ==================');

end%function