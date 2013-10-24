//
//  AppDelegate.m
//  peak
//
//  Created by Hugh Boylan on 8/3/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "SideController.h"
#import "LightController.h"
#import "EnergyController.h"
#import "SpeakerController.h"
#import "MediaController.h"
#import "SecurityController.h"
#import "SettingsController.h"
#import "HealthController.h"
#import "SecurityController.h"
#import "FAWebServiceCache.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //Reset user cache object
//    [FAWebServiceCache saveCacheWithIdentifier:@"user" data:nil];
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://192.168.1.106:8000"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    //Init Mappings
    [self mapWithManager:[[RKObjectManager alloc] initWithHTTPClient:client]];
    
    //Set up views for view deck controller
    self.loginController = [[LoginController alloc] init];
    
    //Set up navController for center view
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.loginController];
    [self.navController setNavigationBarHidden:YES];
    [self.navController.navigationBar configureFlatNavigationBarWithColor:[UIColor pumpkinColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIStepper appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    BOOL tablet = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) isTablet];
    self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.navController leftViewController:nil];
    self.deckController.leftSize = tablet? IPAD_LEDGE : IPHONE_LEDGE;
    self.deckController.rightSize = tablet? IPAD_LEDGE : IPHONE_LEDGE;
    self.deckController.enabled = !tablet;
    
    [APIManager postRequest:@"/auth" withParams:nil andCallback:^(BOOL success, id res) {
        return success? [self showLoggedIn] : [self showLogin];
    } andIndeterminateHUDInView:nil];
    
    self.window.rootViewController = self.deckController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)toggle:(id)sender
{
    [self.deckController toggleBottomViewAnimated:YES completion:^(IIViewDeckController *deck, BOOL success){
        if(![self isTablet]) return;
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            CGRect frame = self.navController.view.frame;
//            self.navController.view.frame = CGRectInset(frame, 0, IPAD_LEDGE);
//        } completion:nil];
    }];
}

- (void)showLogin
{
    [self.navController setNavigationBarHidden:YES];
    [self.deckController closeLeftViewAnimated:YES];
    self.navController.viewControllers = @[self.loginController];
    self.deckController.leftController = nil;
}

- (void)showLoggedIn
{
    [self.navController setNavigationBarHidden:NO];
    self.navController.viewControllers = @[[[LightController alloc] init]];
    self.deckController.leftController = [[SideController alloc] init];
    [self.deckController openLeftView];
}

- (BOOL)isTablet
{
    return [[UIDevice currentDevice] userInterfaceIdiom]? YES:NO;
}

- (BOOL)changeCenter:(NSString *)system
{
    UIViewController *view;
    
    if([system isEqualToString:@"Appliances"])
        view = [[EnergyController alloc] init];
    else if([system isEqualToString:@"Lights"])
        view = [[LightController alloc] init];
    else if([system isEqualToString:@"Speakers"])
        view = [[SpeakerController alloc] init];
    else if([system isEqualToString:@"Media"])
        view = [[MediaController alloc] init];
    else if([system isEqualToString:@"Security"])
        view = [[SecurityController alloc] init];
    else if([system isEqualToString:@"Settings"])
        view = [[SettingsController alloc] init];
    else if([system isEqualToString:@"Health"])
        view = [[HealthController alloc] init];
    
    self.navController.viewControllers = @[view];
    [self.navController setNavigationBarHidden:NO];
    [self.deckController closeLeftViewAnimated:YES];
    return view != nil;
}

- (void)reloadCenter
{
    SideController *side = (SideController*)self.deckController.leftController;
    if(side) [self changeCenter:[side getCurrentView]];
}

- (UIView*)getCenterView
{
    return self.deckController.centerController.view;
}

+ (UIView*)primaryHeaderSection:(NSInteger)section setLabel:(NSString* (^)())fn
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor secondaryBackground];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldFlatFontOfSize:15];
    label.textColor = [UIColor wetAsphaltColor];
    label.text = fn();
    
    [view addSubview:label];
    return view;
}
+ (UIView*)secondaryHeaderSection:(NSInteger)section setLabel:(NSString* (^)())fn
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor midnightBlueColor];

    UILabel *label = [[UILabel alloc] initWithFrame:section? CGRectMake(10, 0, 200, 30):CGRectMake(10, 20, 200, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldFlatFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.text = fn();
    [view addSubview:label];

    if(!section){ //iOS 7 fix for tableviewcontroller under status bar
        UIView *filler = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)];
        filler.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        filler.backgroundColor = [UIColor wetAsphaltColor];
        [view addSubview:filler];
    }
    return view;
}

+ (CGFloat)primaryHeaderHeight
{
    return 30;
}

+ (CGFloat)secondaryHeaderHeight:(BOOL)top
{
    float height = [self primaryHeaderHeight];
    return top? height:height+20;
}

+ (void)stylePrimaryTableView:(UITableView *)tableView
{
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor primaryBackground];
    tableView.separatorColor = [UIColor secondaryBackground];
}

+ (void)styleSecondaryTableView:(UITableView *)tableView
{
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor wetAsphaltColor];
    tableView.separatorColor = [UIColor midnightBlueColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollsToTop = NO;
}

+ (UIView*)selectedCellBackground
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor pumpkinColor];
//    bgView.layer.masksToBounds = YES;
    return bgView;
}

+ (BOOL)isDeployment:(double)target
{
    return [[[UIDevice currentDevice] systemName] isEqualToString:[NSString stringWithFormat:@"%f", target]];
}

- (void)mapWithManager:(RKObjectManager*)objectManager
{
    NSMutableIndexSet *codes = [[NSMutableIndexSet alloc] initWithIndexSet:[NSIndexSet indexSetWithIndex:200]];
    [codes addIndexes:[NSIndexSet indexSetWithIndex:201]];
    [codes addIndexes:[NSIndexSet indexSetWithIndex:401]];
    
    // Register our mappings with the provider using a response descriptor
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKUser mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/users"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKUser mapping]
                                                                                      method:RKRequestMethodPOST
                                                                                 pathPattern:@"/login"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKZones mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/zones"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKLights mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/lights"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKAudio mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/audio"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKSecurity mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/security"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKLock mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/locks"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKAppliance mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/appliances"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKCamera mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/cameras"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKPlayer mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/xbmc"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKSong mappingFromPlaylist:NO]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/xbmc/songs"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKSong mappingFromPlaylist:YES]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/xbmc/playlist/0"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[RKVideo mapping]
                                                                                      method:RKRequestMethodGET
                                                                                 pathPattern:@"/xbmc/playlist/1"
                                                                                     keyPath:nil
                                                                                 statusCodes:codes]];
}

+ (NSString*)hashFromPin:(NSString*)pin
{
    NSData *input = [pin dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(input.bytes, input.length, hash);
    NSMutableString *pinkey = [NSMutableString string];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; ++i)   [pinkey appendFormat:@"%02x", hash[i]];
    return pinkey;
}

+ (void)chromeOrSafariURL:(NSString *)httpURL callbackURL:(NSString*)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", httpURL]];
    OpenInChromeController *chrome = [[OpenInChromeController alloc] init];
    if(![chrome openInChrome:url
             withCallbackURL:[NSURL URLWithString:[NSString stringWithFormat:@"wvupeak://%@", callback]]
                createNewTab:YES])
        [[UIApplication sharedApplication] openURL:url];
    chrome = nil;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"open base url: %@", url.baseURL);
    return [@[@"Health"] containsObject:url.baseURL]? [self changeCenter:url.baseURL]:NO;
}

@end
