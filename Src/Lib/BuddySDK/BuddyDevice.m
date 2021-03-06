/*
 * Copyright (C) 2012 Buddy Platform, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

#import "BuddyDevice.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>

/// <summary>
/// Represents an object that can be used to record device analytics, like device types and app crashes.
/// </summary>

@implementation BuddyDevice

static NSString* _pushToken = @"";

+(NSString*) pushToken {
    return  _pushToken;
}

+(void)pushToken:(NSString*)pushToken{
    _pushToken = pushToken;
    [[BPClient defaultClient] registerPushToken:pushToken callback:^(id device, NSError *error){
        NSLog(@"token registered");
    }];
}

+(NSString *)identifier {

    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[versionCompatibility objectAtIndex:0] intValue] >= 6)
    {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else
    {
        // id for vendor is iOS 6+. Return @"" unless there is demand for pre-iOS 6 support.
        return @"";
    }
}

+ (NSString *)osVersion
{
	return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)appVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)deviceModel
{
    static NSString *deviceModel;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        
        char *model = malloc(size);
        
        sysctlbyname("hw.machine", model, &size, NULL, 0);
        
        deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
        
        free(model);
    });
    
	return deviceModel;
}
/*
- (void)recordInformation:(NSString *)osVersion
               deviceType:(NSString *)deviceType
                 authUser:(NSString *)authUserToken
                 callback:(BuddyDeviceCallback)callback;
{
    [self recordInformation:osVersion deviceType:deviceType authUser:authUser appVersion:@"1.0" latitude:0.0 longitude:0.0 metadata:[self id] callback:callback];
}

- (void)recordInformation:(NSString *)osVersion
               deviceType:(NSString *)deviceType
                 authUser:(NSString *)authUserToken
               appVersion:(NSString *)appVersion
                 latitude:(double)latitude
                longitude:(double)longitude
                 metadata:(NSString *)metadata
                    
                 callback:(BuddyDeviceCallback)callback
{
	[self CheckOS:osVersion];

	[self CheckDevice:deviceType];

	if ([BuddyUtility isNilOrEmpty:appVersion])
	{
		appVersion = @"";
	}

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyDevice"];

	NSString *token = authUser.token;

	[[_client webService] Analytics_DeviceInformation_Add:token DeviceOSVersion:osVersion DeviceType:deviceType Latitude:latitude Longitude:latitude AppName:_client.appName AppVersion:appVersion Metadata:metadata 
												 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														   {
															   if (callback)
															   {
																   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															   }
														   } copy]];
}

- (void)CheckDevice:(NSString *)deviceType
{
	if ([BuddyUtility isNilOrEmpty:deviceType])
	{
		[BuddyUtility throwNilArgException:@"BuddyDevice" reason:@"deviceType"];
	}
}

- (void)CheckOS:(NSString *)osVersion
{
	if ([BuddyUtility isNilOrEmpty:osVersion])
	{
		[BuddyUtility throwNilArgException:@"BuddyDevice" reason:@"osVersion"];
	}
}

- (void)recordCrash:(NSString *)methodName
          osVersion:(NSString *)osVersion
         deviceType:(NSString *)deviceType
           authUser:(NSString *)authUserToken
           callback:(BuddyDeviceRecordCrashCallback)callback;
{
    [self recordCrash:methodName osVersion:osVersion deviceType:deviceType authUser:authUser stackTrace:nil appVersion:nil latitude:0.0 longitude:0.0 metadata:nil  callback:callback];
}


- (void)recordCrash:(NSString *)methodName
          osVersion:(NSString *)osVersion
         deviceType:(NSString *)deviceType
           authUser:(NSString *)authUserToken
         stackTrace:(NSString *)stackTrace
         appVersion:(NSString *)appVersion
           latitude:(double)latitude
          longitude:(double)longitude
           metadata:(NSString *)metadata
              
           callback:(BuddyDeviceCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:methodName])
	{
		[BuddyUtility throwNilArgException:@"BuddyDevice" reason:@"methodName"];
	}

	[self CheckOS:osVersion];

	[self CheckDevice:deviceType];

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyDevice"];

	NSString *token = authUser.token;

	[[_client webService] Analytics_CrashRecords_Add:token AppVersion:appVersion DeviceOSVersion:osVersion DeviceType:deviceType MethodName:methodName StackTrace:stackTrace Metadata:metadata Latitude:latitude Longitude:longitude 
											callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													  {
														  if (callback)
														  {
															  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														  }
													  } copy]];
}
*/
@end