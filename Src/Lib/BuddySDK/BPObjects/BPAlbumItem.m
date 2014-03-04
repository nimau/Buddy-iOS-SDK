//
//  BPAlbumItem.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/24/14.
//
//

#import "BPAlbumItem.h"
#import "BuddyObject+Private.h"


@implementation BPAlbumItem

@synthesize caption, albumID, itemID;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(albumID)];
    [self registerProperty:@selector(itemID)];
    [self registerProperty:@selector(caption)];
}

+ (NSString *)requestPath
{
    return @"items";
}

- (NSString *)buildRequestPath
{
    return [NSString stringWithFormat:@"albums/%@/items", self.albumID];
}

- (void)getData:(BuddyAlbumItemResponse)callback
{
    
    NSString *resource = [NSString stringWithFormat:@"%@/%@/%@", [self buildRequestPath], self.id, @"file"];
    
    [self.client GET_FILE:resource parameters:nil callback:^(id imageByes, NSError *error) {
        callback ? callback(imageByes, error) : nil;
    }];
}

- (void)getImage:(BuddyAlbumPhotoResponse)callback
{
    [self getData:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        callback ? callback(image, error) : nil;
    }];
}
@end
