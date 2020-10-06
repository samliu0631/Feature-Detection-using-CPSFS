function [PDFCollectorCell, DescCollectorCell] = CalculatePDFUsingEachLayerPair(DeltaRF, GCenterRF, DescCenterRF, DetectConfig)
    LayerNum          = size(DetectConfig.PDFRList,2);  % Get the number of layer.    
    MatchedNum        = LayerNum*(LayerNum-1)/2;  % the pair number.
    PDFCollectorCell  = cell(MatchedNum,1);
    DescCollectorCell = cell(MatchedNum,1);
    counter           = 0 ;
    for i = 1:LayerNum-1   % Only the adjacent layers are used.
        for j = i+1:LayerNum
        PairDelta   = { DeltaRF{i};   DeltaRF{j} };
        PairGCenter = { GCenterRF{i}; GCenterRF{j} };
        PairDesc    = { DescCenterRF{i}; DescCenterRF{j} };
        PairRList   = [ DetectConfig.PDFRList(i), DetectConfig.PDFRList(j) ];
        [PDFCollector,DescCollector] = CalculatePDFfromStereoRefocuedImgFeature( PairDelta,  PairGCenter,  PairDesc , PairRList, DetectConfig);
        counter  = counter +1;
        PDFCollectorCell{counter} = PDFCollector;
        DescCollectorCell{counter} = DescCollector;
        end
    end

end
