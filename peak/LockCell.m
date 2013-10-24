//
//  LockCell.m
//  peak
//
//  Created by Hugh Boylan on 8/28/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "LockCell.h"
#import "AppDelegate.h"

@implementation LockCell

- (id)initWithLock:(RKLock *)lock andUser:(int)userId
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 80)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.lock = lock;
        _id = userId;

        _name = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 180, 40)];
        _name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _name.backgroundColor = [UIColor clearColor];
        _name.textColor = [UIColor asbestosColor];
        _name.font = [UIFont boldFlatFontOfSize:18];
        _name.text = self.lock.name;
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 180, 40)];
        _time.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _time.backgroundColor = [UIColor clearColor];
        _time.textColor = [UIColor asbestosColor];
        _time.font = [UIFont boldFlatFontOfSize:14];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 50, 50)];
        
        _button = [[FUIButton alloc] initWithFrame:CGRectMake(220, 25, 80, 30)];
        _button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth;
        _button.shadowColor = [UIColor secondaryBackground];
        _button.buttonColor = [UIColor concreteColor];
        _button.cornerRadius = 4.0f;
        _button.shadowHeight = 3.0f;
        _button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        [_button addTarget:self action:@selector(toggleSecurity) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        
        [self addSubview:_imgView];
        [self addSubview:_name];
        [self addSubview:_time];
        [self addSubview:_button];
        [self updateState];
    }
    return self;
}

- (void)enabled:(BOOL)state
{
    NSLog(@"Set %@", state?@"enabled":@"disabled");
    _button.enabled = state;
}

- (void)updateState
{
    _time.text = self.lock.timestamp;
    if(self.lock.locked){
        [_imgView setImage:[UIImage imageNamed:@"lock.png"]];
        [_button setTitle:@"Unlock" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.buttonColor = [UIColor pumpkinColor];
    }else{
        [_imgView setImage:[UIImage imageNamed:@"unlock.png"]];
        [_button setTitle:@"Lock" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor primaryBackground] forState:UIControlStateNormal];
        _button.buttonColor = [UIColor concreteColor];
    }
}

- (void)toggleSecurity
{
    NSString *title = [NSString stringWithFormat:self.lock.locked? @"Unlock %@":@"Lock %@", self.lock.name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:self.lock.locked? @"Unlock":@"Lock", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alert textFieldAtIndex:0] setTextAlignment:NSTextAlignmentCenter];
    [alert show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return [[alertView textFieldAtIndex:0] text].length == 4? YES : NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex) return;
    NSString *pinkey = [AppDelegate hashFromPin:[[alertView textFieldAtIndex:0] text]];
    [APIManager postRequest:[NSString stringWithFormat:@"/security/%i", self.lock.id.intValue] withParams:@{@"id":@(_id), @"pinkey":pinkey, @"state":(!self.lock.locked == YES)? @"on":@"off"} andCallback:^(BOOL success, NSDictionary *json){
        if(!success) //Invalid pinkey
            [[[UIAlertView alloc] initWithTitle:@"Unauthorized" message:[json valueForKey:@"error"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        else
        {
            self.lock.locked = !self.lock.locked;
            self.lock.timestamp = (NSString*)[json valueForKey:@"timestamp"];
            [self updateState];
        }
    } andIndeterminateHUDInView:nil];
}

@end
