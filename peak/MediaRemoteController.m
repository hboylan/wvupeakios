//
//  MediaRemoteController.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/17/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "MediaRemoteController.h"
#import "AppDelegate.h"

@implementation BottomControls
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(self.selectedSegmentIndex == self.selectedSegmentIndex) [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end

@implementation MediaRemoteController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor primaryBackground];
    
    FUIButton *cancel = [[FUIButton alloc] initWithFrame:CGRectMake(5, 25, 60, 30)];
    cancel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    cancel.buttonColor = [UIColor clearColor];
    cancel.shadowHeight = 0;
    cancel.cornerRadius = 0;
    cancel.titleLabel.font = [UIFont boldFlatFontOfSize:22];
    [cancel setTitle:@"Done" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor asbestosColor] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor asbestosColor] forState:UIControlStateHighlighted];
    [cancel addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    
    FUIButton *home = [[FUIButton alloc] initWithFrame:CGRectMake(285, 25, 30, 30)];
    home.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    home.buttonColor = [UIColor clearColor];
    home.shadowHeight = 0;
    home.cornerRadius = 0;
    home.titleLabel.font = [UIFont fontWithName:@"linecons" size:22];
    [home setTitleColor:[UIColor asbestosColor] forState:UIControlStateNormal];
    [home setTitleColor:[UIColor asbestosColor] forState:UIControlStateHighlighted];
    [home setTitle:@"" forState:UIControlStateNormal];
    [home addTarget:self action:@selector(showHome) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomBar = [[BottomControls alloc] initWithItems:@[@"", @"", @"", @""]];
    [_bottomBar setImage:[UIImage imageNamed:@"back.png"] forSegmentAtIndex:0];
    [_bottomBar setImage:[UIImage imageNamed:@"bars-asbestos.png"] forSegmentAtIndex:3];
    [_bottomBar setWidth:50 forSegmentAtIndex:0];
    [_bottomBar setWidth:50 forSegmentAtIndex:3];
    [_bottomBar setTintColor:[UIColor asbestosColor]];
    _bottomBar.selectedFont = [UIFont fontWithName:@"linecons" size:22];
    _bottomBar.deselectedFont = [UIFont fontWithName:@"linecons" size:22];
    _bottomBar.selectedFontColor = [UIColor asbestosColor];
    _bottomBar.deselectedFontColor = [UIColor asbestosColor];
    _bottomBar.selectedColor = [UIColor clearColor];
    _bottomBar.deselectedColor = [UIColor clearColor];
    _bottomBar.dividerColor = [UIColor clearColor];
    _bottomBar.cornerRadius = 0;
    _bottomBar.selectedSegmentIndex = 0;
    _bottomBar.frame = CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 30);
    _bottomBar.center = CGPointMake(self.view.center.x, _bottomBar.center.y);
    _bottomBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [_bottomBar addTarget:self action:@selector(bottomAction) forControlEvents:UIControlEventValueChanged];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 80)];
    msg.font = [UIFont flatFontOfSize:16];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.textColor = [UIColor asbestosColor];
    msg.text = @"Swipe to move\nTap to select";
    CGPoint point = self.view.center;
    point.y = point.y - 20;
    msg.center = point;
    
    [self.view addSubview:cancel];
    [self.view addSubview:home];
    [self.view addSubview:msg];
    [self.view addSubview:_bottomBar];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    down.direction = UISwipeGestureRecognizerDirectionDown;
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:up];
    [self.view addGestureRecognizer:down];
    [self.view addGestureRecognizer:left];
    [self.view addGestureRecognizer:right];
    [self.view addGestureRecognizer:tap];
}

- (void)hideView
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.delegate hideRemoteController:self];
}

- (void)animateOpen
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    } completion:nil];
}

- (void)animateClosed
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.size.height;
        self.view.frame = frame;
    } completion:nil];
}

- (void)showHome
{
    [self control:@"home"];
}

- (void)bottomAction
{
    NSLog(@"%i", _bottomBar.selectedSegmentIndex);
    if(_bottomBar.selectedSegmentIndex == 0)
        [self control:@"back"];
    else if(_bottomBar.selectedSegmentIndex == 1){ //send text
        UIAlertView *input = [[UIAlertView alloc] initWithTitle:@"Send Text" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
        input.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[input textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
        [[input textFieldAtIndex:0] setReturnKeyType:UIReturnKeySend];
        [[input textFieldAtIndex:0] setTextAlignment:NSTextAlignmentCenter];
        [input show];
    }else if(_bottomBar.selectedSegmentIndex == 2)
        [self control:@"player"];
    else if(_bottomBar.selectedSegmentIndex == 3)
        [self control:@"menu"];
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)recognizer
{
         if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)     [self control:@"up"];
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionDown)   [self control:@"down"];
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)   [self control:@"left"];
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)  [self control:@"right"];
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    [self control:@"select"];
}

- (void)control:(NSString*)cmd
{
    [APIManager postRequest:@"/xbmc" withParams:@{@"control":cmd} andCallback:^(BOOL success, NSDictionary *res){
        
    } andIndeterminateHUDInView:nil];
}

#pragma AlertView delegate
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return [[alertView textFieldAtIndex:0] text].length > 0;
}


//User has chosen to arm/disarm the system
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex) return;
    [APIManager postRequest:@"/xbmc" withParams:@{@"control":@"message", @"text":[[alertView textFieldAtIndex:0] text]} andCallback:^(BOOL success, NSDictionary *res){
        
    } andIndeterminateHUDInView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
