//
//  BPAlbum.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/8/14.
//
//

#import "BPAlbumItem.h"

@protocol BPAlbumProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *name;

@end

typedef void(^DescribeAlbum)(id<BPAlbumProperties>pictureProperties);

@interface BPAlbum : BuddyObject<BPAlbumProperties>

- (void)addItemToAlbum:(id)albumItem caption:(NSString *)caption callback:(BuddyObjectCallback)callback;

- (void)addItemIdToAlbum:(NSString *)itemId caption:(NSString *)caption callback:(BuddyObjectCallback)callback;

- (void)getAlbumItem:(NSString *)itemId callback:(BuddyObjectCallback)callback;

- (void)searchAlbumItems:(DescribeAlbumItem)describe callback:(BuddyCollectionCallback)callback;


@end