//
//  BPBaseIntegrationTests.m
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
#define kKW_DEFAULT_PROBE_TIMEOUT 20.0

SPEC_BEGIN(BuddyObjectSpec)

describe(@"BuddyObjectSpec", ^{
    context(@"With a valid buddy object", ^{
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
            NSString *imagePath = [bundle pathForResource:@"1" ofType:@"jpg"];
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
            [[expectFutureValue(secondPicture.contentType) shouldEventually] equal:@"image/png"];
            [[expectFutureValue([secondPicture.signedUrl componentsSeparatedByString:@"?"][0]) shouldEventually] equal:[newPicture.signedUrl componentsSeparatedByString:@"?"][0]];
            [[expectFutureValue(secondPicture.caption) shouldEventually] equal:newPicture.caption];
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
            [[Buddy pictures] searchPictures:nil callback:^(NSArray *buddyObjects, NSError *error) {
                retrievedPictures = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedPictures count])) shouldEventually] beGreaterThan:theValue(0)];
        });
        
        it(@"Should allow the user to delete pictures", ^{
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

