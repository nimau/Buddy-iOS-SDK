//
//  BPAlbumItem.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/24/14.
//
//

#import "BuddyObject.h"

// Not used for now. But may leverage the concept on BPPhoto/BPVideo
@protocol BPAlbumItem <NSObject>

@required

- (NSString *)id;

@end

@protocol BPAlbumItemProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *albumID;
@property (nonatomic, copy) NSString *itemID;
@property (nonatomic, copy) NSString *caption;

@end

typedef void(^BuddyAlbumItemResponse)(NSData *data, NSError *error);
typedef void(^BuddyAlbumPhotoResponse)(UIImage *data, NSError *error);

typedef void(^DescribeAlbumItem)(id<BPAlbumItemProperties>albumItemProperties);

@interface BPAlbumItem : BuddyObject<BPAlbumItemProperties>

- (void)getData:(BuddyAlbumItemResponse)callback;
- (void)getImage:(BuddyAlbumPhotoResponse)callback;

@end
