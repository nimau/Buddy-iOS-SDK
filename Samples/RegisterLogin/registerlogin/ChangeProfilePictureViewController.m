//
//  ChangeProfileViewController.m
//  registerlogin
//
//  Created by devmania on 3/21/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <BuddySDK/Buddy.h>

#import "ChangeProfilePictureViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ChangeProfilePictureViewController ()

@property (nonatomic,strong) MBProgressHUD *HUD;

-(void) goBack;

-(BuddyCompletionCallback) getSavePhotoCallback;
-(BuddyCompletionCallback) getDeletePhotoCallback;

@end

@implementation ChangeProfilePictureViewController

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
    
    self.choosePhotoBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.choosePhotoBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.choosePhotoBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.choosePhotoBut.clipsToBounds = YES;
    
    self.saveBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.saveBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.saveBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.saveBut.clipsToBounds = YES;
    
    self.deletePhotoBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.deletePhotoBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.deletePhotoBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.deletePhotoBut.clipsToBounds = YES;
    
    self.cancelBut.layer.cornerRadius = DEFAULT_BUT_CORNER_RAD;
    self.cancelBut.layer.borderWidth = DEFAULT_BUT_BORDER_WIDTH;
    self.cancelBut.layer.borderColor = [UIColor blackColor].CGColor;
    self.cancelBut.clipsToBounds = YES;

    [self populateUI];
}

-(void) populateUI
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText= @"Loading...";
    self.HUD.dimBackground = YES;
    self.HUD.delegate=self;
    
    NSURL *picURL = Buddy.user.profilePictureUrl;
    
    if (picURL==nil)
    {
        [self.HUD hide:YES];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:picURL];
    UIImage *pictureImage = [[UIImage alloc] initWithData:data];

    if(pictureImage!=nil)
    {
        [self.choosePhotoBut setImage:pictureImage forState:UIControlStateNormal];
    }
    else
    {
        [self.choosePhotoBut setBackgroundColor:[UIColor blackColor]];
    }
    
    [self.HUD hide:YES];
}

-(void) goBack
{
    [[CommonAppDelegate navController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerCamera =[[UIImagePickerController alloc] init];
        imagePickerCamera.delegate = self;
        imagePickerCamera.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePickerCamera.allowsEditing = YES;
        imagePickerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerCamera  animated:YES completion:nil];
    }
    
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePickerAlbum =[[UIImagePickerController alloc] init];
        imagePickerAlbum.delegate = self;
        imagePickerAlbum.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePickerAlbum.allowsEditing = YES;
        imagePickerAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerAlbum animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.selectedImage = chosenImage;
    [self.choosePhotoBut setTitle:@"" forState:UIControlStateNormal];
    [self.choosePhotoBut setImage:self.selectedImage forState: UIControlStateNormal];
    [self.choosePhotoBut setImage:self.selectedImage forState:UIControlStateSelected];
    [self.choosePhotoBut setContentMode:UIViewContentModeScaleToFill];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.choosePhotoBut setImage:nil forState: UIControlStateNormal];
    [self.choosePhotoBut setTitle:@"Choose Photo" forState:UIControlStateNormal];
    
}

- (IBAction)doCancel:(id)sender
{
    [self goBack];
}

- (IBAction)doSave:(id)sender
{
    if (self.selectedImage==nil)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Notification"
                                   message: @"Please select photo"
                                  delegate: self
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    self.HUD.labelText= @"Saving...";
    [self.HUD show:YES];

    NSString *photoCaption = self.captionField.text;
    [Buddy.user setUserProfilePicture:self.selectedImage caption:photoCaption callback: [self getSavePhotoCallback]];
}

- (IBAction)doDeletePhoto:(id)sender
{
    self.HUD.labelText= @"Deleting Photo...";
    [self.HUD show:YES];
    
    [Buddy.user deleteUserProfilePicture:[self getDeletePhotoCallback]];
}

-(BuddyCompletionCallback) getSavePhotoCallback
{
    ChangeProfilePictureViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Save User profile picture - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Saving Profile Photo"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Save User profile picture - success Called");
        [self goBack];
        
    };
    
}

-(BuddyCompletionCallback) getDeletePhotoCallback
{
    ChangeProfilePictureViewController * __weak weakSelf = self;
    
    return ^(NSError *error)
    {
        [weakSelf.HUD hide:TRUE afterDelay:0.1];
        weakSelf.HUD=nil;
        
        if(error!=nil)
        {
            NSLog(@"Delete User profile picture - error Called");
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Error Deleting Profile Photo"
                                       message: [error localizedDescription]
                                      delegate: self
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSLog(@"Delete User profile picture - success Called");
        [self goBack];
        
    };
    
}
@end
