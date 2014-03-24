//
//  BuddyLocation.m
//  BuddySDK
//
//  Created by Erik Kerber on 9/15/13.
//
//

#import "BPLocationManager.h"
#import "BPCoordinate.h"
#import <CoreLocation/CoreLocation.h>

@interface BPLocationManager()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *location;
@property (assign, readwrite, nonatomic) BOOL isTracking;
@property (nonatomic, copy) void (^beginTrackingCallback)(NSError *error);

@property (nonatomic, strong) BPCoordinate *currentCoordinate;
@end

@implementation BPLocationManager

-(id)init
{
    self = [super init];
    if(self)
    {
        self.location = [[CLLocationManager alloc] init];
        self.location.distanceFilter = kCLDistanceFilterNone;
        self.location.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.location.delegate = self;
    }
    return self;
}

#pragma mark Public interface

-(void) beginTrackingLocation:(void (^)(NSError *error))callback;
{
    self.beginTrackingCallback = callback;
    [self.location startUpdatingLocation];

    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        self.beginTrackingCallback([NSError errorWithDomain:@"BPLocationManager" code:0 userInfo:@{@"message": @"Location denied."}]);
    }
    else
    {
        [self.location startUpdatingLocation];
    }
}

-(void) endTrackingLocation
{
    [self.location stopUpdatingLocation];
    self.isTracking = NO;
}

-(BOOL) shouldRequestLocationTracking
{
    return  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted;
}


-(BOOL)authenticationStatus
{
    return [CLLocationManager authorizationStatus];
}

-(CLLocation *)currentLocation
{
    return [self.location location];
}

#pragma mark helpers


#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if(self.beginTrackingCallback) {
        self.beginTrackingCallback([NSError errorWithDomain:@"BPLocationManager" code:0 userInfo:@{@"message": @"Location initialization failed"}]);
    }
    
    self.beginTrackingCallback = nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status != kCLAuthorizationStatusAuthorized)
    {
        self.isTracking = NO;
    }
    else
    {
        self.isTracking = YES;
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    if (self.beginTrackingCallback){
        self.beginTrackingCallback(nil);
    }
    self.beginTrackingCallback = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.currentCoordinate) {
        self.currentCoordinate = [BPCoordinate new];
    }
    
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D coord = newLocation.coordinate;
    
    self.currentCoordinate.lat = coord.latitude;
    self.currentCoordinate.lng = coord.longitude;
    
    if (self.delegate) {
        [self.delegate didUpdateBuddyLocation:self.currentCoordinate];
    }
}

- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error
{
    // TBD
    // We likely won't be doing deferred updates, so probably not necessary.
}

@end
