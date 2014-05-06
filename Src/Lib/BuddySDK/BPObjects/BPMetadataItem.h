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
#import "BPPermissions.h"

@protocol BPMetadataProperties <NSObject>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic, copy) NSString *keyPrefix;
@property (nonatomic, readonly, strong) BPCoordinateRange *locationRange;
@property (nonatomic, readonly, strong) BPDateRange *created;
@property (nonatomic, readonly, strong) BPDateRange *modified;
@property (nonatomic, assign) BPPermissions permissions;

@end

@protocol BPMetadataCollectionProperties <NSObject>

@property (nonatomic, strong) NSDictionary *values;
@property (nonatomic, assign) BPPermissions permissions;

@end

@class BPMetadataItem;

typedef void(^DescribeMetadata)(id<BPMetadataProperties>metadataProperties);
typedef void(^DescribeMetadataCollection)(id<BPMetadataCollectionProperties>metadataProperties);
typedef void(^SearchMetadata)(id<BPMetadataProperties>metadataSearchProperties);
typedef void(^BPMetadataCallback)(BPMetadataItem *metadata, NSError *error);

@interface BPMetadataItem : NSObject<BPMetadataProperties>
- (instancetype)initBuddyWithResponse:(id)response;
@end

