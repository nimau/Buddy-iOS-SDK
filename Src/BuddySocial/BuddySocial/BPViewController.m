//
//  BPViewController.m
//  BuddySocial
//
//  Created by Erik Kerber on 1/3/14.
//  Copyright (c) 2014 Buddy. All rights reserved.
//

#import "BPViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <BuddySDK/Buddy.h>

#define TEST_USERNAME @"erik8"
#define TEST_PASSWORD @"password"

@interface BPViewController () <FBLoginViewDelegate>

@end

@implementation BPViewController

- (IBAction)login:(id)sender
{
    [Buddy login:TEST_USERNAME password:TEST_PASSWORD callback:^(id newBuddyObject, NSError *error) {
        
    }];
}

- (IBAction)pushNotification:(id)sender
{
    
    BPNotification *note = [BPNotification new];
    note.recipients = @[[Buddy user].id];
    note.message = @"Message";
    note.payload = @"Payload";
    note.osCustomData = @"{}";
    note.notificationType = BPNotificationType_Raw;
    
    [Buddy sendPushNotification:note callback:^(NSError *error) {
        int a = 5;
    }];
    
}

- (IBAction)checkin:(id)sender {
    
    BPPicture *pic = [BPPicture new];
    pic.caption = @"HEllo, caption!";
    
    [[Buddy pictures] addPicture:pic image:[UIImage imageNamed:@"test.png"] callback:^(NSError *error) {
        int a = 5;
    }];
    
}

- (IBAction)crash:(id)sender
{
    ((id)[NSObject new])[0];
//    CFRelease(NULL);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, self.view.center.x - (loginView.frame.size.width / 2), self.view.center.y - (loginView.frame.size.height / 2));
    loginView.delegate = self;
    [self.view addSubview:loginView];
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@", user);
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];

    [Buddy socialLogin:@"Facebook" providerId:user.id token:fbAccessToken success:^(BPUser *newBuddyObject, NSError *error) {
        NSLog(@"Hello");
    }];
}

@end
