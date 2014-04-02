//
//  BPVideo.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/5/14.
//
//

#import "BPBlob.h"

@protocol BPVideoProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double thumbnailOffsetInSeconds;
@property (nonatomic, readonly, assign) NSInteger bitRate;
@property (nonatomic, readonly, copy) NSString *encoding;
@property (nonatomic, readonly, assign) double lengthInSeconds;
@property (nonatomic, readonly, copy) NSString *thumbnailID;

@end

@class BPPicture;

typedef void(^DescribeVideo)(id<BPVideoProperties>videoProperties);
typedef void(^SearchVideo)(id<BPVideoProperties, BPSearchProperties>videoSearchProperties);

@interface BPVideo : BPBlob<BPVideoProperties>

+ (void)createWithVideo:(NSData *)video
          describeVideo:(DescribeVideo)describeVideo
                 client:(id<BPRestProvider>)client
               callback:(BuddyObjectCallback)callback;

- (void)getVideo:(BuddyDataResponse)callback;

@end
