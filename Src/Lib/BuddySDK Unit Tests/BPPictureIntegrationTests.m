//
//  BPPictureIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/3/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BuddyPictureSpec)

describe(@"BPPictureIntegrationSpec", ^{
    
    context(@"When a user is NOT logged in", ^{
        
        beforeAll(^{
            [BuddyIntegrationHelper bootstrapInit];
        });
        
        it(@"Should not allow them to add and describe pictures.", ^{
            __block BOOL fin = NO;

            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            [[Buddy pictures] addPicture:image describePicture:^(id<BPPictureProperties> photoProperties) {
                photoProperties.caption = @"Hello, caption!";
            } callback:^(id buddyObject, NSError *error) {
                [[error shouldNot] beNil];
                [[buddyObject should] beNil];
                [[theValue([error code]) should] equal:theValue(0x107)]; // AuthUserAccessTokenRequired = 0x107
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should not allow them to add and describe photos.", ^{
            __block BOOL fin = NO;
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            [[Buddy pictures] addPicture:image describePicture:^(id<BPPictureProperties>pictureProperties) {
                pictureProperties.caption = @"Hello, caption!";
            } callback:^(id newBuddyObject, NSError *error) {
                [[error shouldNot] beNil];
                [[newBuddyObject should] beNil];
                [[theValue([error code]) should] equal:theValue(0x107)]; // AuthUserAccessTokenRequired = 0x107
                fin = YES;
            }];
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    }),
            
    context(@"When a user is logged in", ^{
        __block BPPicture *newPicture;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow users to post pictures", ^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"test" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            [[Buddy pictures] addPicture:image describePicture:^(id<BPPictureProperties> pictureProperties) {
                pictureProperties.caption = @"Hello, caption!";
            } callback:^(id buddyObject, NSError *error) {
                newPicture = buddyObject;
            }];
            
            [[expectFutureValue(newPicture) shouldEventually] beNonNil];
            [[expectFutureValue(theValue(newPicture.contentLength)) shouldEventually] beGreaterThan:theValue(1)];
            [[expectFutureValue(newPicture.contentType) shouldEventually] equal:@"image/png"];
            [[expectFutureValue(newPicture.signedUrl) shouldEventually] haveLengthOfAtLeast:1];
            [[expectFutureValue(newPicture.caption) shouldEventually] equal:@"Hello, caption!"];

        });
        
        it(@"Should allow retrieving pictures", ^{
            __block BPPicture *secondPicture;
            [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                secondPicture = newBuddyObject;
            }];
            
            [[expectFutureValue(secondPicture) shouldEventually] beNonNil];
            [[expectFutureValue(theValue(secondPicture.contentLength)) shouldEventually] equal:theValue(newPicture.contentLength)];
            [[expectFutureValue(secondPicture.contentType) shouldEventually] equal:newPicture.contentType];
            [[expectFutureValue([secondPicture.signedUrl componentsSeparatedByString:@"?"][0]) shouldEventually] equal:[newPicture.signedUrl componentsSeparatedByString:@"?"][0]];
            [[expectFutureValue(secondPicture.caption) shouldEventually] equal:newPicture.caption];
        });
        
        it(@"Should allow modifying pictures", ^{
            __block BPPicture *secondPicture;
        
            newPicture.caption = @"Some new picture caption";
            
            [newPicture save:^(NSError *error) {
                [[error should] beNil];
                [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                    secondPicture = newBuddyObject;
                }];
            }];
            

            [[expectFutureValue(secondPicture) shouldEventually] beNonNil];
            [[expectFutureValue(secondPicture.caption) shouldEventually] equal:@"Some new picture caption"];
        });
        
        it(@"Should allow modifying a *retrieved* picture", ^{
            __block BPPicture *retrievedPicture;
            [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                retrievedPicture = newBuddyObject;
            }];
            
            [[expectFutureValue(retrievedPicture) shouldEventually] beNonNil];
            
            retrievedPicture.caption = @"Hakuna matata";
            
            [retrievedPicture save:^(NSError *error) {
                [[error should] beNil];
                retrievedPicture = nil;
                [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                    retrievedPicture = newBuddyObject;
                }];
            }];
            
            
            [[expectFutureValue(retrievedPicture) shouldEventually] beNonNil];
            [[expectFutureValue(retrievedPicture.caption) shouldEventually] equal:@"Hakuna matata"];
        });
        
        it(@"Should allow directly retrieving the image file", ^{
            __block UIImage *theImage;
            [newPicture getImage:^(UIImage *image, NSError *error) {
                theImage = image;
            }];
            
            [[expectFutureValue(theImage) shouldEventually] beNonNil];
        });
        
        it(@"Should allow searching for images", ^{
            __block NSArray *retrievedPictures;

            [[Buddy pictures] searchPictures:^(id<BPPictureProperties> pictureProperties) {
                pictureProperties.caption = @"Hakuna matata";
            } callback:^(NSArray *buddyObjects, NSError *error) {
                NSArray *p = buddyObjects;
                
                for(BPPicture *picture in p) {
                    [[picture.caption should] equal:@"Hakuna matata"];
                }
                retrievedPictures = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedPictures count])) shouldEventually] beGreaterThan:theValue(0)];
        });
        
        it(@"Should allow searching for images2", ^{
            __block NSArray *retrievedPictures;
            
            [[Buddy pictures] searchPictures:^(id<BPPictureProperties> pictureProperties) {
                pictureProperties.caption = @"Hello, caption!";
            } callback:^(NSArray *buddyObjects, NSError *error) {
                retrievedPictures = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedPictures count])) shouldEventually] equal:theValue(0)];
        });
        
        it(@"Should allow the user to delete pictures", ^{
            return;
            [newPicture deleteMe:^(NSError *error){
                [[Buddy pictures] getPicture:newPicture.id callback:^(id newBuddyObject, NSError *error) {
                    newPicture = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(newPicture) shouldEventually] beNil];
        });
        
        
    });
});

SPEC_END

