//
//  BPAlbumCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/24/14.
//
//

#import "BuddyCollection.h"
#import "BPAlbum.h"

@interface BPAlbumCollection : BuddyCollection

- (void)addAlbum:(BPAlbum *)album
        callback:(BuddyCompletionCallback)callback;

- (void)addAlbum:(NSString *)name
     withCaption:(NSString *)caption
        callback:(BuddyObjectCallback)callback __attribute__ ((deprecated));

- (void)searchAlbums:(BPSearchAlbum *)searchAlbum callback:(BuddyCollectionCallback)callback;

- (void)getAlbum:(NSString *)albumId callback:(BuddyObjectCallback)callback;
    
@end
