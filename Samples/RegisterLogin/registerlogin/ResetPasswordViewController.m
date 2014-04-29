//
//  ResetPasswordViewController.m
//  registerlogin
//
//  Created by devmania on 3/22/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <BuddySDK/Buddy.h>

#import "ResetPasswordViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ResetPasswordViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;

- (void) goBack;
- (BOOL) isPasswordValid;

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.resetBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.resetBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.resetBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.resetBut.clipsToBounds = YES;
    
    self.requestResetBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.requestResetBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.requestResetBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.requestResetBut.clipsToBounds = YES;
    
    self.cancelBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.cancelBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.cancelBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.cancelBut.clipsToBounds = YES;
    
}

- (void) goBack
{
    [[CommonAppDelegate navController] popViewControllerAnimated:YES];
}

- (void) resignTextFields
{
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
}

- (BOOL) isPasswordValid
{
    [self resignTextFields];
    
    if( [self.passwordField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Password Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    if( [self.confirmPasswordField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Empty Field"
                                   message: @"Confirm Password Cannot be empty"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text])
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Mismatch field"
                                   message: @"Password field doesn't match"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doReset:(id)sender
{
    if (![self isPasswordValid])
    {
        return;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Reseting";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    NSString *oldPassword = [CommonAppDelegate fetchPassword];
    NSString *newPassword = self.passwordField.text;
    [Buddy.user resetPassword:oldPassword newPassword:newPassword callback:[self getPasswordResetCallback]];
    
}

-(BuddyCompletionCallback) getPasswordResetCallback
{
    ResetPasswordViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Reset password - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Reseting password"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Reset password - success Called");
        [self goBack];
        
    };
}

- (IBAction)doRequestSent:(id)sender
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Reseting";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    [Buddy.user requestPasswordReset:[self getPasswordResetRequestCallback]];
}

-(BuddyObjectCallback) getPasswordResetRequestCallback
{
    ResetPasswordViewController * __weak weakSelf = self;
    
    return ^(id newBuddyObject, NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Reset password request - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Reset password request"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Reset password request - success Called");
        [self goBack];
        
    };
}

- (IBAction)doCancel:(id)sender
{
    [self goBack];
}

@end
