function [ PDFCollectorFinal,DescCollectorFinal] = RemoveRepeatedPDF(PDFCollectorCell, DescCollectorCell,DetectConfig)
    LayerNum             = size(DetectConfig.PDFRList,2); 
    PDFCollectorCellTem  = PDFCollectorCell;
    DescCollectorCellTem = DescCollectorCell;
    FeatNum              = GetFeatureNumber(PDFCollectorCell);
    PDFListCell          = cell(FeatNum,1);
    PDFCollectorFinal    = zeros(FeatNum,3);
    DescCollectorFinal   = zeros(FeatNum,128);
    MatchedNum           = LayerNum*(LayerNum-1)/2;
    counter              = 0;   % Count final PDF number.
    for i = 1:MatchedNum 
        CurPDFCollector  = PDFCollectorCellTem{i};  % Current PDF collector.
        CurDescCollector = DescCollectorCellTem{i}; % Current descriptor.
        PDFNum           = size(CurPDFCollector,1);
        for j = 1:PDFNum   % iterate each PDF.
            CurPDF      =  CurPDFCollector(j,:);
            CurDesc     =  CurDescCollector(j,:);
            CurPDFList  =  CurPDF;
            CurDescList =  CurDesc;
            counter     = counter +1;
            for k = i+1:MatchedNum  % Find matching in the rest collector.
                CompPDFCollector = PDFCollectorCellTem{k};
                CompDescCollector = DescCollectorCellTem{k};
                dist   = sqrt( sum( ( CurPDF(1:2)- CompPDFCollector(:,1:2) ).^2 ,2 ) );
                [minvalue, minid] = min(dist);
                if minvalue < DetectConfig.MatchPDFCenterThresh   % TODO : add the matching of the descriptor.
                    MatchedPDF = CompPDFCollector(minid,1:3);
                    MatchedDesc = CompDescCollector(minid,:);
                    CurPDFList = [CurPDFList;MatchedPDF];   % Store the matched pdf.
                    CurDescList  = [CurDescList; MatchedDesc];
                    PDFCollectorCellTem{k}(minid,:)=[];     % Delete the stored PDF.
                    DescCollectorCellTem{k}(minid,:)=[];    % Delete the stored PDF.
                end            
            end
            PDFListCell{counter} = CurPDFList;
            PDFCollectorFinal(counter,:) = mean(CurPDFList,1);
            DescCollectorFinal(counter,:) = uint8( mean( double(CurDescList) , 1) );
        end    
    end
    PDFListCell        = PDFListCell(1:counter);
    PDFCollectorFinal  = PDFCollectorFinal(1:counter,:);
    DescCollectorFinal = DescCollectorFinal(1:counter,:);
end