//
//  BPMetadataItem.m
//  BuddySDK
//
//  Created by Erik.Kerber on 3/4/14.
//
//

#import "BPMetadataItem.h"

@implementation BPMetadataItem
@synthesize key = _key;
@synthesize value = _value;
@synthesize keyPrefix = _keyPrefix;
@synthesize locationRange = _locationRange;
@synthesize created = _created;
@synthesize modified = _modified;

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
