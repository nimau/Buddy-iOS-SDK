//
//  BPAlbum.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/8/14.
//
//

#import "BPAlbum.h"
#import "BPAlbumItem.h"
#import "BPAlbumItem.h"
#import "BPAlbumItemCollection.h"
#import "BuddyObject+Private.h"
#import "BPRestProvider.h"
#import "BPCLient.h"

@interface BPAlbum()

@property (nonatomic, strong) BPAlbumItemCollection *items;
    
@end

@implementation BPAlbum

@synthesize name = _name;
@synthesize caption = _caption;

- (instancetype)initBuddyWithClient:(id<BPRestProvider>)client {
    self = [super initBuddyWithClient:client];
    if(self)
    {
        [self registerProperty:@selector(name)];
        [self registerProperty:@selector(caption)];
        _items = [[BPAlbumItemCollection alloc] initWithAlbum:self andClient:client];
    }
    return self;
}

- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProvider>)rest {
    self = [super initBuddyWithResponse:response andClient:rest];
    if(self)
    {
        [self registerProperty:@selector(name)];
        [self registerProperty:@selector(caption)];
        _items = [[BPAlbumItemCollection alloc] initWithAlbum:self andClient:rest];
    }
    return self;
}

static NSString *albums = @"albums";
+(NSString *) requestPath{
    return albums;
}

- (void)addItemToAlbum:(id<BPAlbumItem>)albumItem caption:(NSString *)caption callback:(BuddyObjectCallback)callback
{
    [self addItemIdToAlbum:[albumItem id] caption:caption callback:callback];
}

- (void)addItemIdToAlbum:(NSString *)itemId caption:(NSString *)caption callback:(BuddyObjectCallback)callback
{
    __weak id<BPRestProvider> weakClient = self.client;
    
    [self.items addAlbumItem:itemId withCaption:caption callback:^(id json, NSError *error) {
        BPAlbumItem *newItem = [[BPAlbumItem alloc] initBuddyWithResponse:json andClient:weakClient];
        callback ? callback(newItem, error) : nil;
    }];
}

- (void)searchAlbumItems:(DescribeAlbumItem)describe callback:(BuddyCollectionCallback)callback
{
    [self.items searchAlbumItems:describe callback:callback];
}

- (void)getAlbumItem:(NSString *)itemId callback:(BuddyObjectCallback)callback
{
    [self.items getAlbumItem:itemId callback:callback];
}

@end
