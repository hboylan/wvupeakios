//
//  RemoteControl.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/17/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RemoteControl.h"
#import "APIManager.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIButton.h"

@implementation RemoteControl

- (id)initWithFrame:(CGRect)frame
{
    frame.origin.y = frame.size.height;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor primaryBackground];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        swipe.direction = (UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight);
        swipe.delegate = self;
        [self addGestureRecognizer:swipe];
        [self addGestureRecognizer:tap];
        
        FUIButton *home = [[FUIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        home.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        home.titleLabel.font = [UIFont fontWithName:@"lincons" size:22];
        home.titleLabel.text = @"";
        home.buttonColor = [UIColor concreteColor];
        home.shadowColor = [UIColor secondaryBackground];
        home.shadowHeight = 0;
        home.cornerRadius = 0;
        [home setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [home setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        [home addTarget:self action:@selector(showHome) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
        msg.font = [UIFont flatFontOfSize:16];
        msg.textColor = [UIColor asbestosColor];
        msg.text = @"Swipe to move\nTap to select";
        msg.center = self.center;
    }
    return self;
}

- (void)animateOpen
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    } completion:nil];
}

- (void)animateClosed
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.size.height;
        self.frame = frame;
    } completion:nil];
}

- (void)showHome
{
    [self control:@"home"];
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)recognizer
{
    NSLog(@"%u", recognizer.direction);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
