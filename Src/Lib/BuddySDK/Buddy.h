//
//  Buddy.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import <Foundation/Foundation.h>

#import "BuddyObject.h"
#import "BuddyDevice.h"
#import "BPAlbumItem.h"
#import "BPClient.h"
#import "BPCheckin.h"
#import "BPCheckinCollection.h"
#import "BPAlbumCollection.h"
#import "BPPicture.h"
#import "BPUser.h"
#import "BPPictureCollection.h"
#import "BPVideoCollection.h"
#import "BPBlobCollection.h"
#import "BPUserCollection.h"
#import "BPCoordinate.h"
#import "BPDateRange.h"
#import "BPBlob.h"
#import "BPAlbum.h"
#import "BPLocationCollection.h"
#import "BPLocation.h"
#import "BPMetricCompletionHandler.h"
#import "BPMetadataItem.h"
#import "BPNotification.h"
#import "BPIdentityValue.h"
#import "BPSize.h"

/**
 * TODO
 *
 * @since v2.0
 */
@interface Buddy : NSObject

/**
 The currently logged in user. Will be nil if no login session has occurred.
 */
+ (BPUser *)user;

//+ (BuddyDevice *)device;

/**
 Accessor to create and query checkins
 */
+ (BPUserCollection *)users;

/**
 Accessor to create and query checkins
 */
+ (BPCheckinCollection *) checkins;

/**
 Accessor to create and query pictures.
 */
+ (BPPictureCollection *) pictures;

/**
 Accessor to create and query videos.
 */
+ (BPVideoCollection *) videos;

/**
 Accessor to create and query data and files.
 */
+ (BPBlobCollection *)blobs;
    
/**
 Accessor to create and query albums.
 */
+ (BPAlbumCollection *)albums;

/**
 Accessor to create and query locations.
 */
+ (BPLocationCollection *)locations;

/**
  Public REST provider for passthrough access.
 */
+ (id<BPRestProvider>)buddyRestProvider;


+ (BOOL) locationEnabled;

+ (void) setLocationEnabled:(BOOL)enabled;

+ (void)setClientDelegate:(id<BPClientDelegate>)delegate;

/**
 *
 * Initialize the Buddy SDK with your App ID and App Key
 *
 * @param appID  Your application ID.
 *
 * @param appKey Your application key.
 *
 * @param callback A BuddyCompletionBlock that has an error, if any.
 */
+ (void)initClient:(NSString *)appID
            appKey:(NSString *)appKey;


/**
 *
 * Create a new Buddy User.
 *
 * @param username The new user's username
 *
 * @param password THe new user's password
 *
 * @param options The set of creation options for the user.
 */
+ (void)createUser:(BPUser *)user password:(NSString *)password callback:(BuddyCompletionCallback)callback;

/**
 *
 * Login a user using the provided username and password.
 */
+ (void)login:(NSString *)username password:(NSString *)password callback:(BuddyObjectCallback)callback;

/**
 *
 * Login the app using a social provider such as Facebook or Twitter.
 */
+ (void)socialLogin:(NSString *)provider providerId:(NSString *)providerId token:(NSString *)token success:(BuddyObjectCallback) callback;

/**
 *
 * Logout of the current app
 */
+ (void)logout:(BuddyCompletionCallback)callback;

/* 
 * Notification
 */
+ (void)sendPushNotification:(BPNotification *)notification callback:(BuddyCompletionCallback)callback;


+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value callback:(BuddyCompletionCallback)callback;

+ (void)recordMetric:(NSString *)key andValue:(NSDictionary *)value timeout:(NSInteger)seconds callback:(BuddyMetricCallback)callback;

+ (void)setMetadata:(BPMetadataItem *)metadata callback:(BuddyCompletionCallback)callback;
+ (void)setMetadataValues:(BPMetadataCollection *)metadata callback:(BuddyCompletionCallback)callback;
+ (void)getMetadataWithKey:(NSString *)key permissions:(BPPermissions) permissions callback:(BPMetadataCallback)callback;
+ (void)searchMetadata:(BPSearchMetadata *)search callback:(BuddyObjectCallback)callback;
+ (void)incrementMetadata:(NSString *)key delta:(NSInteger)delta callback:(BuddyCompletionCallback)callback;
+ (void)deleteMetadataWithKey:(NSString *)key permissions:(BPPermissions)permissions callback:(BuddyCompletionCallback)callback;

@end
