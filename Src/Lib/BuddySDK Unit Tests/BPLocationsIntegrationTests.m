//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import "BPLocation.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BuddyLocationsSpec)

describe(@"BPLocationIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPLocation *tempLocation;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [Buddy setLocationEnabled:YES];

            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow you create a location.", ^{
            [[Buddy locations] addLocation:^(id<BPLocationProperties> locationProperties) {
                locationProperties.name = @"House of Pain";
                locationProperties.description = @"Where the pain is brought";
                locationProperties.location = BPCoordinateMake(1.2, 3.4);
                locationProperties.category = @"So much pain";
            } callback:^(id newBuddyObject, NSError *error) {
                [[error should] beNil];
                tempLocation = newBuddyObject;
            }];
            
            [[expectFutureValue(tempLocation) shouldEventually] beNonNil];
        });
        
        it(@"Should allow tracking a user's location", ^{
            
        });
        
        pending_(@"Should allow you to search for a location.", ^{
            __block NSArray *locations;
            [[Buddy locations] findLocation:^(id<BPLocationProperties,BPSearchProperties> locationProperties) {
                locationProperties.range = BPCoordinateRangeMake(1.2345, 3.4567, 100);
                locationProperties.limit = 9;
            } callback:^(NSArray *buddyObjects, NSError *error) {
                [[error should] beNil];
                locations = buddyObjects;
            }];
            
            [[expectFutureValue(locations) shouldEventually] beNonNil];
            [[expectFutureValue(theValue([locations count])) shouldEventually] beGreaterThan:theValue(0)];
        });
        
    });
});

SPEC_END
