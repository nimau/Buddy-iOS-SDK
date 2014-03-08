//
//  BPUserList.h
//  BuddySDK
//
//  Created by Erik Kerber on 2/26/14.
//
//

#import "BPUser.h"

@protocol BPUserListProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *name;

@end

typedef void(^DescribeUserList)(id<BPUserListProperties>userListProperties);

@interface BPUserList : BuddyObject<BPUserListProperties>

- (void)addUser:(BPUser *)user callback:(BuddyCompletionCallback)callback;

@end
