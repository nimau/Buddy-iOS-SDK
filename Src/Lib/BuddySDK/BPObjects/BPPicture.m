//
//  BPPicture.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BPPicture.h"
#import "BuddyObject+Private.h"
#import "BPSisterObject.h"

@implementation BPPicture

@synthesize caption = _caption;
@synthesize size = _size;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(caption)];
}


static NSString *pictures = @"pictures";
+ (NSString *) requestPath
{
    return pictures;
}

static NSString *pictureMimeType = @"image/png";
+ (NSString *)mimeType
{
    return pictureMimeType;
}

+ (void)createWithImage:(UIImage *)image
          describePicture:(DescribePicture)describePicture
                 client:(id<BPRestProvider>)client
               callback:(BuddyObjectCallback)callback
{
    //NSData *data = UIImageJPEGRepresentation(image, 1);
    NSData *data = UIImagePNGRepresentation(image);
    
    id pictureProperties= [[BPSisterObject alloc] initWithProtocol:@protocol(BPPictureProperties)];
    describePicture ? describePicture(pictureProperties) : nil;

    id parameters = [pictureProperties parametersFromProperties:@protocol(BPPictureProperties)];
    
    [self createWithData:data parameters:parameters client:client callback:^(id newBuddyObject, NSError *error) {
        callback ? callback(newBuddyObject, error) : nil;
    }];
}

- (void)getImage:(BuddyImageResponse)callback
{
    [self getData:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        callback ? callback(image, error) : nil;
    }];
}

@end
