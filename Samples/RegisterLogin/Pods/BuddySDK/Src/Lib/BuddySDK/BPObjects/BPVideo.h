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

#pragma message("Think about making these readonly with a private BPVideoProperties. Is that too much? They shouldn't be searchable")
@property (nonatomic, assign) NSInteger bitRate;
@property (nonatomic, copy) NSString *encoding;
@property (nonatomic, assign) double lengthInSeconds;
@property (nonatomic, copy) NSString *thumbnailID;

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
