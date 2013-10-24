//
//  LockController.h
//  peak
//
//  Created by Hugh Boylan on 8/27/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
@interface SecurityController : UITableViewController <UIAlertViewDelegate, UIActionSheetDelegate, MBProgressHUDDelegate>
{
    UIView *_header;
    
    RKSecurity *_state;
    NSMutableArray *_locks;
    NSMutableArray *_cams;
    
    int _id;
    UIImageView *_imgView;
    UILabel *_name;
    UILabel *_time;
    FUIButton *_button;
    NSTimer *_timer;
}
@end
