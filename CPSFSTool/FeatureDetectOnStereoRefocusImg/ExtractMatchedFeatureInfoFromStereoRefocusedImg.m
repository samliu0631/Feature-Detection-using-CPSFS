% Extract GCenter, DescCenter, Delta from the two stereo(left and right) Refocused Image.
function [ GCenter, DescCenter, Delta ] = ExtractMatchedFeatureInfoFromStereoRefocusedImg(RfImgLeft ,RfImgRight , peakThresh, DetectConfig)
    % Extract SIFT features.
    [lfFeaturesLeft, lfDescriptorsLeft]   = vl_sift(im2single(RfImgLeft),'PeakThresh', peakThresh);
    [lfFeaturesRight, lfDescriptorsRight] = vl_sift(im2single(RfImgRight),'PeakThresh', peakThresh);
    
    % Matching Sift features.
    matches = MatchingStereoFeature( lfFeaturesLeft, lfFeaturesRight, lfDescriptorsLeft, lfDescriptorsRight ,DetectConfig);
    
    % visual validation
    %figure;imshow(RfImgLeft);hold on;plot(lfFeaturesLeft(1,:),lfFeaturesLeft(2,:),'r*'); hold off;
    %figure;imshow(RfImgRight);hold on;plot(lfFeaturesRight(1,:),lfFeaturesRight(2,:),'r*'); hold off;

    % Extract the matched pixel coorinates.
    MatchedLocLeft    = lfFeaturesLeft(1:2,matches(1,:));
    MatchedLocRight   = lfFeaturesRight(1:2,matches(2,:));
    MatchedDesLeft    = lfDescriptorsLeft(:,matches(1,:));    % Descriptor in the left refocused image.
    MatchedDesRight   = lfDescriptorsRight(:,matches(2,:));   % Descriptor in the right refoucsed image.
    
    % Calculate the Focus Score of each matched feature pair.
%     FocusScoreLeft   = CalculateFocusScore(MatchedLocLeft,RfImgLeft);
%     FocusScoreRight  = CalculateFocusScore(MatchedLocRight,RfImgRight);
    
    % store the info of each feature in each layer.
    GCenter         = (MatchedLocLeft + MatchedLocRight)/2;  % calculate the center coordinate G in the refocused image.
    DescCenter      = uint8( double(MatchedDesLeft) + double(MatchedDesRight) )/2;
    Delta           = MatchedLocLeft(1,:) - MatchedLocRight(1,:);
    
    % Select valid feature by restrict the value of Delta.   
    DeltaValidID = abs(Delta)< DetectConfig.MaxDisparity;
    Delta        = Delta(DeltaValidID);
    GCenter      = GCenter(:,DeltaValidID);
    DescCenter   = DescCenter(:,DeltaValidID);   
    
    
    
    % Show Matching results.
    if (DetectConfig.DebugFlag )
        figure; imshow(RfImgLeft);  hold on; plot( lfFeaturesLeft(1,:),  lfFeaturesLeft(2,:),'*' );  hold off;
        figure; imshow(RfImgRight); hold on; plot( lfFeaturesRight(1,:),lfFeaturesRight(2,:),'*' );  hold off;
        figure;
        MatchedLocLeft  = MatchedLocLeft(:,DeltaValidID);
        MatchedLocRight = MatchedLocRight(:,DeltaValidID);
        showMatchedFeatures(RfImgLeft,RfImgRight,MatchedLocLeft',MatchedLocRight');
    end
    
  
    
    
end




function FocusScore = CalculateFocusScore(MatchedLoc,RfImg)
    
    % Get the size of the refocused image.
    [height, width ] = size(RfImg);  % Get the pixel size of the refocused image.
    
    % compute image derivatives (for principal axes estimation)
    du               = [-1 0 1; -1 0 1; -1 0 1];
    dv               = du';
    img_du           = conv2( double(RfImg),du,'same' );
    img_dv           = conv2( double(RfImg),dv,'same' );
    img_weight       = sqrt( img_du.^2+img_dv.^2 );   % the value of gradient.
    
    % Extract the image patch and calculate focus score for each feature.
    rScore           = 5;                 % The radius of the image Patch¡£
    FeatNum          = size(MatchedLoc,2);
    FocusScore       = zeros(FeatNum,1);
    for i = 1:FeatNum
        cu              = round(MatchedLoc(1,i));  % Get the horizontal coordinate of the detected feature.
        cv              = round(MatchedLoc(2,i));  % Get the vertical coordinate of the detected feature.
        img_weight_sub  = img_weight( max(cv-rScore,1):min(cv+rScore,height),  max(cu-rScore,1):min(cu+rScore,width) );
        FocusScore(i)   = mean2(img_weight_sub);  % The sharp image patch has high focus score.
    end
   
end





