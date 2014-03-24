//
//  UIImageView+BuddyImage.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/9/14.
//
//

#import <UIKit/UIKit.h>
@class BPPicture;

@interface UIImageView (BPAdditions)

- (void)bp_setImageWithBPPicture:(BPPicture *)picture;

@end
