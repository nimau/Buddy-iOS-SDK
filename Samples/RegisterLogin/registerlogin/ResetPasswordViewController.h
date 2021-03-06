//
//  ResetPasswordViewController.h
//  registerlogin
//
//  Created by devmania on 3/22/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface ResetPasswordViewController : UIViewController<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property (weak, nonatomic) IBOutlet UIButton *resetBut;
@property (weak, nonatomic) IBOutlet UIButton *requestResetBut;
@property (weak, nonatomic) IBOutlet UIButton *cancelBut;

- (IBAction)doReset:(id)sender;
- (IBAction)doRequestSent:(id)sender;
- (IBAction)doCancel:(id)sender;

@end
