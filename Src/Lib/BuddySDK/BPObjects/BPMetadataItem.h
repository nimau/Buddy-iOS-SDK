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

typedef void(^SearchMetadata)(id<BPMetadataProperties>metadataSearchProperties);


@interface BPMetadataItem : NSObject<BPMetadataProperties>

@end
