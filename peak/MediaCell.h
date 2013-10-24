//
//  SliderCell.h
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class MediaPrimaryCell;

@interface MediaCell : UITableViewCell <UIActionSheetDelegate> {
    FUISwitch *_power;
    UILabel *_name;
    UIImageView *_dropdown;
    BOOL _open;
    
    FUIButton *_source;
    FUISwitch *_mute;
    UISlider *_slider;
    UILabel *_volume;
}
@property (strong, nonatomic) RKAudio *audio;
- (id)init;
- (void)setAudio:(RKAudio*)audio andOpen:(BOOL)open;
- (void)toggle:(BOOL)open animated:(BOOL)animate;
@end