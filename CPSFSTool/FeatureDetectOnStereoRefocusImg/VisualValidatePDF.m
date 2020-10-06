function VisualValidatePDF(PDFCollector, LensletGridModel, GridCoords, Img_raw)
    pdfNum = size(PDFCollector,1);
    MicImgRadius  = LensletGridModel.HSpacing/2;
    figure;imshow(Img_raw);
    hold on;
    for i = 1:pdfNum 
        CurPDF = PDFCollector(i,:);
        ProjPtsPerCorner   = ProjectPDF2Img(CurPDF, GridCoords, MicImgRadius,-1 ,0); % 这个需要后期测试。
        if  ~isempty(ProjPtsPerCorner)
         plot(ProjPtsPerCorner(:,1),ProjPtsPerCorner(:,2),'.','Markersize',30);  % Allpic 8 15  Zoom:30
        end
    end
    hold off;
    figure;imshow(Img_raw);
    hold on;
    plot(PDFCollector(:,1),PDFCollector(:,2),'*');
    hold off;
end
