//
//  NexiaCell.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/11/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FUISwitch.h"

@interface NexiaCell : UITableViewCell {
    FUISwitch *_switch;
    RKAppliance *_appliance;
}
- (id)initWithAppliance:(RKAppliance*)appliance;

@end
