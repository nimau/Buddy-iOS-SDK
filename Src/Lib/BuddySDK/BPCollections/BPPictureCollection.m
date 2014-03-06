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

- (void)addPicture:(UIImage *)picture
   describePicture:(DescribePicture)describePicture
        callback:(BuddyObjectCallback)callback
{
    [[self type] createWithImage:picture describePicture:describePicture client:self.client callback:callback];
}

-(void)searchPictures:(DescribePicture)describePicture callback:(BuddyCollectionCallback)callback
{
    id pictureProperties= [BPSisterObject new];
    describePicture ? describePicture(pictureProperties) : nil;
    
    id parameters = [pictureProperties parametersFromProperties:@protocol(BPPictureProperties)];
    
    [self search:parameters callback:callback];
}

- (void)getPicture:(NSString *)pictureId callback:(BuddyObjectCallback)callback
{
    [self getItem:pictureId callback:callback];
}

@end
