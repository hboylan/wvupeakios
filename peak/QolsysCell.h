//
//  QolsysCell.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/11/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class QolsysPrimaryCell;

@interface QolsysCell : UITableViewCell {
    RKAppliance *_appliance;
    FUISwitch *_left;
    FUISwitch *_right;
}
- (id)initWithAppliance:(RKAppliance*)appliance;

@end
