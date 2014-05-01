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

-(void)searchIdentities:(NSString *)identityProvider callback:(BuddyCollectionCallback)callback
{
    NSDictionary *parameters = @{@"identityProviderName": identityProvider};
    
#pragma message("TODO - Breaks design. Most collections query on the request path of the underlying type. Re-think.")
    
    NSString *resource = [self.requestPrefix stringByAppendingFormat:@"%@/identities",
                          [[self type] requestPath]];
    
    [self.client GET:resource parameters:parameters callback:^(id json, NSError *error) {
        NSArray *results = [json[@"pageResults"] bp_map:^id(id object) {
            return [[self.type alloc] initBuddyWithResponse:object andClient:self.client];
        }];
        callback ? callback(results, error) : nil;
    }];
}


@end
