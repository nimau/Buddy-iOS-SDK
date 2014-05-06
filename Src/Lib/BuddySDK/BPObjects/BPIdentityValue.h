//
//  BPIdentityValue.h
//  BuddySDK
//
//  Created by Erik.Kerber on 5/1/14.
//
//

#import <Foundation/Foundation.h>

@interface BPIdentityValue : NSObject

@property (copy, nonatomic) NSString *identityProviderID;
@property (copy, nonatomic) NSString *identityProviderName;

- (instancetype)initBuddyWithResponse:(id)response;

@end
