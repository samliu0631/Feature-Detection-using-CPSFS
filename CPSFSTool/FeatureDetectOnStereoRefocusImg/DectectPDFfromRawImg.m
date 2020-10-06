function [PDFCell,DescCell] = DectectPDFfromRawImg( PDFRList, DataPath, DefaultFileSpec_Raw,LensletGridModel, GridCoords,varargin)
    % Set parameters.
    DetectConfig.dfixed                = 1/4;%  1/2       % The ratio between the image size of refocused image and raw image. 
    % this parameter affect the detection speed significantly.
    DetectConfig.EdgeWidth             = 3;           % The edge width of micro image. The edge is not used to form refocused image.
    DetectConfig.MatchVThresh          = 1.5;         % vertical threshold(pixel) for feature matching within stereo(left and right) refocused image.
    DetectConfig.DescMatchThresh       = 200;         % descriptor threshold used to match feature within stereo(left and right) refocused image.
    
    DetectConfig.MatchDThresh          = 2;           % threshold(pixel) used to distinguish one G center from another in different layer of refocused image.
    DetectConfig.DescMultiLayerMatchTh = 300;         % descriptor threshold used to match feature within different layer of refocused image. 
    
    DetectConfig.MatchPDFCenterThresh  = DetectConfig.MatchDThresh/DetectConfig.dfixed;  %  threshold used to check the repeated PDF.
    DetectConfig.PDFRList              = PDFRList ;   %  multi layer plenoptic disc radius.
    DetectConfig.DebugFlag             = false;        % true: run the debug code, false: don't run the debug code.
    DetectConfig.ShowResultsFlag       = true;%false;
    DetectConfig.MaxDisparity          = DetectConfig.dfixed*(LensletGridModel.HSpacing/2)*8/(3*pi)* 5;  % the max disparity.
    
    if nargin ==6
       DetectConfig.dfixed  = varargin{1}.dfixed; 
    end
    
    
    % Read image info.
    [FileList_raw, BasePath_raw]   = ReadRawImgInfo(DataPath, DefaultFileSpec_Raw);    % Get image numbers and names from image lists.
    ImageNum                       = length(FileList_raw);
    
    % Start to work.
    PDFCell  = cell(ImageNum,1);
    DescCell = cell(ImageNum,1);
    for id = 1:ImageNum
        % Read the raw images.
        Img_raw      = ReadRawImg( BasePath_raw, FileList_raw, id );  % Read the raw light field image.
        
        % Extract PDF features.
        t1          = clock;
        [ PDFCollector, DescCollector ]  = ExtractPDFFeatureFromRawImage(Img_raw, LensletGridModel, GridCoords, DetectConfig);
        t2          = clock;
        RunTime     = etime(t2,t1);
        fprintf( 'Running time: %f\n', RunTime );
        
        % Visual validation throuch projecting the PDF onto raw images.
        if (DetectConfig.ShowResultsFlag)
          VisualValidatePDF(PDFCollector, LensletGridModel, GridCoords, Img_raw);
        end 
        
        % Store the PDF results.
        PDFCell{id}  = PDFCollector;
        DescCell{id} = DescCollector;
    end

end

