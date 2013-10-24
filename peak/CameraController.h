//
//  CameraController.h
//  WVUpeak
//
//  Created by Hugh Boylan on 10/13/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPEGClient.h"
#import "AppDelegate.h"

@interface CameraController : UIViewController <MJPEGClientDelegate> {
    MBProgressHUD *_hud;
    MJPEGClient *_client;
    UIImageView *_camView;
}
- (id)initWithCamera:(RKCamera*)cam;
@end
