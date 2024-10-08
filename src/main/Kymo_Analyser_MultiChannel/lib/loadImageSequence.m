function [ImovieCh,filenameImg,pathImg,imgMetadata,infoImg,nCh]=loadImageSequence()

[filenameImg,pathImg] = uigetfile('.tif','Select image sequence to be analyzed');
cd(pathImg);
infoImg=imfinfo(filenameImg);
imgDescription=infoImg(1).ImageDescription;
imgDescription=strsplit(imgDescription,'\n');

imgMetadata={};
imgMetadata.images=1;% default value
imgMetadata.channels=1;% default value
imgMetadata.frames=1;% default value
imgMetadata.unit_space='m';% default value
imgMetadata.imH=1;% default value
imgMetadata.imW=1;% default value

for iDesc=1:numel(imgDescription)
    curDes=imgDescription{iDesc};
    curDes=strsplit(curDes,'=');
    if numel(curDes) == 2
        switch curDes{1}
            case 'images'
                imgMetadata.images=str2num(curDes{2});
            case 'channels'
                imgMetadata.channels=str2num(curDes{2});
            case 'frames'
                imgMetadata.frames=str2num(curDes{2});
            case 'unit'
                imgMetadata.unit_space=curDes{2};
        end%switch
    end
end%for

ImovieCh={};
if (imgMetadata.channels == 2)
    nT=imgMetadata.frames;
    nCh=imgMetadata.channels;
    imH=infoImg(1).Height;
    imW=infoImg(1).Width;
    Imovie1=NaN(imH,imW,nT);
    Imovie2=NaN(imH,imW,nT);
    for iT=1:nT
        Imovie1(:,:,iT)=imread(filenameImg,2*iT-1);
        Imovie2(:,:,iT)=imread(filenameImg,2*iT);
    end
    ImovieCh{1}=Imovie1;ImovieCh{2}=Imovie2;
else
    nCh=1;
    nT=numel(infoImg);
    imH=infoImg(1).Height;
    imW=infoImg(1).Width;
    Imovie=NaN(imH,imW,nT);
    for iT=1:nT;Imovie(:,:,iT)=imread(filenameImg,iT);end
    ImovieCh{1}=Imovie;
end%for

imgMetadata.imH=infoImg(1).Height;
imgMetadata.imW=infoImg(1).Width;

if (~isempty(infoImg(1).XResolution))
    pixelSize=1000/infoImg(1).XResolution;% in nm
    imgMetadata.pixelSize=pixelSize;
else
    imgMetadata.pixelSize=-1;
end

end%function