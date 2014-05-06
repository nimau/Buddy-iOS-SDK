//
//  BPAlbumItem.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/24/14.
//
//

#import "BuddyObject.h"

@interface BPAlbumItemContainer : BuddyObject

@property (nonatomic, readonly, copy) NSString *albumID;
@property (nonatomic, readonly, copy) NSString *itemID;

@end
