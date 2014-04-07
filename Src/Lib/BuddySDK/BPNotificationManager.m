//
//  BPNotificationManager.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/26/14.
//
//

#import "BPNotificationManager.h"
#import "BPNotification.h"

@interface BPNotificationManager()

@property (weak, nonatomic) id<BPRestProvider> client;

@end

@implementation BPNotificationManager

- (instancetype)initWithClient:(id<BPRestProvider>)client{
    self = [super init];
    if(self){
        _client = client;
    }
    return self;
}

- (void)acknowledgeNotificationRecieved:(NSString *)key
{
    NSString *resource = [NSString stringWithFormat:@"/notifications/received/%@", key];
    
    [self.client POST:resource parameters:nil callback:^(id json, NSError *error) {
       // Anything?
    }];
}

- (void)sendPushNotification:(BPNotification *)notification callback:(BuddyCompletionCallback)callback
{
    NSString *url = [NSString stringWithFormat:@"notifications/%@", notification.notificationType == BPNotificationType_Alert ? @"Alert" : @"Raw"];
    
    NSDictionary *parameters = @{@"Message": BOXNIL(notification.message),
                                 @"Payload": BOXNIL(notification.payload),
                                 @"counterValue": @(notification.counterValue),
                                 @"OSCustomData": BOXNIL(notification.osCustomData),
                                 @"Recipients": BOXNIL(notification.recipients)
                                 };
    
    [self.client POST:url parameters:parameters callback:^(id json, NSError *error) {
        callback(error);
    }];
}

@end
