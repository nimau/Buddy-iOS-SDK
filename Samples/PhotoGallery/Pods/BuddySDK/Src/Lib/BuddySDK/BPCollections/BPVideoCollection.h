//
//  BPVideoCollection.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/5/14.
//
//

#import "BPVideo.h"

@interface BPVideoCollection : BuddyCollection

- (void)addVideo:(NSData *)video
   describeVideo:(DescribeVideo)describeVideo
        callback:(BuddyObjectCallback)callback;

- (void)searchVideos:(SearchVideo)describeVideo callback:(BuddyCollectionCallback)callback;

- (void)getVideo:(NSString *)pictureId callback:(BuddyObjectCallback)callback;

@end
