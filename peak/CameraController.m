//
//  CameraController.m
//  WVUpeak
//
//  Created by Hugh Boylan on 10/13/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "CameraController.h"

@interface CameraController ()

@end

@implementation CameraController

- (id)initWithCamera:(RKCamera *)cam
{
    self = [super init];
    if (self) {
        _client = [[MJPEGClient alloc] initWithURL:cam.host delegate:self timeout:5.0];
        _client.userName = @"Admin";
        _client.password = @"1234";
        [_client start];
        
//        CGFloat width = self.view.frame.size.width;
//        CGRect frame = CGRectMake(0, 0, width, width/(16.0/9.0));
//        _camView = [[UIImageView alloc] initWithFrame:frame];
        _camView.backgroundColor = [UIColor primaryBackground];
        _camView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

#pragma mark - MBProgressHUD view delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hud removeFromSuperview];
    _hud = nil;
}

- (void)hideCamView
{
    [_camView removeFromSuperview];
    _camView = nil;
    _client = nil;
}

#pragma mark - MJPEGClient view delegate
- (void)mjpegClient:(MJPEGClient *)client didReceiveImage:(UIImage *)image
{
    [_camView setImage:image];
}

- (void)mjpegClient:(MJPEGClient *)client didReceiveError:(NSError *)error
{
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.animationType = MBProgressHUDModeText;
    _hud.labelFont = [UIFont flatFontOfSize:18];
    _hud.labelText = @"Camera Disconnected";
    [self.view addSubview:_hud];
    
    [self hideCamView];
    [_hud show:YES];
    [_hud hide:YES afterDelay:2];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(_client) [_client stop];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if(_client == nil) return;
    float width = self.view.frame.size.width;
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _camView.frame = isPortrait? CGRectMake(0, 0, width, width/(16.0/9.0)):self.view.frame;
    } completion:nil];
    [_client start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
