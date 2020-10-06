function RfImg = CalculateRefocusedImgPDF(Img_raw,d,PDFR,LensletGridModel,GridCoords,EdgeWidth,varargin)

% input: d: size of refocused image in x or y dimension/ size of raw image in x or y dimension
    if nargin==7
        RLFlag = varargin{1};
    end        
        
    % Get the information of MLA.
    GridCoordsX  = GridCoords(:,:,1);
    GridCoordsY  = GridCoords(:,:,2);
    MicImgNum    = size(GridCoordsX(:),1);
    MicImgRadius = LensletGridModel.HSpacing/2;
    MicImgIntR   = ceil(MicImgRadius);  
    %CellRGBLensID = LensletGridModel.CellRGBLensID;
    
    % Find the best focused micro-images' type.
    
    
    
    % Assign space for Refocused image.
    RawImgHeight = size(Img_raw,1);
    RawImgWidth  = size(Img_raw,2);  
    RfHeight     = round(d*RawImgHeight);
    RfWidth      = round(d*RawImgWidth);
    RfImg        = zeros(RfHeight,RfWidth);    % refocused image.
    RfImgCounter = zeros(RfHeight,RfWidth);    % refocused image counter.

    % Get the pixel location mesh in refcused image.
    R               = abs(PDFR);
    PDFCircleR      = ceil(R*d*MicImgRadius);    
    Xrange          = -PDFCircleR : 1 : PDFCircleR;
    Yrange          = -PDFCircleR : 1 : PDFCircleR;
    [XX,YY]         = meshgrid(Xrange, Yrange);
    XY              = [XX(:),YY(:)];
    
    % Get the circle pixel index in refcused image.
    ValidPDFRadius  = R*d*(MicImgRadius - EdgeWidth);
    CircleIndex     = find(sqrt( sum(XY.^2,2) )< ValidPDFRadius);
    CircleXY        = XY(CircleIndex,:);
    
    % If it is used to simulate left or right refocused image.
    CircleXYMic     = CircleXY./(-d*PDFR);
    if nargin==7

        if RLFlag ==1
            LeftID      = CircleXYMic(:,1) < 0;
            CircleIndex = CircleIndex(LeftID);
            CircleXY    = XY(CircleIndex,:);
        end
        
        if RLFlag ==2
            RightID     = CircleXYMic(:,1) > 0;
            CircleIndex = CircleIndex(RightID);
            CircleXY    = XY(CircleIndex,:);
        end  
        
    end
    
    for j= 1:MicImgNum
        
        % Check the micro-image's  type in order to use the best-focused
        % micro-images.               
%         if ~( ismember(j,CellRGBLensID{1}) || ismember(j,CellRGBLensID{2})  )
%             continue;
%         end
%         if ~ ismember(j,CellRGBLensID{1})
%             continue;
%         end

        % Calculate the relavent pixel coordinates in micro-image.
        MicImgCenter = [GridCoordsX(j),GridCoordsY(j)];
        PatchXX      = MicImgCenter(1) + XX./(-d*PDFR);
        PatchYY      = MicImgCenter(2) + YY./(-d*PDFR);
        
        % Extract the image patch from raw image.
        MicImgPatchRadius = MicImgIntR+2;     % slightly large  in order to garantee the correctness of  following interplation.
        PatchLeftUp       = round(MicImgCenter)-[MicImgPatchRadius,MicImgPatchRadius];
        PatchRightDown    = round(MicImgCenter)+[MicImgPatchRadius,MicImgPatchRadius];       
        
        if (PatchLeftUp(1)>0) && (PatchLeftUp(2)>0)  && (PatchRightDown(1)<RawImgWidth) && (PatchRightDown(2)< RawImgHeight)
            PatchImgOrigin      = Img_raw( PatchLeftUp(2) : PatchRightDown(2), PatchLeftUp(1) : PatchRightDown(1) );
            OriginX             = PatchLeftUp(1) : PatchRightDown(1);
            OriginY             = PatchLeftUp(2) : PatchRightDown(2);
            [OriginXX,OriginYY] = meshgrid(OriginX,OriginY);            
            PatchImg            = interp2(OriginXX,OriginYY,PatchImgOrigin,PatchXX,PatchYY,'linear'); 
            
            % Extract the circle part.         
            PatchImgCircle  = PatchImg(CircleIndex);                     
            
            % Calculate the location in Refocused Image.
            PixLocPx     = d*MicImgCenter(1) + CircleXY(:,1);
            PixLocPy     = d*MicImgCenter(2) + CircleXY(:,2);
            
            PixLocPx     = round(PixLocPx);
            PixLocPy     = round(PixLocPy);
            LinearInd    = int32(PixLocPx.*RfHeight+PixLocPy);
            
            % Boundary check.
            ValidID_X        = ( PixLocPx < RfWidth ) & ( PixLocPx > 0 );
            ValidID_Y        = ( PixLocPy < RfHeight ) & ( PixLocPy > 0 );
            ValidID          =  find( ( ValidID_X & ValidID_Y ) ==1 );
           
            % Store the pixel value.
            RfImg(LinearInd(ValidID)) = RfImg(LinearInd(ValidID ))+PatchImgCircle(ValidID);
            
            % Store the pixel counter.
            ValidPixNum = size(PatchImgCircle(ValidID),1);
            RfImgCounter(LinearInd(ValidID)) = RfImgCounter(LinearInd(ValidID ))+ones(ValidPixNum,1);
        end
    end
     
    RfImg =RfImg./RfImgCounter;

end