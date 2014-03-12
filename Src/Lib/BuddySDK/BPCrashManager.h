//
//  BPCrashManager.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CrashReporter/CrashReporter.h>

@interface BPCrashManager : NSObject

- (instancetype)initWithRestProvider:(id<BPRestProvider>)restProvider;

@end
