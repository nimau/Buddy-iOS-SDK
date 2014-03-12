//
//  BPCoordinate.h
//  BuddySDK
//
//  Created by Erik Kerber on 12/9/13.
//
//

#import <Foundation/Foundation.h>

@interface BPCoordinate : NSObject
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@end

static inline BPCoordinate *BPCoordinateMake(float lat, float lon)
{
    BPCoordinate *coord = [[BPCoordinate alloc] init];
    coord.lat = lat;
    coord.lng = lon;
    return coord;
};

@interface BPCoordinateRange : BPCoordinate
@property (nonatomic, assign) NSInteger range;
@end

static inline BPCoordinateRange *BPCoordinateRangeMake(float lat, float lon, NSInteger distanceInMeteres)
{
    BPCoordinateRange *coord = [[BPCoordinateRange alloc] init];
    coord.lat = lat;
    coord.lng = lon;
    coord.range = distanceInMeteres;
    return coord;
};