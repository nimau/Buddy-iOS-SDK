//
//  BPUserListCollection.m
//  BuddySDK
//
//  Created by Erik Kerber on 2/26/14.
//
//

#import "BPUserListCollection.h"
#import "BPSisterObject.h"
#import "BPUserList.h"

@implementation BPUserListCollection

- (instancetype)initWithClient:(id<BPRestProvider>)client {
    self = [super initWithClient:client];
    if(self){
        self.type = [BPUserList class];
    }
    return self;
}

- (void)addUserList:(DescribeUserList)describe
        callback:(BuddyObjectCallback)callback
{
    id userList= [[BPSisterObject alloc] parametersFromProperties:@protocol(BPUserListProperties)];
    describe ? describe(userList) : nil;
    
    id parameters = [userList parametersFromProperties:@protocol(BPUserListProperties)];
    
    [self.type createFromServerWithParameters:parameters client:self.client callback:callback];
}

@end
