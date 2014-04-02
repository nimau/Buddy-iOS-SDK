//
//  BPAlbumItem.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/24/14.
//
//

#import "BPAlbumItemContainer.h"
#import "BuddyObject+Private.h"

@interface BPAlbumItemContainer()

@property (nonatomic, copy) NSString *albumID;
@property (nonatomic, copy) NSString *itemID;

@end

@implementation BPAlbumItemContainer

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(albumID)];
    [self registerProperty:@selector(itemID)];
}

+ (NSString *)requestPath
{
    return @"items";
}
@end
