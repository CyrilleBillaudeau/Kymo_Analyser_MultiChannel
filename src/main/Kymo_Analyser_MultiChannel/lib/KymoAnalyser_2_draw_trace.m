function KymoAnalyser_2_draw_trace()
%% Version_date: 20230404 CB ProCeD/Micalis/INRAE
% Comments: the current version is adapted from version '20201127 CB
% ProCeD/Micalis/INRAE' to take into account acquisition with 2 channels.
% The goal is to compare kymographs generated using two fluorescent markers
% (in Channel #1 and #2), quantify speed on each kymographs.

%% Data loading
clear all;
[ImovieCh,filenameImg,pathImg,imgMetadata,infoImg,nCh]=loadImageSequence();

if (imgMetadata.pixelSize>0)
    pixelSize=imgMetadata.pixelSize;
else
    %% Parameters
    pixelSize=64;%
    prompt = {'Pixel size in image (nm)'};
    dlgtitle = 'Image metadata';
    dims = [1 50];
    definput = {num2str(pixelSize)};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    pixelSize=str2double(answer{1});
    clear answer definput dims dlgtitle prompt;
end

filenameImg_woExt=filenameImg(1:(max(strfind(filenameImg,'.'))-1));
cd('_results_Kymo');
if exist(filenameImg_woExt,'dir')==0
    disp('Results folder not created! End of script');
    return;
end%if
pathRes=strcat(['_results_Kymo',filesep,filenameImg_woExt]);
cd(pathImg);
cd(pathRes);

dirGen='Kymo_00';
paramK=load('parametersKymo.txt');
nK=paramK(1);
timeImageStack=paramK(2);
if (nCh>1);nCh=paramK(3);ID_Ch=paramK(4);end

nGrp=0;
if (timeImageStack<0.5)
    nGrp=0.5/timeImageStack;
    timeImageStack_0=timeImageStack;
    timeImageStack=0.5;
end

if (nGrp>0)
    nT=imgMetadata.frames;
    disp('FPS is too high. Image will be sum to get 2FPS')
    indexGrp=[1:nGrp:nT];
    nT_temp=numel(indexGrp)-1;
    ImovieProj=NaN(imH,imW,nT_temp);
    for iT=1:nT_temp
        ImovieProj(:,:,iT)=mean(Imovie(:,:,indexGrp(iT):indexGrp(iT+1)),3);
    end
    
    nT0=nT;
    nT=nT_temp;
    Imovie=ImovieProj;
end%if

for iK=1:nK
    
    if (iK==10)
        dirGen=dirGen(1:(end-1));
    end
    if (iK==100)
        dirGen=dirGen(1:(end-1));
    end
    folderKymo=strcat([dirGen,num2str(iK)]);
    cd(folderKymo)
    disp(folderKymo);
    
    if (exist('Quantif_Kymo.txt','file')~=2)
        clear track_data;
        load track_data;
        chKymo={};szKymo={};
        switch (nCh)
            case 1
                Imovie=ImovieCh{1};
                [multi_kymo,size_kymo]=getMultiKymo(Imovie,track);
                chKymo{1}=multi_kymo;
                szKymo{1}=size_kymo;
            case 2
                Imovie1=ImovieCh{1};
                Imovie2=ImovieCh{2};
                disp('Channel#1');
                [multi_kymo1,size_kymo1]=getMultiKymo(Imovie1,track);
                disp('Channel#2');
                [multi_kymo2,size_kymo2]=getMultiKymo(Imovie2,track);                
                chKymo{1}=multi_kymo1;chKymo{2}=multi_kymo2;
                szKymo{1}=size_kymo1;szKymo{2}=size_kymo2;
                % combine in a single file to qualitative
                multi_kymo=[multi_kymo1;NaN(1,size(multi_kymo1,2));multi_kymo2];
                f0=figure(100);clf;
                imshow(multi_kymo,[]); hold on
                title(folderKymo,'Interpreter','none');
                f0.Units='normalized';
                f0.OuterPosition=[0 0 1 1];
                print(100,'imgKymoMultiChannel.png','-dpng');
                close(100);
                
        end%switch
        
        % Loop over Channel        
        result_Kymo_Ch=[];
        for iCh=1:nCh
            disp(strcat(['Multi-kymo on channel #',num2str(iCh)]));
            multi_kymo=chKymo{iCh};
            size_kymo=szKymo{iCh};
            % reshape kymo for display
            multi_kymo=kymo_reshape(multi_kymo,track,size_kymo);
            
            f1=figure(1);clf;
            imshow(multi_kymo,[]); hold on
            switch nCh
                case 1
                    title(folderKymo,'Interpreter','none');
                case 2
                    title(strcat([folderKymo,' - channel #',num2str(iCh)]),'Interpreter','none');
            end%swtich
            
            f1.Units='normalized';
            f1.OuterPosition=[0 0 1 1];
            %colormap(jet)
            result_Kymo=[];
            doKymo=1;
            jK=0;
            while (doKymo)
                [cx,cy,c,xi,yi] = improfile;
                if( numel(cx) == 1)
                    doKymo=0;
                    disp('User stopped ploting Kymo');
                    %disp(strcat(['Script terminated by user with ',num2str(nK),' Kymograph.']));
                else
                    jK=jK+1;
                    plot(cx,cy,'r-');
                    plot(xi,yi,'go');
                    labelImg=strcat(['KymoID: ',num2str(jK)]);
                    xL=max(xi);yL=min(yi);
                    text(xL,yL,labelImg,'Color','g');
                    result_Kymo=[result_Kymo;max(c),((xi(2)-xi(1))*pixelSize)/((yi(2)-yi(1))*timeImageStack),(xi(1)-xi(2))>0,jK];
                    
                    fprintf('Number of track: %g\n', i)
                    fprintf('Number of traces: %g\n', jK)
                    fprintf('Speed: %g\n', result_Kymo(end,2));
                    %save track_data track clength
                    
                end%if
                %close(1);
            end%while
            
            switch nCh
                case 1
                    %save('Quantif_Kymo.txt','result_Kymo','-ascii');% track_data track clength
                    result_Kymo_Ch=[result_Kymo_Ch;result_Kymo,iCh*ones(size(result_Kymo,1),1)];
                    print(1,'imgKymo.png','-dpng');
                case 2
                    result_Kymo_Ch=[result_Kymo_Ch;result_Kymo,iCh*ones(size(result_Kymo,1),1)];
                    %save(strcat(['Quantif_Kymo_Ch',num2str(iCh),'.txt']),'result_Kymo','-ascii');% track_data track clength
                    print(1,strcat(['imgKymo_Ch',num2str(iCh),'.png']),'-dpng');
            end%switch
            close(1);
        end%for iCh
        save('Quantif_Kymo.txt','result_Kymo_Ch','-ascii');% track_data track clength chID

    end%if
    
    cd(pathImg);
    cd(pathRes);
    
end%for iK
cd(pathImg);
disp('================== END (2) ==================');

end%function