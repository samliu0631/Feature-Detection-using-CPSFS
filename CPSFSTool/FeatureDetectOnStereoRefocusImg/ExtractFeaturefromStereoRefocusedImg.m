% Extract Gcenter, descriptor and disparity from rendered stereo refocused
% image.
function [GCenterRF,DescCenterRF,DeltaRF] = ExtractFeaturefromStereoRefocusedImg(Img_raw,LensletGridModel, GridCoords, DetectConfig)

    LayerNum     = size(DetectConfig.PDFRList,2);  % Get the number of layer.
    GCenterRF    = cell(LayerNum,1);  % store the G point in refocused images.
    DescCenterRF = cell(LayerNum,1);  % store the descriptors of features in each layer of refocused image.
    DeltaRF      = cell(LayerNum,1);  % store the disarity of matched features in each layer.
    peakThresh   = 0.006;             % threshold used to extract feature.

    for i = 1:LayerNum
        % get the R of the current layer.
        PDFR              = DetectConfig.PDFRList(i);          % Plenoptic disc Radius.
        
        % Calculate Refocused image.
        [ RfImgLeft, RfImgRight] = CalculateStereoRefocusedImg(Img_raw, DetectConfig.dfixed, PDFR, LensletGridModel, GridCoords, DetectConfig.EdgeWidth);    
        
        if (DetectConfig.DebugFlag )
            figure;imshow(RfImgLeft);
            figure;imshow(RfImgRight);
        end
        
        % matching the features between stereo refocused image.
        [ GCenter, DescCenter, Delta ] = ExtractMatchedFeatureInfoFromStereoRefocusedImg( RfImgLeft ,RfImgRight , peakThresh, DetectConfig );

        % Calculate PDFR using one layer.
%         M  = 3*pi/(8*LensletGridModel.HSpacing/2*DetectConfig.dfixed);
%         Rq = PDFR - Delta.*M
        
        % store the feature info result.
        GCenterRF{i}      = GCenter;
        DescCenterRF{i}   = DescCenter; 
        DeltaRF{i}        = Delta;
    end

end