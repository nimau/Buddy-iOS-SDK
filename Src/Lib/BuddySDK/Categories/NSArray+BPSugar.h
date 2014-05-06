//
//  NSArray+BPSugar.h
//  BuddySDK
//
//  Created by Erik.Kerber on 5/1/14.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (BPSugar)

- (NSArray *)bp_map:(id (^)(id object))block;

@end
