//
//  HealthController.m
//  peak
//
//  Created by Hugh Boylan on 8/24/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "HealthController.h"

@interface HealthController ()

@end

@implementation HealthController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _page = 0;
    _action = @"distance";
    
    self.view.backgroundColor = [UIColor primaryBackground];
    self.title = @"Health - Fitbit";
    self.navigationItem.leftBarButtonItem = [CustomBarBtn create];
    
    [APIManager getRequest:@"/fitbit/hasToken" withParams:@{} andCallback:^(BOOL success, NSDictionary* res){
        if([res objectForKey:@"success"])
            [self loadFitbitProfile];
        else
        {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.animationType = MBProgressHUDModeText;
            hud.labelText = @"Requires Fitbit account";
            [self.view addSubview:hud];
            [hud show:YES];
        }
    } andIndeterminateHUDInView:self.view];
}

- (void)loadFitbitProfile
{
    CGRect frame = self.view.frame;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    
    CGFloat xOrigin = imgView.frame.origin.x+imgView.frame.size.width+20;
    CGFloat yOrigin = 20;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, frame.size.width-imgView.frame.size.width-30, 30)];
    name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    name.textAlignment = NSTextAlignmentLeft;
    name.backgroundColor = [UIColor clearColor];
    name.textColor = [UIColor asbestosColor];
    name.font = [UIFont boldSystemFontOfSize:16];
    
    yOrigin = yOrigin + name.frame.size.height;
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, frame.size.width-imgView.frame.size.width-30, 30)];
    location.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    location.textAlignment = NSTextAlignmentLeft;
    location.backgroundColor = [UIColor clearColor];
    location.textColor = [UIColor asbestosColor];
    location.font = [UIFont boldSystemFontOfSize:14];
    
    yOrigin = yOrigin + location.frame.size.height;
    UILabel *bmi = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, frame.size.width-imgView.frame.size.width-30, 30)];
    bmi.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    bmi.textAlignment = NSTextAlignmentLeft;
    bmi.backgroundColor = [UIColor clearColor];
    bmi.textColor = [UIColor asbestosColor];
    bmi.font = [UIFont boldSystemFontOfSize:14];
    
    //SegmentedControl
    _filterBar = [[FUISegmentedControl alloc] initWithItems:@[@"Distance", @"Sleep", @"Weight"]];
    _filterBar.selectedFont = [UIFont boldFlatFontOfSize:16];
    _filterBar.selectedFontColor = [UIColor primaryBackground];
    _filterBar.selectedColor = [UIColor pumpkinColor];
    _filterBar.deselectedFont = [UIFont flatFontOfSize:16];
    _filterBar.deselectedFontColor = [UIColor primaryBackground];
    _filterBar.deselectedColor = [UIColor concreteColor];
    _filterBar.dividerColor = [UIColor primaryBackground];
    _filterBar.cornerRadius = 0;
    _filterBar.selectedSegmentIndex = 0;
    _filterBar.frame = CGRectMake(0, imgView.frame.size.height, frame.size.width, 30);
    _filterBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_filterBar addTarget:self action:@selector(filter) forControlEvents:UIControlEventValueChanged];
    
    CGRect stepFrame = CGRectMake(0, frame.size.height-30, 100, 40);
    stepFrame.origin.x = self.view.center.x-50;
    _stepper = [[UIStepper alloc] initWithFrame:stepFrame];
    _stepper.maximumValue = 0.0f;
    _stepper.minimumValue = -9999.0f;
    [_stepper addTarget:self action:@selector(stepperAction) forControlEvents:UIControlEventValueChanged];
    [_stepper configureFlatStepperWithColor:[UIColor pumpkinColor]
                            highlightedColor:[UIColor secondaryBackground]
                               disabledColor:[UIColor asbestosColor]
                                   iconColor:[UIColor whiteColor]];
    
    [self.view addSubview:imgView];
    [self.view addSubview:name];
    [self.view addSubview:location];
    [self.view addSubview:bmi];
    
    [APIManager getRequest:@"/fitbit/profile" withParams:nil andCallback:^(BOOL success, NSDictionary *json){
        NSDictionary *user = [json objectForKey:@"user"];
        [imgView setImageWithURL:[NSURL URLWithString:[user objectForKey:@"avatar"]]];
        name.text = [user objectForKey:@"fullName"];
        location.text = [NSString stringWithFormat:@"%@, %@", [user objectForKey:@"city"], [user objectForKey:@"state"]];
        
        NSNumber *bmiVal = [self calculateBMIForWeight:[user valueForKey:@"weight"] andHeight:[user valueForKey:@"height"]];
        bmi.text = [NSString stringWithFormat:@"BMI: %2.1f", [bmiVal floatValue]];
        
        [APIManager getRequest:@"/fitbit/distance/0" withParams:@{} andCallback:^(BOOL success, NSDictionary *json){
            CGFloat y = imgView.frame.size.height+_filterBar.frame.size.height;
            CGRect graphFrame = CGRectMake(0, y, frame.size.width, frame.size.height-y-_stepper.frame.size.height);
            _graph = [[GraphPlotter alloc] initPlotWithFrame:graphFrame];
            [_graph setData:(NSArray*)json withAction:_action andRefresh:NO];
            
            [self.view addSubview:_filterBar];
            [self.view addSubview:_graph.hostView];
            [self.view addSubview:_stepper];
        } andIndeterminateHUDInView:nil];
    } andIndeterminateHUDInView:nil];
}

- (void)filter
{
    _stepper.value = 0.0f;
    _action = @"distance";
    if(_filterBar.selectedSegmentIndex == 1)
        _action = @"sleep";
    else if(_filterBar.selectedSegmentIndex == 2)
        _action = @"weight";
    
    NSString *reqStr = [NSString stringWithFormat:@"/fitbit/%@/%i", _action, (int)_stepper.value*(-1)];
    [APIManager getRequest:reqStr withParams:@{} andCallback:^(BOOL success, NSDictionary *json){
        [_graph setData:(NSArray*)json withAction:_action andRefresh:YES];
    } andIndeterminateHUDInView:self.view];
}

- (void)stepperAction
{
    NSString *reqStr = [NSString stringWithFormat:@"/fitbit/%@/%i", _action, (int)_stepper.value*(-1)];
    [APIManager getRequest:reqStr withParams:@{} andCallback:^(BOOL success, NSDictionary *json){
        [_graph setData:(NSArray*)json withAction:_action andRefresh:YES];
    } andIndeterminateHUDInView:self.view];
}

- (NSNumber*)calculateBMIForWeight:(NSNumber*)weight andHeight:(NSNumber*)height
{
    return [NSNumber numberWithFloat:(weight.doubleValue/(height.doubleValue*height.doubleValue))*703];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	hud = nil;
}

@end
