//
//  BPSisterObject.h
//  BuddySDK
//
//  Created by Erik Kerber on 2/5/14.
//
//

#import <Foundation/Foundation.h>

@interface BPSisterObject : NSObject

- (instancetype) init __attribute__((unavailable("Use initWithProtocol:")));
+ (instancetype) new __attribute__((unavailable("Use initWithProtocol:")));
- (instancetype)initWithProtocol:(Protocol *)protocol;
- (instancetype)initWithProtocols:(NSArray *)protocols;

@end
