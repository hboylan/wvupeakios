//
//  SettingsController.h
//  peak
//
//  Created by Hugh Boylan on 8/23/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FlatUIKit/UITableViewCell+FlatUI.h"

@interface SettingsController : UITableViewController <UITextFieldDelegate> {
    RKUser *_user;
    NSMutableArray *_userVals;
    NSMutableArray *_fields;
    NSString *_passkey;
    NSString *_pinkey;
}
- (void)closeFields;
@end