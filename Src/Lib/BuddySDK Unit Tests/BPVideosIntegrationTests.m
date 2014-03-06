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
#define kKW_DEFAULT_PROBE_TIMEOUT 10.0

SPEC_BEGIN(BuddyVideosSpec)

describe(@"BPVideosIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        //__block BPAlbum *tempAlbum;
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
        
        it(@"Should allow you to retrieve a specific video.", ^{
        });
        
        it(@"Should allow you to modify a video.", ^{
        });
        
        it(@"Should allow you to delete a video.", ^{
        });
    });
});

SPEC_END
