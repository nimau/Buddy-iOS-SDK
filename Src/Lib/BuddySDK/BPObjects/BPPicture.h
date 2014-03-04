//
//  BPPicture.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import <UIKit/UIKit.h>
#import "BPBlob.h"

@protocol BPPictureProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *caption;

@end

@class BPPicture;

typedef void(^BuddyImageResponse)(UIImage *image, NSError *error);
typedef void(^DescribePhoto)(id<BPPictureProperties>photoProperties);

@interface BPPicture : BPBlob<BPPictureProperties>

//@property (nonatomic, assign) CGSize size;

+ (void)createWithImage:(UIImage *)image
          describePhoto:(DescribePhoto)describePhoto
                 client:(id<BPRestProvider>)client
               callback:(BuddyObjectCallback)callback;

- (void)getImage:(BuddyImageResponse)callback;

@end
