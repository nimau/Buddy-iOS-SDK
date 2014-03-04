//
//  BPUserListCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 2/26/14.
//
//

#import "BPUserList.h"

@interface BPUserListCollection : BuddyCollection

- (void)addUserList:(DescribeUserList)describe
           callback:(BuddyObjectCallback)callback;

@end
