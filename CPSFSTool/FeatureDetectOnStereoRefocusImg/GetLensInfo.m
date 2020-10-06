function [LensletGridModel,GridCoords,ImgSize] = GetLensInfo(WhitePath, FileSpecWhite,RoughRadius)
    flag1 = exist([WhitePath,'/lensmodel.mat'],'file');
    if flag1==2
        load([WhitePath,'/lensmodel'], 'LensletGridModel', 'GridCoords','ImgSize');
    else
        [LensletGridModel,GridCoords,ImgSize]= GetMLAInfoByWhiteImg(WhitePath, FileSpecWhite,RoughRadius);
        save([WhitePath,'/lensmodel'], 'LensletGridModel', 'GridCoords','ImgSize');
    end
end

