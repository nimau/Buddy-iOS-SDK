//
//  BuddyObject.h
//  BuddySDK
//
//  Created by Erik Kerber on 9/11/13.
//
//

#import <Foundation/Foundation.h>
#import "BPRestProvider.h"
#import "BPCoordinate.h"
#import "BPBase.h"
#import "BuddyCollection.h"

@interface BuddyObject : BPBase<BuddyObjectProperties>

@property (nonatomic, readonly, assign) BOOL deleted;
@property (nonatomic, readonly, assign) BOOL isDirty;

- (void)registerProperty:(SEL)property;

+ (NSString *)requestPath;

- (void)destroy:(BuddyCompletionCallback)callback;
- (void)destroy;
- (void)refresh;
- (void)refresh:(BuddyCompletionCallback)callback;
- (void)save:(BuddyCompletionCallback)callback;

@end
