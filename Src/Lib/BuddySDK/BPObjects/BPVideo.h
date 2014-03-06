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
@property (nonatomic, copy) NSString *friendlyName;
@property (nonatomic, assign) NSInteger thumbnailOffsetInSeconds;

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
