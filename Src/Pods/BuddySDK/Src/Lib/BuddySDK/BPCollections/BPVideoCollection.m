//
//  BPVideoCollection.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/5/14.
//
//

#import "BPVideoCollection.h"
#import "BPVideo.h"
#import "BPSisterObject.h"
#import "BuddyCollection+Private.h"

@implementation BPVideoCollection

- (instancetype)initWithClient:(id<BPRestProvider>)client {
    self = [super initWithClient:client];
    if(self){
        self.type = [BPVideo class];
    }
    return self;
}

- (void)addVideo:(NSData *)video
   describeVideo:(DescribeVideo)describeVideo
        callback:(BuddyObjectCallback)callback
{
    [[self type] createWithVideo:video describeVideo:describeVideo client:self.client callback:callback];
}

- (void)searchVideos:(SearchVideo)describeVideo callback:(BuddyCollectionCallback)callback;
{
    id videoProperties = [BPSisterObject new];
    describeVideo ? describeVideo(videoProperties) : nil;
    
    id parameters = [videoProperties parametersFromProperties:@protocol(BPVideoProperties)];
    
    [self search:parameters callback:callback];
}

- (void)getVideo:(NSString *)pictureId callback:(BuddyObjectCallback)callback
{
    [self getItem:pictureId callback:callback];
}

@end
