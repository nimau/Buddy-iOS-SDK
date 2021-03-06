//
//  ChangeNameBirthdayVC.m
//  registerlogin
//
//  Created by devmania on 3/27/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <BuddySDK/Buddy.h>

#import "ChangeNameBirthdayVC.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ChangeNameBirthdayVC ()

@property (nonatomic,strong) MBProgressHUD *HUD;

- (void) goBack;
- (BuddyCompletionCallback) getUpdateProfileCallback;

@end

@implementation ChangeNameBirthdayVC

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
    
    self.saveBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.saveBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.saveBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.saveBut.clipsToBounds = YES;
    
    self.cancelBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.cancelBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.cancelBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.cancelBut.clipsToBounds = YES;
    
    self.birthdayPicker.datePickerMode = UIDatePickerModeDate;
    [self populateUI];
}

-(void) populateUI
{
    self.firstNameField.text = [Buddy user].firstName;
    self.lastNameField.text = [Buddy user].lastName;
    
    if ([Buddy user].dateOfBirth)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        self.birthdayField.text = [formatter stringFromDate:[Buddy user].dateOfBirth];
        [self.birthdayPicker setDate:[Buddy user].dateOfBirth];
    }
    else
    {
        self.birthdayField.text = @"Not set yet";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doSave:(id)sender
{
    if ([self.firstNameField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Notification"
                                   message: @"Please input First Name"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([self.lastNameField.text length]==0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Notification"
                                   message: @"Please input Last Name"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Saving...";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;

    [Buddy user].firstName = self.firstNameField.text;
    [Buddy user].lastName = self.lastNameField.text;
    [Buddy user].dateOfBirth = self.birthdayPicker.date;
    
    [[Buddy user] save:[self getUpdateProfileCallback]];
}

- (BuddyCompletionCallback) getUpdateProfileCallback
{
    ChangeNameBirthdayVC * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Change name and birthday - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Changing name and birthday"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Change name and birthday - success Called");
        [self goBack];
        
    };
}

- (IBAction)doCancel:(id)sender
{
    [self goBack];
}

-(void) goBack
{
    [[CommonAppDelegate navController] popViewControllerAnimated:YES];
}
@end
