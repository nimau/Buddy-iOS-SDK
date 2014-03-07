//
//  CheckinIntegrationTests.m
//  BuddySDK
//
//  Created by Erik Kerber on 12/2/13.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"
#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 20.0

SPEC_BEGIN(BuddyVideosSpec)

describe(@"BPVideosIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPVideo *tempVideo;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow you create a video.", ^{
            
            __block BOOL fin = NO;
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *videoPath = [bundle pathForResource:@"1" ofType:@"mp4"];
            NSData *video = [NSData dataWithContentsOfFile:videoPath];
            
            [[Buddy videos] addVideo:video describeVideo:^(id<BPVideoProperties> videoProperties) {
                videoProperties.title = @"That cliche bunny video.";
            } callback:^(id newBuddyObject, NSError *error) {
                tempVideo = newBuddyObject;
                [[theValue(tempVideo.contentLength) should] beGreaterThan:theValue(1)];
                [[tempVideo.contentType should] equal:@"video/mp4"];
                [[tempVideo.signedUrl shouldEventually] haveLengthOfAtLeast:1];
        
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
            
        });
        
        it(@"Should allow you to retrieve a video.", ^{
            __block BPVideo *retrievedVideo;
            __block BOOL fin = NO;

            [[Buddy videos] getVideo:tempVideo.id callback:^(id newBuddyObject, NSError *error) {
                retrievedVideo = newBuddyObject;
                
                [[retrievedVideo shouldNot] beNil];
                [[retrievedVideo.id should] equal:tempVideo.id];
                
                [[expectFutureValue(retrievedVideo.contentType) shouldEventually] equal:tempVideo.contentType];
                [[expectFutureValue([retrievedVideo.signedUrl componentsSeparatedByString:@"?"][0]) shouldEventually] equal:[tempVideo.signedUrl componentsSeparatedByString:@"?"][0]];
                [[expectFutureValue(retrievedVideo.title) shouldEventually] equal:tempVideo.title];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        it(@"Should allow you to modify a video.", ^{
            
            __block BPVideo *secondVideo;
            
            tempVideo.title = @"Modified title";
            
            [tempVideo save:^(NSError *error) {
                [[error should] beNil];
                [[Buddy videos] getVideo:tempVideo.id callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNil];
                    secondVideo = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(secondVideo) shouldEventually] beNonNil];
            [[expectFutureValue(secondVideo.title) shouldEventually] equal:@"Modified title"];
        });
        
        it(@"Should allow you to delete a video.", ^{
            __block BOOL fin = NO;

            [tempVideo deleteMe:^(NSError *error) {
                [[error should] beNil];
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    });
});

SPEC_END
