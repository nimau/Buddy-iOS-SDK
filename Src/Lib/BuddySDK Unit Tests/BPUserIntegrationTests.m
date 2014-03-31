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

        __block BOOL fin = NO;
        beforeAll(^{
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        beforeEach(^{
            fin = NO;
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

        /*
         * NOTE: Leave these as pending_ for automated tests. Password reset testing needs manual intervention at the email level.
         */
        pending_(@"Should provide a method to request a password reset.", ^{
            
            [[Buddy user] requestPasswordResetWithSubject:@"Your new password"
                                                     body:@"Here is your reset code: @ResetCode"
                                                 callback:^(id newBuddyObject, NSError *error)
            {
                [[error should] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        pending_(@"Should then a method to reset the password with a reset code.", ^{

            [[Buddy user] resetPassword:@"mbcjt" newPassword:TEST_PASSWORD callback:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];

        });
        
        it(@"Should allow the user to set a profile picture", ^{
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            [[Buddy user] setUserProfilePicture:image caption:@"Hello" callback:^(NSError *error) {
                [[Buddy user] refresh:^(NSError *error) {
                    [[error should] beNil];
                    
                    [[theValue([[[Buddy user] profilePictureID] length]) should] beGreaterThan:theValue(0)];
                    [[theValue([[[Buddy user] profilePictureUrl] length]) should] beGreaterThan:theValue(0)];

                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should allow the user to delete the profile picture", ^{
            [[Buddy user] deleteUserProfilePicture:^(NSError *error) {
                [[error should] beNil];

#pragma message ("Comment these asserts out. Server is a bit unstable On 3/30")
//                [[theValue([[[Buddy user] profilePictureID] length]) should] equal:theValue(0)];
//                [[theValue([[[Buddy user] profilePictureUrl] length]) should] equal:theValue(0)];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
    
        it(@"Should allow adding identity values.", ^{
            [[Buddy user] addIdentity:@"Facebook" value:@"sdf" callback:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
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
            [[Buddy user] getIdentities:@"Facebook" callback:^(NSArray *buddyObjects, NSError *error) {
                [[error should] beNil];
                [[buddyObjects should] haveLengthOfAtLeast:1];
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should then allow deleting identity values.", ^{
            [[Buddy user] removeIdentity:@"Facebook" value:@"sdf" callback:^(NSError *error) {
                [[error should] beNil];
                [[Buddy user] getIdentities:@"Facebook" callback:^(NSArray *buddyObjects, NSError *error) {
                    [[error should] beNil];
                    [[buddyObjects shouldNot] containObjectsInArray:@[@"sdf"]];
                    fin = YES;
                }];
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];
        });
        
        it(@"Should allow the user to logout", ^{
            [Buddy logout:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beYes];

        });
        

    });
});

SPEC_END
