//
//  BPLocation.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/9/14.
//
//

@protocol BPLocationProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *fax;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) BOOL isPublic;

@end

@protocol BPSearchLocationProperties <NSObject>
@property (nonatomic, strong) BPCoordinateRange *locationRange;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, copy) NSString *pagingToken;
@property (nonatomic, copy) NSString *userID;
@end

@interface BPSearchLocation : BPObjectSearch<BPLocationProperties, BPSearchLocationProperties>

@end

@interface BPLocation : BuddyObject<BPLocationProperties>

@end
