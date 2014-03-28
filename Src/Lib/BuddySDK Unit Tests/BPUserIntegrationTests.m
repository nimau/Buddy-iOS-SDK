//
//  BPUserTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BPUserIntegrationSpec)

describe(@"BPUser", ^{
    context(@"When a user is logged in", ^{
        __block NSString *resetCode;    

        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should be allow modifying and saving", ^{
        
            NSDate *randomDate = [BuddyIntegrationHelper randomDate];
            NSLog(@"Created New Random Date for DOB: %@",randomDate);
            
            NSString *randomNameFirst = [BuddyIntegrationHelper randomString:10];
            NSLog(@"Created New Random First Name: %@",randomNameFirst);
            
            NSString *randomNameLast = [BuddyIntegrationHelper randomString:10];
            NSLog(@"Created New Random Last Name: %@",randomNameLast);

            if (![Buddy user]) {
                NSLog(@"Buddy User is nil");
            }
            
            NSLog(@"Initial DOB: %@", [Buddy user].dateOfBirth);
            NSLog(@"Initial First Name: %@:",[Buddy user].firstName);
            NSLog(@"Initial Last Name: %@:",[Buddy user].lastName);
            
            [Buddy user].dateOfBirth = randomDate;
            [Buddy user].firstName = randomNameFirst;
            [Buddy user].lastName = randomNameLast;
            
            NSLog(@"New DOB: %@", [Buddy user].dateOfBirth);
            
            [[Buddy user] save:^(NSError *error) {
                if (error) {
                    fail(@"Save was unsuccessful");
                }
                [[Buddy user] refresh:^(NSError *error) {
                    NSDate *f = [Buddy user].dateOfBirth;
                    NSLog(@"3333%@", f);
                }];
            }];
            
            [[expectFutureValue([Buddy user].firstName) shouldEventually] equal:randomNameFirst];
            [[expectFutureValue([Buddy user].lastName) shouldEventually] equal:randomNameLast];
            
            [[expectFutureValue([Buddy user].dateOfBirth) shouldEventually] equal:randomDate];
        });

        it(@"Should provide a method to request a password reset.", ^{
//            {"status":400,
//            "error":"PasswordResetNotConfigured",
//            "message":"Password Reset values must be configured in the Developer Dashboard->Security",
//            "request_id":"7dc04781-41e0-483f-850c-186324a9cb29"}
            
#pragma messsage("TODO - This can be turned on/off in the dev portal (response above). Look into it.")
            [[Buddy user] requestPasswordResetWithSubject:@"Your new password"
                                                     body:@"Here is your reset code: @ResetCode"
                                                 callback:^(id newBuddyObject, NSError *error)
            {
                [[error should] beNil];
                resetCode = newBuddyObject;
            }];
            
            [[expectFutureValue(resetCode) shouldEventually] beNonNil];
        });
        
        it(@"Should then a method to reset the password with a reset code.", ^{
            __block BOOL fin = NO;

            [[Buddy user] resetPassword:resetCode newPassword:@"TODO" callback:^(NSError *error) {
                [[error should] beNil];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];

        });
        
        pending_(@"Should allow the user to set a profile picture", ^{
            
        });
        
        pending_(@"Should allow the user to delete the profile picture", ^{
            
        });
    
        it(@"Should allow adding identity values.", ^{
            __block BOOL done = NO;
            [[Buddy user] addIdentity:@"Facebook" value:@"sdf" callback:^(NSError *error) {
                [[error should] beNil];
                done = YES;
            }];
            [[expectFutureValue(theValue(done)) shouldEventually] beYes];
        });
        
        pending_(@"Should allow searching identity values", ^{
            __block NSArray *idenities;
#pragma message("Braking test. Why does this not return values when the test below does?")
            [[Buddy users] searchIdentities:@"Facebook" callback:^(NSArray *buddyObjects, NSError *error) {
               idenities = buddyObjects;
                [[buddyObjects should] haveLengthOfAtLeast:1];
            }];
            
            [[expectFutureValue(idenities) shouldEventually] beNonNil];
        });
        
        it(@"Should allow retrieving identity values.", ^{
            __block BOOL done = NO;
            [[Buddy user] getIdentities:@"Facebook" callback:^(NSArray *buddyObjects, NSError *error) {
                [[error should] beNil];
                [[buddyObjects should] haveLengthOfAtLeast:1];
                done = YES;
            }];
            [[expectFutureValue(theValue(done)) shouldEventually] beYes];
        });
        
        it(@"Should then allow deleting identity values.", ^{
            __block BOOL done = NO;
            [[Buddy user] removeIdentity:@"Facebook" value:@"sdf" callback:^(NSError *error) {
                [[error should] beNil];
                [[Buddy user] getIdentities:@"Facebook" callback:^(NSArray *buddyObjects, NSError *error) {
                    [[error should] beNil];
                    [[buddyObjects shouldNot] containObjectsInArray:@[@"sdf"]];
                    done = YES;
                }];
            }];
            [[expectFutureValue(theValue(done)) shouldEventually] beYes];
        });
        
        it(@"Should allow the user to logout", ^{
            __block BOOL done = NO;
            [Buddy logout:^(NSError *error) {
                [[error should] beNil];
                done = YES;
            }];
            
            [[expectFutureValue(theValue(done)) shouldEventually] beYes];

        });
        

    });
});

SPEC_END
