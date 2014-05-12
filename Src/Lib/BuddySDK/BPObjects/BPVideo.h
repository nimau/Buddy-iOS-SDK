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

@interface BPVideoSearch : BPBlobSearch<BPVideoProperties>

@end

@interface BPVideo : BPBlob<BPVideoProperties>

- (void)getVideo:(BuddyDataResponse)callback;

@end
