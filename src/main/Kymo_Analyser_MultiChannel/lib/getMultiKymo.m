function [multi_kymo,size_kymo]=getMultiKymo(Imovie,track)
% Get adjacent kymo and group them in a single folder.
nT=size(Imovie,3);
multi_kymo=[];
size_kymo=[0 0];
for i=1:size(track,2)
    disp(strcat(['Kymo #',num2str(i),'/',num2str(size(track,2))]));
    %disp(i);
    kymo=[];
    for k=1:nT
        c = improfile(Imovie(:,:,k), track(i).x,track(i).y);
        kymo(k,:)=c;
    end
    multi_kymo=[multi_kymo,kymo,NaN(size(kymo,1),1)];
    if (~isempty(kymo)); size_kymo=max([size_kymo;size(kymo)]);end
end

end%function