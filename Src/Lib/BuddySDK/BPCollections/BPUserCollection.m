//
//  BPUserCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/20/14.
//
//

#import "BPUserCollection.h"
#import "BuddyCollection+Private.h"
#import "BPUser.h"
#import "NSArray+BPSugar.h"

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

-(void)getUserIdForIdentityProvider:(NSString *)identityProvider identityProviderId:(NSString *)identityProviderId callback:(BuddyIdCallback)callback
{
    NSDictionary *parameters = @{@"identityProviderName": identityProvider};
    
#pragma message("TODO - Breaks design. Most collections query on the request path of the underlying type. Re-think.")
    
    NSString *resource = [self.requestPrefix stringByAppendingFormat:@"%@/identities/%@/%@",
                          [[self type] requestPath],
                          identityProvider,
                          identityProviderId];
    
    [self.client GET:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(json, error) : nil;
    }];
}


@end
