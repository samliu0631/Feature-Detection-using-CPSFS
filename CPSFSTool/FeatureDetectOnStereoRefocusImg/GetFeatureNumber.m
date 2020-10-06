function FeatNum = GetFeatureNumber(PDFCollectorCell)
    CollectorNum  = size(PDFCollectorCell,1);
    FeatNum = 0;
    for i = 1:CollectorNum
        PDFCollectorCur = PDFCollectorCell{i};
        FeatNumCur      = size(PDFCollectorCur,1);
        FeatNum         = FeatNum +FeatNumCur;        
    end
end
