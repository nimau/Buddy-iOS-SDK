//
//  BPBlobCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/7/14.
//
//

#import "BPBlob.h"

@interface BPBlobCollection : BuddyCollection

- (void)addBlob:(BPBlob *)blob
           data:(NSData *)data
       callback:(BuddyCompletionCallback)callback;

- (void)getBlobs:(BuddyCollectionCallback)callback;

- (void)searchBlobs:(BPBlobSearch *)searchBlobs callback:(BuddyCollectionCallback)callback;

- (void)getBlob:(NSString *)blobId callback:(BuddyObjectCallback)callback;

@end
