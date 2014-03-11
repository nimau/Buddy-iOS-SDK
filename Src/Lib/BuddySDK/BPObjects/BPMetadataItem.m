//
//  BPMetadataItem.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/4/14.
//
//

#import "BPMetadataItem.h"

@implementation BPMetadataItem
@synthesize key;
@synthesize value;
@synthesize keyPrefix;
@synthesize locationRange;
@synthesize created;
@synthesize modified;

- (instancetype)initBuddyWithResponse:(id)response
{
    if (!response) return nil;
    
    self = [super init];
    if(self)
    {
        [[JAGPropertyConverter converter] setPropertiesOf:self fromDictionary:response];
    }
    return self;
}

@end
