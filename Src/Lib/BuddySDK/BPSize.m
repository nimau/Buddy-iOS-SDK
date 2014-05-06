//
//  BPSize.m
//  BuddySDK
//
//  Created by Erik.Kerber on 5/1/14.
//
//

#import "BPSize.h"

@implementation BPSize
- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%lu,%lu", (unsigned long)self.w, (unsigned long)self.h];
}
@end
