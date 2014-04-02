//
//  BPSisterObject.m
//  BuddySDK
//
//  Created by Erik Kerber on 2/5/14.
//
//

#import "BPSisterObject.h"
#import <objc/runtime.h>

@interface BPSisterObject()

@property (nonatomic, strong) NSMutableDictionary *properties;
@property (nonatomic, strong) Protocol *brotherProtocol;


@end

@implementation BPSisterObject

- (instancetype)initWithProtocol:(Protocol *)protocol
{
    self = [super init];
    if (self) {
        _properties = [NSMutableDictionary dictionary];
        _brotherProtocol = protocol;
    }
    return self;
}

- (void)dealloc
{
    self.properties = nil;
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if ([NSStringFromSelector(aSEL) hasPrefix:@"set"]) {
        class_addMethod([self class], aSEL, (IMP)setPropertyIMP, "v@:@");
    } else {
        class_addMethod([self class], aSEL,(IMP)propertyIMP, "@@:");
    }
    return YES;
}

static id propertyIMP(id self, SEL _cmd) {

    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    
    // delete "set" and ":" and lowercase first letter
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    NSString *firstChar = [key substringToIndex:1];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];

    return [[self properties] valueForKey:key];
}

static void setPropertyIMP(id self, SEL _cmd, __unsafe_unretained id aValue) {
    
    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    
    // delete "set" and ":" and lowercase first letter
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
    NSString *firstChar = [key substringToIndex:1];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
    
    objc_property_t p = protocol_getProperty([self brotherProtocol], [(NSString *)key cStringUsingEncoding:NSStringEncodingConversionAllowLossy], YES, YES);
    const char *pa = property_getAttributes(p);
    
    id value;
    NSString *encoding = [NSString stringWithCString:pa encoding:NSStringEncodingConversionAllowLossy];
    if ([[encoding substringWithRange:NSMakeRange(1,1)] isEqualToString:@"@"]) {
        value = aValue;
    } else {
        value = @((NSInteger)aValue);
    }
    
    [[self properties] setValue:value forKey:key];
}
@end
