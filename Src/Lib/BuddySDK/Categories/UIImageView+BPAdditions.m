//
//  UIImageView+BuddyImage.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/9/14.
//
//

#import "UIImageView+BPAdditions.h"
#import "BPPicture.h"
#import "BPUIImageView+AFNetworking.h"

@implementation UIImageView (BPAdditions)

- (void)bp_setImageWithBPPicture:(BPPicture *)picture
{
    [self setImageWithURL:[NSURL URLWithString:picture.signedUrl]];
}

@end
