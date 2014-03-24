//
//  BPMetadataItem.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/4/14.
//
//

#import "BPCoordinate.h"
#import "BPDateRange.h"
#import "BuddyObject.h"

@protocol BPMetadataProperties <NSObject>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic, copy) NSString *keyPrefix;
@property (nonatomic, strong) BPCoordinateRange *locationRange;
@property (nonatomic, strong) BPDateRange *created;
@property (nonatomic, strong) BPDateRange *modified;
#pragma message("Fix circular dependency")
//@property (nonatomic, assign) BuddyPermissions permissions;

@end
@class BPMetadataItem;

typedef void(^SearchMetadata)(id<BPMetadataProperties>metadataSearchProperties);
typedef void(^BPMetadataCallback)(BPMetadataItem *metadata, NSError *error);

@interface BPMetadataItem : NSObject<BPMetadataProperties>
- (instancetype)initBuddyWithResponse:(id)response;
@end

