function [Imovie,ID_Ch]=selectChannelToDrawMultiKymo(ImovieCh,nCh,displayMovie)

if (nCh==2)
    Imovie1=ImovieCh{1};Imovie2=ImovieCh{2};
    nT=size(Imovie1,3);
    if (displayMovie)
        for iT=1:nT
            figure(999);clf;
            subplot(1,2,1);imshow(Imovie1(:,:,iT),[]);title('Channel1');
            subplot(1,2,2);imshow(Imovie2(:,:,iT),[]);title('Channel2');
            pause(0.05);
        end
    else
        figure(999);clf;
        subplot(2,2,1);imshow(Imovie1(:,:,1),[]);title('Channel1 / first');
        subplot(2,2,2);imshow(Imovie2(:,:,1),[]);title('Channel2 / first');
        subplot(2,2,3);imshow(Imovie1(:,:,end),[]);title('Channel1 / end');
        subplot(2,2,4);imshow(Imovie2(:,:,end),[]);title('Channel2 / end');
    end%if
    
    listCh = {'Channe1','Channel2'};
    [indx,~] = listdlg('ListString',listCh,'SelectionMode','single');
    switch indx
        case 1
            Imovie=Imovie1;
            ID_Ch=1;
        case 2
            Imovie=Imovie2;
            ID_Ch=2;
    end%switch
    close(999);
else
    Imovie=ImovieCh{1};
    ID_Ch=0;
end%if

end%function

