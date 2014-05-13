//
//  BuddyObject+Private.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "BuddyObject.h"
#import "BPRestProvider.h"

@interface BuddyObject (Private)

- (instancetype)initBuddyWithClient:(id<BPRestProvider>)client;
- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProvider>)rest;
- (instancetype)initForCreation;

- (NSDictionary *)buildUpdateDictionary;
- (void)registerProperties;

+ (NSDictionary *)baseEnumMap;
+ (NSDictionary *)enumMap;

// Deprecated
+ (void)createFromServerWithParameters:(NSDictionary *)parameters client:(id<BPRestProvider>)client callback:(BuddyObjectCallback)callback;

- (void)savetoServer:(BuddyCompletionCallback)callback;
- (void)savetoServerWithSupplementaryParameters:(NSDictionary *)extraParams callback:(BuddyCompletionCallback)callback;

@end
