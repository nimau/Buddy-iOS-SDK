//
//  BPBlob.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/4/14.
//
//
#import "BPAlbumItem.h"

@protocol BPBlobProperties <BuddyObjectProperties>

@property (nonatomic, readonly, assign) NSInteger contentLength;
@property (nonatomic, readonly, copy) NSString *contentType;
@property (nonatomic, readonly, copy) NSString *signedUrl;
@property (nonatomic, copy) NSString *friendlyName;

@end

typedef void(^DescribeBlob)(id<BPBlobProperties>blobProperties);
typedef void(^SearchBlob)(id<BPBlobProperties, BPSearchProperties>blobSearchProperties);

@interface BPBlob : BuddyObject<BPBlobProperties, BPAlbumItem>

typedef void(^BuddyDataResponse)(NSData *data, NSError *error);

// Deprecated
+ (void)createWithData:(NSData *)data parameters:(NSDictionary *)parameters client:(id<BPRestProvider>)client callback:(BuddyObjectCallback)callback;

// New
- (void)savetoServerWithData:(NSData *)data callback:(BuddyCompletionCallback)callback;

- (void)getData:(BuddyDataResponse)callback;

@end
