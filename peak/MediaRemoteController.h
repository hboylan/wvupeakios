//
//  MediaRemoteController.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/17/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUISegmentedControl.h"

#pragma mark - BottomControls
@interface BottomControls : FUISegmentedControl
@end


#pragma mark - MediaRemote controller
@protocol RemoteControllerDelegate;

@interface MediaRemoteController : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate> {
    BottomControls *_bottomBar;
}
@property (assign) id <RemoteControllerDelegate> delegate;
@end

@protocol RemoteControllerDelegate <NSObject>
- (void)hideRemoteController:(MediaRemoteController*)controller;
@end
