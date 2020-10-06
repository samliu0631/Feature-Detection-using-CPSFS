function [ RfImgLeft, RfImgRight] = CalculateStereoRefocusedImg(Img_raw, d, PDFR, LensletGridModel, GridCoords, EdgeWidth)
    RfImgLeft    = CalculateRefocusedImgPDF( Img_raw, d, PDFR, LensletGridModel, GridCoords, EdgeWidth, 1 );
    RfImgRight   = CalculateRefocusedImgPDF( Img_raw, d, PDFR, LensletGridModel, GridCoords, EdgeWidth, 2 );
end