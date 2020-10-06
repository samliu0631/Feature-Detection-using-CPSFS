% calculate pdf and descriptor from two layer of refocused stereo refocused images.

function [PDFCollector,DescCollector] = CalculatePDFfromStereoRefocuedImgFeature( PairDelta,  PairGCenter,  PairDesc, PairRList,DetectConfig)
    GCenterLayer1  = PairGCenter{1};
    GCenterLayer2  = PairGCenter{2};
    FeatNumLeft    = size(GCenterLayer1,2);
    PDFCollector   = zeros(FeatNumLeft,3);    % store the plenoptic disc feature
    DescCollector  = zeros(FeatNumLeft,128);  %  store the descriptor of each feature.
    for i = 1:FeatNumLeft
        CurGcenter = GCenterLayer1(:,i);

        % find the matched feature in the second layer.
        dist   = sqrt( sum( ( CurGcenter'- GCenterLayer2' ).^2 ,2 ) );
        [minvalue, minid] = min(dist);

        % Calculate the Euclidian distance of two descriptor.
        CurGDesc   = double( PairDesc{1}(:,i) );
        CompGDesc  = double( PairDesc{2}(:,minid) ) ;
        DescDist   = sqrt( sum( ( CurGDesc - CompGDesc ).^2, 1 ) );
        
        % if find the matched feature in the second layer.
        if  (~isempty(minvalue)) && (minvalue < DetectConfig.MatchDThresh) && ( DescDist < DetectConfig.DescMultiLayerMatchTh )  % maybe the threshold for descriptor should be larger for different layer.
            % calculate plenoptic disc features for current feature.
            delta1 = PairDelta{1}(i);
            delta2 = PairDelta{2}(minid);
            R1     = PairRList(1);
            R2     = PairRList(2);
            Rf     = (delta1*R2-delta2*R1)/(delta1-delta2);

            % check the value of plenoptic disc radius.
            if  (abs(Rf) > 1) && (abs(Rf) < 20)
                
                % store the descriptor for current feature.
                DescCollector(i,:) = uint8 (  ( double( PairDesc{1}(:,i) )  +  double( PairDesc{2}(:,minid) ) )'/2  ) ;
                
                % store the 3d coordinate of the PDF.
                PDF   =  1/DetectConfig.dfixed *( CurGcenter + GCenterLayer2(:,minid) )/2;
                PDFCollector(i,:) = [PDF',Rf];
            end            

        end
    end
    % leave the nonzeros value.
    ValidID = ( sum( PDFCollector==0 , 2 ) ~=3 );
    PDFCollector = PDFCollector(ValidID,:);
    DescCollector = DescCollector(ValidID,:);

end