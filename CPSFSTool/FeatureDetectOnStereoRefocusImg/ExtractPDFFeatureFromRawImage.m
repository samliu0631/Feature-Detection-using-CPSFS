% Extract the plenoptic disc features from single raw images.
function [PDFCollectorFinal, DescCollectorFinal ] = ExtractPDFFeatureFromRawImage(Img_raw,LensletGridModel, GridCoords, DetectConfig)

    % Extract feature info from stereo refocused images.
    [ GCenterRF, DescCenterRF, DeltaRF ] = ExtractFeaturefromStereoRefocusedImg(Img_raw,LensletGridModel, GridCoords,DetectConfig);
  
    
    % Calculate PDF using each layer pair of refocused images.
    fprintf('Calculate PDF from refocused image pairs\n');
    [PDFCollectorCell, DescCollectorCell] = CalculatePDFUsingEachLayerPair( DeltaRF,GCenterRF, DescCenterRF,DetectConfig);

    % Visual Validation
    if (DetectConfig.DebugFlag)
        for i=1:size(PDFCollectorCell,1)
            PDFCollector  = PDFCollectorCell{i};
            VisualValidatePDF(PDFCollector, LensletGridModel, GridCoords, Img_raw);
        end
    end
    
    % Average the repeated features.
    fprintf('Average the repeated PDF\n');
    [ PDFCollectorFinal,DescCollectorFinal] = RemoveRepeatedPDF(PDFCollectorCell, DescCollectorCell,DetectConfig);

end

