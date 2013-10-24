//
//  AppDelegate.h
//  peak
//
//  Created by Hugh Boylan on 8/3/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import "FlatUIKit/FlatUIKit.h"
#import "APIManager.h"
#import "CustomBarBtn.h"
#import "IIViewDeckController.h"
#import "OpenInChromeController.h"
#define IPHONE_LEDGE 50
#define IPAD_LEDGE 500

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navController;
@property (retain, nonatomic) IIViewDeckController *deckController;
@property (retain, nonatomic) UIViewController *loginController;

- (void)mapWithManager:(RKObjectManager*)objectManager;
- (void)toggle:(id)sender;
- (void)showLogin;
- (void)showLoggedIn;
- (BOOL)changeCenter:(NSString*)system;
- (void)reloadCenter;
- (UIView*)getCenterView;
- (BOOL)isTablet;

+ (UIView*)primaryHeaderSection:(NSInteger)section setLabel:(NSString* (^)())fn;
+ (UIView*)secondaryHeaderSection:(NSInteger)section setLabel:(NSString* (^)())fn;
+ (CGFloat)primaryHeaderHeight;
+ (CGFloat)secondaryHeaderHeight:(BOOL)top;
+ (UIView*)selectedCellBackground;
+ (void)stylePrimaryTableView:(UITableView*)tableView;
+ (void)styleSecondaryTableView:(UITableView*)tableView;
+ (BOOL)isDeployment:(double)target;
+ (NSString*)hashFromPin:(NSString*)pin;
+ (void)chromeOrSafariURL:(NSString*)url callbackURL:(NSString*)callback;

@end
