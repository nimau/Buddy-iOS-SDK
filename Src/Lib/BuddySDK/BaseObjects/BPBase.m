//
//  BPMetadataBase.m
//  BuddySDK
//
//  Created by Erik Kerber on 2/11/14.
//
//

#import "BPBase.h"
#import "BPEnumMapping.h"
#import "BPSisterObject.h"
#import "BPMetadataItem.h"
#import "JAGPropertyConverter.h"

@interface BPBase()<BPEnumMapping>

@end

@implementation BPBase

+ (id)convertValue:(NSString *)value forKey:(NSString *)key
{
    return nil;
}

+ (id)convertValueToJSON:(NSString *)value forKey:(NSString *)key
{
    return nil;
}

+ (NSDictionary *)mapForProperty:(NSString *)key
{
    return [self enumMap][key];
}

+ (NSDictionary *)enumMap
{
    return [self baseEnumMap];
}

+ (NSDictionary *)baseEnumMap
{
    // Return any enum->string mappings used in responses subclass.
    return @{NSStringFromSelector(@selector(readPermissions)) : @{
                     @(BPPermissionsApp) : @"App",
                     @(BPPermissionsUser) : @"User",
                     },
             NSStringFromSelector(@selector(writePermissions)) : @{
                     @(BPPermissionsApp) : @"App",
                     @(BPPermissionsUser) : @"User",
                     }};
}

- (NSString *)metadataPath:(NSString *)key
{
    return @"";
}

- (void)setMetadata:(DescribeMetadata)describeMetadata callback:(BuddyCompletionCallback)callback
{
    id metadataProperties = [[BPSisterObject alloc] initWithProtocol:@protocol(BPMetadataProperties)];
    describeMetadata ? describeMetadata(metadataProperties) : nil;
    
    id parameters = (NSMutableDictionary *)[metadataProperties parametersFromProperties:@protocol(BPMetadataProperties)];
    
    if (parameters[@"permissions"]) {
        parameters[@"permissions"] = [[self class] enumMap][@"readPermissions"][parameters[@"permissions"]];
    }
    
    [self.client PUT:[self metadataPath:parameters[@"key"]] parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)setMetadataValues:(DescribeMetadataCollection)describeMetadata callback:(BuddyCompletionCallback)callback
{
    id metadataProperties = [[BPSisterObject alloc] initWithProtocol:@protocol(BPMetadataCollectionProperties)];
    describeMetadata ? describeMetadata(metadataProperties) : nil;
    
    id parameters = (NSMutableDictionary *)[metadataProperties parametersFromProperties:@protocol(BPMetadataCollectionProperties)];
    
    if (parameters[@"permissions"]) {
        parameters[@"permissions"] = [[self class] enumMap][@"readPermissions"][parameters[@"permissions"]];
    }
    
    [self.client PUT:[self metadataPath:nil] parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}


- (void)searchMetadata:(SearchMetadata)search callback:(void (^) (NSArray *buddyObjects, NSError *error))callback
{
    id searchProperty = [[BPSisterObject alloc] initWithProtocol:@protocol(BPMetadataProperties)];
    search ? search(searchProperty) : nil;
    
    id searchParameters = [searchProperty parametersFromProperties:@protocol(BPMetadataProperties)];
    
    NSString *resource = [self metadataPath:nil];
    
    [self.client GET:resource parameters:searchParameters callback:^(id json, NSError *error) {
        NSArray *results = [json[@"pageResults"] bp_map:^id(id object) {
            id metadata = [[BPMetadataItem alloc] init];
            [[JAGPropertyConverter converter] setPropertiesOf:metadata fromDictionary:object];
            return metadata;
        }];
        callback ? callback(results, error) : nil;
    }];
}

- (void)incrementMetadata:(NSString *)key delta:(NSInteger)delta callback:(BuddyCompletionCallback)callback
{
    NSString *incrementResource = [NSString stringWithFormat:@"%@/increment", [self metadataPath:key]];
    
    NSDictionary *parameters = @{@"delta": @(delta)};
    
    [self.client POST:incrementResource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)getMetadataWithKey:(NSString *)key permissions:(BPPermissions)permissions callback:(BPMetadataCallback)callback
{
    NSDictionary *parameters = @{@"permission": [[self class] enumMap][@"readPermissions"][@(permissions)]};
    
    [self.client GET:[self metadataPath:key] parameters:parameters callback:^(id metadata, NSError *error) {
        BPMetadataItem *item = [[BPMetadataItem alloc] initBuddyWithResponse:metadata];
        callback ? callback(item, error) : nil;
    }];
}

- (void)deleteMetadataWithKey:(NSString *)key permissions:(BPPermissions)permissions callback:(BuddyCompletionCallback)callback
{
    NSDictionary *parameters = @{@"permission": [[self class] enumMap][@"readPermissions"][@(permissions)]};
    [self.client DELETE:[self metadataPath:key] parameters:parameters callback:^(id metadata, NSError *error) {
        callback ? callback(error) : nil;
    }];
}


@end
