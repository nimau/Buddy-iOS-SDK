//
//  BPPictureCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/22/13.
//
//

#import "BPPictureCollection.h"
#import "BPPicture.h"
#import "BPClient.h"
#import "BuddyObject+Private.h"
#import "BuddyCollection+Private.h"
#import "BPSisterObject.h"
#import "Buddy.h"

@implementation BPPictureCollection

- (instancetype)initWithClient:(id<BPRestProvider>)client {
    self = [super initWithClient:client];
    if(self){
        self.type = [BPPicture class];
    }
    return self;
}

- (void)addPicture:(BPPicture *)picture
             image:(UIImage *)image
          callback:(BuddyCompletionCallback)callback
{
    [picture savetoServerWithImage:image callback:callback];
}

-(void)searchPictures:(DescribePicture)describePicture callback:(BuddyCollectionCallback)callback
{
    id pictureProperties= [[BPSisterObject alloc] initWithProtocol:@protocol(BPPictureProperties)];
    describePicture ? describePicture(pictureProperties) : nil;
    
    id parameters = [pictureProperties parametersFromProperties:@protocol(BPPictureProperties)];
    
    [self search:parameters callback:callback];
}

- (void)getPicture:(NSString *)pictureId callback:(BuddyObjectCallback)callback
{
    [self getItem:pictureId callback:callback];
}

@end
