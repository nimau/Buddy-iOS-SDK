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
#define kKW_DEFAULT_PROBE_TIMEOUT 4.0

SPEC_BEGIN(BuddyAlbumSpec)

describe(@"BPAlbumIntegrationSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPAlbum *tempAlbum;
        __block BPPicture *tempPhoto;
        __block BPAlbumItem *tempItem;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow you create an album.", ^{
            [[Buddy albums] addAlbum:@"My album" withCaption:@"Kid pictures" callback:^(id newBuddyObject, NSError *error) {
                tempAlbum = newBuddyObject;
            }];
            
            [[expectFutureValue(tempAlbum) shouldEventually] beNonNil];
            [[expectFutureValue(tempAlbum.name) shouldEventually] equal:@"My album"];
            [[expectFutureValue(tempAlbum.caption) shouldEventually] equal:@"Kid pictures"];
            
        });
        
        it(@"Should allow you to retrieve an album.", ^{
            __block BPAlbum *retrievedAlbum;
            [[Buddy albums] getAlbum:tempAlbum.id callback:^(id newBuddyObject, NSError *error) {
                retrievedAlbum = newBuddyObject;
            }];
            
            [[expectFutureValue(retrievedAlbum) shouldEventually] beNonNil];
            [[expectFutureValue(retrievedAlbum.name) shouldEventually] equal:tempAlbum.name];
            [[expectFutureValue(retrievedAlbum.caption) shouldEventually] equal:tempAlbum.caption];
        });
        
        it(@"Should allow you to search for albums.", ^{
            __block NSArray *retrievedAlbums;
            
            [[Buddy albums] searchAlbums:nil callback:^(NSArray *buddyObjects, NSError *error) {
                retrievedAlbums = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedAlbums count])) shouldEventually] beGreaterThan:theValue(0)];
        });
        
        it(@"Should allow you to modify an album.", ^{
            __block BPAlbum *retrievedAlbum;

            tempAlbum.caption = @"Some new caption";
            
            [tempAlbum save:^(NSError *error) {
                [[Buddy albums] getAlbum:tempAlbum.id callback:^(id newBuddyObject, NSError *error) {
                    retrievedAlbum = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(retrievedAlbum.caption) shouldEventually] equal:@"Some new caption"];
        });
        
        
        it(@"Should allow you to add items to an album.", ^{
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"1" ofType:@"jpg"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            [[Buddy photos] addPhoto:image describePhoto:^(id<BPPictureProperties> photoProperties) {
                photoProperties.caption = @"Test image for album.";
            } callback:^(id newBuddyObject, NSError *error) {
                tempPhoto = newBuddyObject;
                [tempAlbum addItemToAlbum:tempPhoto caption:@"At the park" callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNil];
                    tempItem = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(tempItem) shouldEventually] beNonNil];
        });
        
        it(@"Should allow you to retrieve an item from an album.", ^{
            __block BPPicture *retrievedPhoto;
            [tempAlbum getAlbumItem:tempItem.id callback:^(id newBuddyObject, NSError *error) {
                retrievedPhoto = newBuddyObject;
            }];
            
            [[expectFutureValue(retrievedPhoto) shouldEventually] beNonNil];
        });
        
        it(@"Should allow you to get the file for an item from an album.", ^{
            __block UIImage *retrievedPhoto;
            [tempItem getImage:^(UIImage *image, NSError *error) {
                [[error should] beNil];
                retrievedPhoto = image;
            }];
            
            [[expectFutureValue(retrievedPhoto) shouldEventually] beNonNil];
        });
        it(@"Should allow you to search for items in an album.", ^{
            __block NSArray *retrievedPhotos;
            [tempAlbum searchAlbumItems:^(id<BPAlbumItemProperties> albumItemProperties) {
                
            } callback:^(NSArray *buddyObjects, NSError *error) {
                [[error should] beNil];
                retrievedPhotos = buddyObjects;
            }];
            
            [[expectFutureValue(theValue([retrievedPhotos count])) shouldEventually] beGreaterThan:theValue(0)];
        });
        
        it(@"Should allow you to delete an album.", ^{
            __block NSString *deletedId = tempAlbum.id;
            [tempAlbum deleteMe:^(NSError *error){
                [[Buddy photos] getPhoto:deletedId callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNil];
                    tempAlbum = newBuddyObject;
                }];
            }];
            
            [[expectFutureValue(tempAlbum) shouldEventually] beNil];
        });
    });
});

SPEC_END
