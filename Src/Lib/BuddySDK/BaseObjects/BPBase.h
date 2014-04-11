//
//  BPMetadataBase.h
//  BuddySDK
//
//  Created by Erik Kerber on 2/11/14.
//
//

#import "BPMetadataItem.h"
#import "BPPermissions.h"
#import "BPLocationProvider.h"

@protocol BuddyObjectProperties <NSObject>

@property (nonatomic, strong) BPCoordinate *location;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *lastModified;
@property (nonatomic, copy) NSString *defaultMetadata;
@property (nonatomic, assign) BPPermissions readPermissions;
@property (nonatomic, assign) BPPermissions writePermissions;
@property (nonatomic, assign) NSString *tag;
@property (nonatomic, copy) NSString *id;

@end

@protocol BPSearchProperties <NSObject>

@property (nonatomic, strong) BPCoordinateRange *range;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSString *pagingToken;
@property (nonatomic, assign) NSString *userID;

@end

typedef void (^BuddyCompletionCallback)(NSError *error);
typedef void (^BuddyObjectCallback)(id newBuddyObject, NSError *error);

@interface BPBase : NSObject

- (NSString *) metadataPath:(NSString *)key;

- (void)setMetadata:(DescribeMetadata)describeMetadata callback:(BuddyCompletionCallback)callback;
- (void)setMetadataValues:(DescribeMetadataCollection)describeMetadata callback:(BuddyCompletionCallback)callback;

- (void)searchMetadata:(SearchMetadata)search callback:(void (^) (NSArray *buddyObjects, NSError *error))callback;

- (void)incrementMetadata:(NSString *)key delta:(NSInteger)delta callback:(BuddyCompletionCallback)callback;

- (void)getMetadataWithKey:(NSString *)key permissions:(BPPermissions) permissions callback:(BPMetadataCallback) callback;

- (void)deleteMetadataWithKey:(NSString *)key permissions:(BPPermissions) permissions callback:(BuddyCompletionCallback)callback;

@property (nonatomic, readonly, weak) id<BPRestProvider> client;

@property (nonatomic, readonly, weak) id<BPLocationProvider> locationProvider;


@end
