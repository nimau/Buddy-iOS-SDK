//
//  BPBlob.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/4/14.
//
//
#import "BPAlbumItem.h"

@protocol BPBlobProperties <BuddyObjectProperties>

@property (nonatomic, assign) NSInteger contentLength;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *signedUrl;
@property (nonatomic, copy) NSString *friendlyName;
//@property (nonatomic, copy) NSString *size;

@end

typedef void(^DescribeBlob)(id<BPBlobProperties>blobProperties);
typedef void(^SearchBlob)(id<BPBlobProperties, BPSearchProperties>blobSearchProperties);

@interface BPBlob : BuddyObject<BPBlobProperties, BPAlbumItem>

typedef void(^BuddyDataResponse)(NSData *data, NSError *error);

+ (void)createWithData:(NSData *)data parameters:(NSDictionary *)parameters client:(id<BPRestProvider>)client callback:(BuddyObjectCallback)callback;

- (void)getData:(BuddyDataResponse)callback;

@end
