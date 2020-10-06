function matches = MatchingStereoFeature( lfFeaturesLeft, lfFeaturesRight, lfDescriptorsLeft, lfDescriptorsRight ,DetectConfig) 
    DescThresh            = DetectConfig.DescMatchThresh;
    FeatNumRef            = size(lfFeaturesLeft,  2);
    lfFeaturesRightTem    = lfFeaturesRight;
    lfDescriptorsRightTem = lfDescriptorsRight;
    matches               = zeros(2,FeatNumRef); % initial the matching results.
    MatchCounter          = 0;
    for  i = 1:FeatNumRef
        FeatLocRef  =  lfFeaturesLeft(1:2,i);
        FeatDescRef =  lfDescriptorsLeft(:,i);
        
        % Select the feature candidates according to epipolar geometry.
        ValidID =  find(  abs( FeatLocRef(2) - lfFeaturesRightTem(2,:) ) < DetectConfig.MatchVThresh ); 
        
        % Get the feature descriptor of feature candiates in the right frame.
        CandidateDesc  = lfDescriptorsRightTem( :, ValidID );
        
        % Calculate the Euclidian distance between the descriptors.
        DescEucDist  = sqrt( sum( (double(FeatDescRef) - double(CandidateDesc) ).^2, 1 ) );
        
        % Find the best match for current feature.
        [ DescValue, DescID ] = sort(DescEucDist,'ascend');
        
        % check if the matching is valid.
        for j = 1: size(DescValue,2)
            CurDescValue = DescValue(j);
            CurID        = DescID(j);          
            FeatID       = ValidID(CurID);
            if (CurDescValue <= DescThresh) && ( ~ismember( FeatID, matches(2,:) ) ) % if there is valid and non-repeated match.
                MatchCounter            = MatchCounter +1; % count the valid matching times.
                matches(:,MatchCounter) = [i;FeatID];
                break;
            end
            if (CurDescValue > DescThresh)  % if the current minimal value is larger than thresh, then jump out.
                break;                
            end
        end     
         
    end     
    matches  = matches(: , 1:MatchCounter); 
end