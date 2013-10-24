//
//  CustomBarBtn.m
//  peak
//
//  Created by Hugh Boylan on 8/27/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "CustomBarBtn.h"
#import "AppDelegate.h"

@implementation CustomBarBtn

+ (UIBarButtonItem*)create
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [btn addTarget:app.deckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"bars.png"] forState:UIControlStateNormal];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
