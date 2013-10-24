//
//  RemoteControl.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/17/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteControl : UIView <UIGestureRecognizerDelegate>
- (void)animateOpen;
- (void)animateClosed;
@end
