//
//  SliderCell.h
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class LightPrimaryCell;

@interface LightCell : UITableViewCell {
    UILabel *_name;
    FUISwitch *_power;
    UIImageView *_dropdown;
    BOOL _open;
    
    UILabel *_value;
    UISlider *_slider;
}
@property (strong, nonatomic) RKLight *light;
- (id)init;
- (void)setLight:(RKLight*)audio andOpen:(BOOL)open;
- (void)toggle:(BOOL)open animated:(BOOL)animate;
@end