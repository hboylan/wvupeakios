//
//  SliderCell.m
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "LightCell.h"

@implementation LightCell

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LightCell"];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _dropdown = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 15, 15)];
    _dropdown.image = [UIImage imageNamed:@"arrow.png"];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 180, 27)];
    _name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _name.backgroundColor = [UIColor clearColor];
    _name.textColor = [UIColor asbestosColor];
    _name.font = [UIFont boldFlatFontOfSize:16];
    
    _power = [[FUISwitch alloc] initWithFrame:CGRectMake(240, 8, 60, 25)];
    _power.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_power addTarget:self action:@selector(powerChanged:) forControlEvents:UIControlEventValueChanged];
    _power.onColor = [UIColor whiteColor];
    _power.offColor = [UIColor whiteColor];
    _power.onBackgroundColor = [UIColor pumpkinColor];
    _power.offBackgroundColor = [UIColor concreteColor];
    _power.offLabel.font = [UIFont boldFlatFontOfSize:14];
    _power.onLabel.font = [UIFont boldFlatFontOfSize:14];
    
    _value = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, 30, 22)];
    _value.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _value.backgroundColor = [UIColor clearColor];
    _value.textColor = [UIColor asbestosColor];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(55, 33, 245, 53)];
    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 100.0;
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderFinished) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateControls:NO];
    [self addSubview:_dropdown];
    [self addSubview:_name];
    [self addSubview:_power];
    [self addSubview:_value];
    [self addSubview:_slider];
    return self;
}

- (void)setLight:(RKLight*)light andOpen:(BOOL)open
{
    self.light = light;
    _name.text = self.light.name;
    [self toggle:open animated:NO];
}

- (void)toggle:(BOOL)open animated:(BOOL)animate
{
    _open = open;
    [self updateControls:NO];
    _dropdown.transform = open? CGAffineTransformMakeRotation(3.14159/2):CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:animate? 0.3:0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.frame;
        frame.size.height = 88;
        self.frame = frame;
        _value.hidden = !_open;
        _slider.hidden = !_open;
    } completion:nil];
}

- (void)updateControls:(BOOL)animate
{
    [_power setOn:self.light.on animated:animate];
    [_slider setValue:self.light.level.floatValue animated:animate];
    [self sliderChanged];
    [self updateColors];
}

- (void)powerChanged:(id)sender {
    [APIManager postRequest:@"/lights" withParams:@{@"id":self.light.id.stringValue, @"toggle":@YES} andCallback:^(BOOL success, NSDictionary *res){
        if(success){
            self.light.on = _power.on;
            self.light.level = [NSNumber numberWithInt:_power.on? self.light.defaultLevel.intValue : 0];
            [self updateControls:YES];
        }
    } andIndeterminateHUDInView:nil];
}

- (void)sliderChanged
{
    _value.text = [NSString stringWithFormat:@"%i", (int)_slider.value];
}

- (void)sliderFinished
{
    NSNumber *lvl = [NSNumber numberWithInt:(int)_slider.value];
    [APIManager postRequest:@"/lights" withParams:@{@"id":self.light.id, @"level":lvl.stringValue} andCallback:^(BOOL success, id res){
        if(success){
            self.light.level = lvl;
            self.light.on = lvl.boolValue;
        }
        [self updateControls:YES];
    } andIndeterminateHUDInView:nil];
}

- (void)updateColors
{
    [_slider configureFlatSliderWithTrackColor:_slider.value? [UIColor whiteColor]:[UIColor concreteColor]
                                     progressColor:[UIColor pumpkinColor]
                                        thumbColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
