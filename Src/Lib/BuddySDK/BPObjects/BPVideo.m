//
//  BPVideo.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/5/14.
//
//

#import "BPVideo.h"
#import "BPSisterObject.h"

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

+ (void)createWithVideo:(NSData *)video
          describeVideo:(DescribeVideo)describeVideo
                 client:(id<BPRestProvider>)client
               callback:(BuddyObjectCallback)callback
{
    id videoProperties = [BPSisterObject new];
    describeVideo ? describeVideo(videoProperties) : nil;
    
    id parameters = [videoProperties parametersFromProperties:@protocol(BPVideoProperties)];
    
    [self createWithData:video parameters:parameters client:client callback:^(id newBuddyObject, NSError *error) {
        callback ? callback(newBuddyObject, error) : nil;
    }];
}

- (void)getVideo:(BuddyDataResponse)callback
{
    [self getData:^(NSData *data, NSError *error) {
        callback ? callback(data, error) : nil;
    }];
}


@end
