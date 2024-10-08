function multi_kymo=kymo_reshape(multi_kymo,track,size_kymo)
% reshape multi kymogram fo fit with the screen size
% check if it can be improved.

ratio_WH=size(multi_kymo,2)/size(multi_kymo,1);
NUMBER_OF_KYMO =  size(track,2);
if (ratio_WH > 4) %2
    nColK=round(0.5+NUMBER_OF_KYMO*0.5);
    nRowK=round(0.5+NUMBER_OF_KYMO/nColK);
    %             nColK=round(0.5+ratio_WH * (4/3));
    %             nRowK=round(0.5+NUMBER_OF_KYMO/nColK);
    %             nRowK=round(0.5+ratio_WH / (4/3));
    %             nColK=round(0.5+NUMBER_OF_KYMO/nRowK);
    indexK=[0:nColK:NUMBER_OF_KYMO];if( indexK(end)~=NUMBER_OF_KYMO);indexK=[indexK,NUMBER_OF_KYMO];end;
    %indexK=indexK*(1+size(kymo,2));indexK(1)=[];
    indexK=indexK*(1+size_kymo(2));indexK(1)=[];
    indexKij=[1,(1+indexK(1:end-1));indexK(1:end-1),indexK(end)]';
    multi_kymo_reshape=[];
    for iRowK=1:(nRowK-1)
        multi_kymo_reshape=[multi_kymo_reshape;multi_kymo(:,indexKij(iRowK,1):indexKij(iRowK,2))];
        multi_kymo_reshape=[multi_kymo_reshape;NaN(1,size(multi_kymo_reshape,2))];
    end%for
    zKymo=multi_kymo(:,indexKij(end,1):indexKij(end,2));
    zKymoC=NaN(size(multi_kymo,1),size(multi_kymo_reshape,2)-size(zKymo,2));
    multi_kymo_reshape=[multi_kymo_reshape;zKymo,zKymoC];
    multi_kymo=multi_kymo_reshape;
end
end%function