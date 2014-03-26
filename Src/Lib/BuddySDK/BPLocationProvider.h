//
//  BPLocationProvider.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/25/14.
//
//

@protocol BPLocationProvider <NSObject>

@property (nonatomic, readonly, strong) BPCoordinate *currentLocation;

@end