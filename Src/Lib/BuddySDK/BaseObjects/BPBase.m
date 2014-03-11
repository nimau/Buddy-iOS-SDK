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
                     @(BuddyPermissionsApp) : @"App",
                     @(BuddyPermissionsUser) : @"User",
                     },
             NSStringFromSelector(@selector(writePermissions)) : @{
                     @(BuddyPermissionsApp) : @"App",
                     @(BuddyPermissionsUser) : @"User",
                     }};
}

- (NSString *)metadataPath:(NSString *)key
{
    return @"";
}

- (void)setMetadataWithKey:(NSString *)key andString:(NSString *)value permissions:(BuddyPermissions)permissions callback:(BuddyCompletionCallback)callback
{
    NSDictionary *parameters = @{@"value": BOXNIL(value),
                                 @"permission": [[self class] enumMap][@"readPermissions"][@(permissions)]};
    
    [self.client PUT:[self metadataPath:key] parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)setMetadataWithKey:(NSString *)key andInteger:(NSInteger)value permissions:(BuddyPermissions)permissions callback:(BuddyCompletionCallback)callback
{
#pragma message("Convert to 'convertValue' method from enum map")
    
    NSDictionary *parameters = @{@"value": @(value),
                                 @"permission": [[self class] enumMap][@"readPermissions"][@(permissions)]};
    
    [self.client PUT:[self metadataPath:key] parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)setMetadataWithKeyValues:(NSDictionary *)keyValuePaths permissions:(BuddyPermissions)permissions callback:(BuddyCompletionCallback)callback
{
    NSDictionary *parameters = @{@"values": keyValuePaths,
                                 @"permission": [[self class] enumMap][@"readPermissions"][@(permissions)]};

    [self.client PUT:[self metadataPath:nil] parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)searchMetadata:(SearchMetadata)search callback:(BuddyCollectionCallback)callback
{
    id searchProperty = [BPSisterObject new];
    search ? search(searchProperty) : nil;
    
    id searchParameters = [searchProperty parametersFromProperties:@protocol(BPMetadataProperties)];
    
    NSString *resource = [self metadataPath:nil];
    
    [self.client GET:resource parameters:searchParameters callback:^(id json, NSError *error) {
        NSArray *results = [json[@"pageResults"] map:^id(id object) {
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

- (void)getMetadataWithKey:(NSString *)key permissions:(BuddyPermissions)permissions callback:(BuddyObjectCallback)callback
{
    NSDictionary *parameters = @{@"permission": [[self class] enumMap][@"readPermissions"][@(permissions)]};
    
    [self.client GET:[self metadataPath:key] parameters:parameters callback:^(id metadata, NSError *error) {
        BPMetadataItem *item = [[BPMetadataItem alloc] initBuddyWithResponse:metadata];
        callback ? callback(item, error) : nil;
    }];
}

- (void)deleteMetadataWithKey:(NSString *)key permissions:(BuddyPermissions)permissions callback:(BuddyCompletionCallback)callback 
{
    NSDictionary *parameters = @{@"permission": [[self class] enumMap][@"readPermissions"][@(permissions)]};
    [self.client DELETE:[self metadataPath:key] parameters:parameters callback:^(id metadata, NSError *error) {
        callback ? callback(error) : nil;
    }];
}


@end
