//
//  AuthManager.h
//  peak
//
//  Created by Hugh Boylan on 8/15/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKUser.h"
#import "RKZones.h"
#import "RKLights.h"
#import "RKLight.h"
#import "RKAudio.h"
#import "RKSecurity.h"
#import "RKLock.h"
#import "RKAppliance.h"
#import "RKCamera.h"
#import "RKSong.h"
#import "RKPlayer.h"
#import "RKVideo.h"
#import "MBProgressHUD.h"

@interface APIManager : NSObject

+ (MBProgressHUD*)showHUD:(UIView*)view;

+ (RKUser*)cachedUser;

+ (void)postRequest:(NSString*)path
         withParams:(NSDictionary*)params
andIndeterminateHUDInView:(UIView*)view;

+ (void)postRequest:(NSString*)path
         withParams:(NSDictionary*)params
        andCallback:(void(^)(BOOL, NSDictionary *json))callback
andIndeterminateHUDInView:(UIView*)view;

+ (void)getRequest:(NSString*)path
        withParams:(NSDictionary*)params
       andCallback:(void(^)(BOOL, NSDictionary *json))callback
andIndeterminateHUDInView:(UIView*)view;

+ (void)mappedRequest:(NSString*)path
         withCallback:(void(^)(BOOL, RKMappingResult *res))callback
  andIndeterminateHUDInView:(UIView*)view;

@end
