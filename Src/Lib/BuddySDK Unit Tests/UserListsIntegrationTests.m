//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import "BPCoordinate.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 4.0

SPEC_BEGIN(BPUserListSpec)

describe(@"BPUserListSpec", ^{
    context(@"When a user is logged in", ^{
        
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow creating a user list", ^{
            __block BPUserList *userList;
            [[Buddy userLists] addUserList:^(id<BPUserListProperties> userListProperties) {
                userListProperties.name = @"Erik's list";
            } callback:^(id newBuddyObject, NSError *error) {
                [[error should] beNil];
                userList = newBuddyObject;
            }];
            
            [[expectFutureValue(userList) shouldEventually] beNonNil];
        });

    });
});

SPEC_END
