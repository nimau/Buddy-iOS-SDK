//
//  BPCheckinCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BuddyCollection+Private.h"
#import "BPLocationCollection.h"
#import "BPClient.h"
#import "BPLocation.h"
#import "BPSisterObject.h"

@implementation BPLocationCollection

- (instancetype)initWithClient:(id<BPRestProvider>)client{
    self = [super initWithClient:client];
    if(self){
        self.type = [BPLocation class];
    }
    return self;
}


- (void)addLocation:(DescribeLocation)describe
           callback:(BuddyObjectCallback)callback
{
    id locationProperties = [[BPSisterObject alloc] initWithProtocol:@protocol(BPLocationProperties)];
    describe ? describe(locationProperties) : nil;
    
    id parameters = [locationProperties parametersFromProperties:@protocol(BPLocationProperties)];
    
    [self.type createFromServerWithParameters:parameters client:self.client callback:callback];
}


- (void)searchLocation:(SearchLocation)search callback:(BuddyCollectionCallback)callback
{
    id locationProperties = [[BPSisterObject alloc] initWithProtocol:@protocol(BPSearchProperties)];
    search ? search(locationProperties) : nil;
    
    id parameters = [locationProperties parametersFromProperties:@protocol(BPSearchProperties)];
    
    [self search:parameters callback:callback];
}

@end
