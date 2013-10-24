//
//  AuthManager.m
//  peak
//
//  Created by Hugh Boylan on 8/15/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "APIManager.h"
#import "RKUser.h"
#import "FAWebServiceCache.h"

@implementation APIManager

+ (MBProgressHUD*)showHUD:(UIView*)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [hud show:YES];
    return hud;
}

+ (RKUser*)cachedUser
{
    NSError *err = [[NSError alloc] init];
    RKUser *user = [RKUser new];
    NSData *data = [[FAWebServiceCache cachedDataForServiceIdentifier:@"user"] dataUsingEncoding:NSUTF8StringEncoding];
    if(data){
        //Cached data found for user
        NSDictionary *JSON = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        RKMappingOperation *op = [[RKMappingOperation alloc] initWithSourceObject:JSON destinationObject:user mapping:[RKUser mapping]];
        [op performMapping:&err];
    }
    return err? nil : user;
}


+ (void)postRequest:(NSString*)path withParams:(NSDictionary*)params andIndeterminateHUDInView:(UIView*)view
{
    MBProgressHUD *hud;
    if(view != nil) [self showHUD:view];
    RKUser *user = [self cachedUser];
    if(!user) return;
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] initWithDictionary:params];
    [p setValue:user.sessionID forKey:@"sessionID"];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:path parameters:p success:^(AFHTTPRequestOperation *op, id res){
        if(hud != nil) [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *req, NSError *err){
        if(hud != nil){
            hud.animationType = MBProgressHUDModeText;
            hud.labelText = @"Request Failed";
            [hud hide:YES afterDelay:2];
        }
    }];
}

+ (void)postRequest:(NSString*)path withParams:(NSDictionary*)params andCallback:(void (^)(BOOL, NSDictionary*))callback andIndeterminateHUDInView:(UIView*)view
{
    MBProgressHUD *hud;
    if(view != nil) hud = [self showHUD:view];
    RKUser *user = [self cachedUser];
    if(!user) return;
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] initWithDictionary:params];
    [p setValue:user.sessionID forKey:@"sessionID"];
    
    NSURLRequest *request = [[[RKObjectManager sharedManager] HTTPClient] requestWithMethod:@"POST" path:path parameters:p];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *req, NSHTTPURLResponse *res, NSDictionary *JSON) {
        if(hud != nil) [hud hide:YES];
        callback(TRUE, JSON);
    } failure:^(NSURLRequest *req, NSHTTPURLResponse *res, NSError *err, id JSON){
        if(hud != nil){
            hud.animationType = MBProgressHUDModeText;
            hud.labelText = @"Request Failed";
            [hud hide:YES afterDelay:2];
        }
        callback(FALSE, nil);
    }];
    [[[RKObjectManager sharedManager] HTTPClient] enqueueHTTPRequestOperation:operation];
}

+ (void)getRequest:(NSString *)path withParams:(NSDictionary *)params andCallback:(void (^)(BOOL, NSDictionary*))callback andIndeterminateHUDInView:(UIView*)view
{
    MBProgressHUD *hud;
    if(view != nil) hud = [self showHUD:view];
    RKUser *user = [self cachedUser];
    if(!user) return;
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] initWithDictionary:params];
    [p setValue:user.sessionID forKey:@"sessionID"];
    
    NSMutableURLRequest *request = [[[RKObjectManager sharedManager] HTTPClient] requestWithMethod:@"GET" path:path parameters:p];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *req, NSHTTPURLResponse *res, NSDictionary *JSON) {
        if(hud != nil) [hud hide:YES];
        callback(TRUE, JSON);
    } failure:^(NSURLRequest *req, NSHTTPURLResponse *res, NSError *err, id JSON){
        if(hud != nil) [hud hide:YES afterDelay:2];
        callback(FALSE, JSON);
    }];
    [[[RKObjectManager sharedManager] HTTPClient] enqueueHTTPRequestOperation:operation];
}

+ (void)mappedRequest:(NSString*)path withCallback:(void (^)(BOOL success, RKMappingResult *res))callback andIndeterminateHUDInView:(UIView*)view
{
    MBProgressHUD *hud;
    if(view != nil) hud = [self showHUD:view];
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:@{@"sessionID":[self cachedUser].sessionID}
                                              success:^(RKObjectRequestOperation *op, RKMappingResult *res) {
                                                  if(hud != nil) [hud hide:YES];
                                                  callback(1, res);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  if(hud != nil){
                                                      hud.animationType = MBProgressHUDModeText;
                                                      hud.labelText = @"Request Failed";
                                                      [hud hide:YES afterDelay:2];
                                                  }
                                                  callback(0, nil);
                                              }];
}

@end
