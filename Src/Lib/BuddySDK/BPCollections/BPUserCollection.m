//
//  BPUserCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/20/14.
//
//

#import "BPUserCollection.h"
#import "BuddyCollection+Private.h"
#import "NSArray+BPSugar.h"
#import "BPSisterObject.h"

@implementation BPUserCollection

-(instancetype)initWithClient:(id<BPRestProvider>)client
{
    self = [super initWithClient:client];
    if(self){
        self.type = [BPUser class];
    }
    return self;
}

-(void)getUsers:(BuddyCollectionCallback)callback
{
    [self getAll:callback];
}

- (void)getUser:(NSString *)userId callback:(BuddyObjectCallback)callback
{
    [self getItem:userId callback:callback];
}

- (void)searchUsers:(SearchUsers)searchUsers callback:(BuddyCollectionCallback)callback
{
    id searchPropertiers = [[BPSisterObject alloc] initWithProtocols:@[@protocol(BPUserProperties), @protocol(BPSearchProperties)]];
    searchUsers ? searchUsers(searchPropertiers) : nil;
    
    id parameters = [searchPropertiers parametersFromProperties:@protocol(BPUserProperties)];
    
    [self search:parameters callback:callback];
}

- (void)getUserIdForIdentityProvider:(NSString *)identityProvider identityProviderId:(NSString *)identityProviderId callback:(BuddyIdCallback)callback
{
    NSDictionary *parameters = @{@"identityProviderName": identityProvider};
        
    NSString *resource = [self.requestPrefix stringByAppendingFormat:@"%@/identities/%@/%@",
                          [[self type] requestPath],
                          identityProvider,
                          identityProviderId];
    
    [self.client GET:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(json, error) : nil;
    }];
}


@end
