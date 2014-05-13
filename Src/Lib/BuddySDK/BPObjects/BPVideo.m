//
//  BPVideo.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/5/14.
//
//

#import "BPVideo.h"

@implementation BPVideoSearch

@synthesize title;
@synthesize friendlyName;
@synthesize thumbnailOffsetInSeconds;
@synthesize bitRate;
@synthesize encoding;
@synthesize lengthInSeconds;
@synthesize thumbnailID;

@end

@interface BPVideo()

@property (nonatomic, assign) NSInteger bitRate;
@property (nonatomic, copy) NSString *encoding;
@property (nonatomic, assign) double lengthInSeconds;
@property (nonatomic, copy) NSString *thumbnailID;

@end

@implementation BPVideo
@synthesize title;
@synthesize friendlyName;
@synthesize thumbnailOffsetInSeconds;
@synthesize bitRate;
@synthesize encoding;
@synthesize lengthInSeconds;
@synthesize thumbnailID;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(title)];
    [self registerProperty:@selector(thumbnailOffsetInSeconds)];
    [self registerProperty:@selector(encoding)];
    [self registerProperty:@selector(lengthInSeconds)];
    [self registerProperty:@selector(thumbnailID)];

}

static NSString *videos = @"videos";
+ (NSString *) requestPath
{
    return videos;
}

static NSString *videoMimeType = @"video/mp4";
+ (NSString *)mimeType
{
    return videoMimeType;
}

- (void)getVideo:(BuddyDataResponse)callback
{
    [self getData:^(NSData *data, NSError *error) {
        callback ? callback(data, error) : nil;
    }];
}


@end
