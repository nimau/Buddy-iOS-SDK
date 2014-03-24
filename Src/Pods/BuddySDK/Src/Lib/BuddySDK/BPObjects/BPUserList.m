//
//  BPUserList.m
//  BuddySDK
//
//  Created by Erik Kerber on 2/26/14.
//
//

#import "BPUserList.h"

@implementation BPUserList

@synthesize name;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(name)];
}


static NSString *userLists = @"users/lists";
+ (NSString *) requestPath{
    return userLists;
}

- (void)addUser:(BPUser *)user callback:(BuddyCompletionCallback)callback
{
    callback([NSError errorWithDomain:@"Not implemented" code:-1 userInfo:nil]);
}

@end
