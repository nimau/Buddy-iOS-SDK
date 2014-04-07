//
//  BPBlobCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/7/14.
//
//

#import "BPBlob.h"

@interface BPBlobCollection : BuddyCollection

- (void)addBlob:(NSData *)data
       describe:(DescribeBlob)describe
       callback:(BuddyObjectCallback)callback;

- (void)getBlobs:(BuddyCollectionCallback)callback;

- (void)searchBlobs:(DescribeBlob)describeBlob callback:(BuddyCollectionCallback)callback;

- (void)getBlob:(NSString *)blobId callback:(BuddyObjectCallback)callback;

@end
