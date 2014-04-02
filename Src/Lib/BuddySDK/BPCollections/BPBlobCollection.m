//
//  BPBlobCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/7/14.
//
//

#import "BPBlobCollection.h"
#import "BuddyCollection+Private.h"
#import "BPSisterObject.h"
#import "BPBlob.h"

@implementation BPBlobCollection

- (instancetype)initWithClient:(id<BPRestProvider>)client {
    self = [super initWithClient:client];
    if(self){
        self.type = [BPBlob class];
    }
    return self;
}

- (void)addBlob:(NSData *)data
       describe:(DescribeBlob)describe
       callback:(BuddyObjectCallback)callback
{
    id blobProperties = [[BPSisterObject alloc] initWithProtocol:@protocol(BPBlobProperties)];
    describe ? describe(blobProperties) : nil;
    
    id parameters = [blobProperties parametersFromProperties:@protocol(BPBlobProperties)];
        
    [BPBlob createWithData:data parameters:parameters client:self.client callback:callback];
}

-(void)getBlobs:(BuddyCollectionCallback)callback
{
    [self getAll:callback];
}

- (void)getBlob:(NSString *)blobId callback:(BuddyObjectCallback)callback
{
    [self getItem:blobId callback:callback];
}

- (void)searchBlobs:(NSDictionary *)parameters callback:(BuddyCollectionCallback)callback
{
    [self search:parameters callback:callback];
}

@end
