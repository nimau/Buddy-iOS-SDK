//
//  BPLocation.m
//  BuddySDK
//
//  Created by Erik Kerber on 1/9/14.
//
//

#import "BPLocation.h"
#import "BuddyObject+Private.h"

@implementation BPLocation

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(name)];
    [self registerProperty:@selector(description)];
    [self registerProperty:@selector(streetAddress1)];
    [self registerProperty:@selector(streetAddress2)];
    [self registerProperty:@selector(city)];
    [self registerProperty:@selector(subCountryDivision)];
    [self registerProperty:@selector(country)];
    [self registerProperty:@selector(postalCode)];
    [self registerProperty:@selector(fax)];
    [self registerProperty:@selector(phone)];
    [self registerProperty:@selector(website)];
    [self registerProperty:@selector(category)];
    [self registerProperty:@selector(distanceFromSearch)];
}

NSString *location = @"locations";
+ (NSString *)requestPath
{
    return location;
}

@end
