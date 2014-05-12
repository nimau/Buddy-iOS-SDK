//
//  BPPermissions.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/23/14.
//
//

/**
 Permissions scope for Buddy objects.
 */
typedef NS_ENUM(NSInteger, BPPermissions){
    /** Accessible by App. */
    BPPermissionsApp = 1,
    /** Accessible by owner. */
    BPPermissionsUser = 2,
    /** Default (Accessible by Owner). */
    BPPermissionsDefault = BPPermissionsUser
};
