//
//  BuddyLocation.h
//  BuddySDK
//
//  Created by Erik Kerber on 9/15/13.
//
//

@class BPCoordinate;

@protocol BuddyLocationDelegate <NSObject>

- (void)didUpdateBuddyLocation:(BPCoordinate *)newLocation;

@end

/**
 * Encapsulates and translates CoreLocation framework into Buddy-flavored location tracking.
 */
@interface BPLocationManager : NSObject

///<summary>
/// Returns YES if the user has restricted location access for the current app.
///</summary>
-(BOOL) shouldRequestLocationTracking;

/// <summary>
/// TODO
/// </summary>
-(void) beginTrackingLocation:(void (^)(NSError *error))callback;

/// <summary>
/// TODO
/// </summary>
-(void) endTrackingLocation;

@property (readonly, assign) BOOL isTracking;

@property (nonatomic, weak) id<BuddyLocationDelegate> delegate;

@end
