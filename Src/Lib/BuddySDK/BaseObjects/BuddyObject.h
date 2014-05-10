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

- (instancetype) init __attribute__((unavailable("init not available")));
+ (instancetype) new __attribute__((unavailable("new not available")));

- (void)registerProperty:(SEL)property;

+ (NSString *)requestPath;

+ (void)createFromServerWithParameters:(NSDictionary *)parameters client:(id<BPRestProvider>)client callback:(BuddyObjectCallback)callback;
- (void)destroy:(BuddyCompletionCallback)callback;
- (void)destroy;
- (void)refresh;
- (void)refresh:(BuddyCompletionCallback)callback;
- (void)save:(BuddyCompletionCallback)callback;

@end
