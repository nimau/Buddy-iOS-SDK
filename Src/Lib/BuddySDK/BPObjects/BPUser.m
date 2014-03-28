//
//  BPUser.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BPUser.h"
#import "BuddyObject+Private.h"
#import "BPClient.h"
#import "BPEnumMapping.h"

@interface BPUser()

@end

@implementation BPUser

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize userName = _userName;
@synthesize gender = _gender;
@synthesize dateOfBirth = _dateOfBirth;
@synthesize profilePicture = _profilePicture;
@synthesize profilePictureId = _profilePictureId;
@synthesize email = _email;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(firstName)];
    [self registerProperty:@selector(lastName)];
    [self registerProperty:@selector(userName)];
    [self registerProperty:@selector(gender)];
    [self registerProperty:@selector(dateOfBirth)];
    [self registerProperty:@selector(profilePicture)];
    [self registerProperty:@selector(profilePictureId)];
}

+ (NSDictionary *)enumMap
{
    return [[[self class] baseEnumMap] dictionaryByMergingWith: @{
                                                                  NSStringFromSelector(@selector(gender)) : @{
                                                                          @(BPUserGender_Male) : @"Male",
                                                                          @(BPUserGender_Female) : @"Female",
                                                                          },
                                                                  }];
}

static NSString *users = @"users";
+(NSString *)requestPath
{
    return users;
}

-(NSInteger)age
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                               fromDate:self.dateOfBirth
                                                 toDate:[NSDate date]
                                                options:0];
    
    return components.year;
}

#pragma mark - Password

- (void)requestPasswordResetWithSubject:(NSString *)subject body:(NSString *)body callback:(BuddyObjectCallback)callback
{
    NSString *resource = @"users/password";
    NSDictionary *parameters = @{@"username": self.userName,
                                 @"subject": BOXNIL(subject),
                                 @"body": BOXNIL(body)};
                                 

    [self.client POST:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(json, nil) : nil;
    }];
}

- (void)resetPassword:(NSString *)resetCode newPassword:(NSString *)newPassword callback:(BuddyCompletionCallback)callback
{
    NSString *resource = @"users/password";
    NSDictionary *parameters = @{@"username": self.userName,
                                 @"resetCode": BOXNIL(resetCode),
                                 @"newPassword": BOXNIL(newPassword)};
    
    [self.client PATCH:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)addIdentity:(NSString *)identityProvider value:(NSString *)value callback:(BuddyCompletionCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"users/%@/identities", self.id];
    NSDictionary *parameters = @{
                                 @"identityProviderName": identityProvider,
                                 @"identityID": value
                                 };
    
    [self.client POST:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)removeIdentity:(NSString *)identityProvider value:(NSString *)value callback:(BuddyCompletionCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"users/%@/identities/%@", self.id, identityProvider];

    NSDictionary *parameters = @{
                                 @"identityID": value
                                 };
    
    [self.client DELETE:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)getIdentities:(NSString *)identityProvider callback:(BuddyCollectionCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"users/%@/identities/%@", self.id, identityProvider];
    
    [self.client GET:resource parameters:nil callback:^(id identityValues, NSError *error) {
        callback ? callback(identityValues, error) : nil;
    }];

}

#pragma mark - Profile Picture

- (void)setUserProfilePicture:(UIImage *)picture caption:(NSString *)caption callback:(BuddyCompletionCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"user/%@/profilepicture", self.id];
    NSDictionary *parameters = @{@"caption": caption};

    NSDictionary *data = @{@"data": UIImagePNGRepresentation(picture)};
    
    [self.client MULTIPART_POST:resource parameters:parameters data:data mimeType:@"image/png" callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

- (void)deleteUserProfilePicture:(BuddyCompletionCallback)callback
{
    NSString *resource = [NSString stringWithFormat:@"user/%@/profilepicture", self.id];
    
    [self.client DELETE:resource parameters:nil callback:^(id json, NSError *error) {
        callback ? callback(error) : nil;
    }];
}

@end
