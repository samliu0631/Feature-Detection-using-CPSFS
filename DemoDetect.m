clc,clear
MainPath             = 'F:\²©Ê¿¿ÎÌâ\GitFlowSpace\Data';
WhitePath            = [MainPath,'\FusionData\White'];
DataPath             = [MainPath,'\FusionData\FusionRaw'];
FileSpecWhite        = '*.png';
DefaultFileSpec_Raw  = '*.png';
RoughRadius          = 32;
PDFRList             = [-3,-5,-7,-9 ];  % use multiple plenoptic disc radius to render refoucsed images. -3,-6,-9

% Get the central position of micro images from white image.
[LensletGridModel,GridCoords,ImgSize] = GetLensInfo(WhitePath, FileSpecWhite,RoughRadius);

% Extract feature from raw images.
flag1 = exist([DataPath,'\FeatureDectionResult.mat'],'file');
if flag1==1
    load([DataPath,'\FeatureDectionResult.mat'], 'PDFCell' , 'DescCell' );
else    
    [PDFCell,DescCell]   = DectectPDFfromRawImg( PDFRList, DataPath, DefaultFileSpec_Raw,LensletGridModel, GridCoords);
    save([DataPath,'\FeatureDectionResult.mat'], 'PDFCell' , 'DescCell' );
end

