//
//  SliderCell.m
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "MediaCell.h"
#import "AppDelegate.h"

@implementation MediaCell

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MediaCell"];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _dropdown = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 15, 15)];
    _dropdown.image = [UIImage imageNamed:@"arrow.png"];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 180, 25)];
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
    
    _volume = [[UILabel alloc] initWithFrame:CGRectMake(20, 46, 30, 22)];
    _volume.autoresizingMask = UIViewAutoresizingNone;
    _volume.backgroundColor = [UIColor clearColor];
    _volume.textColor = [UIColor asbestosColor];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(55, 33, 245, 53)];
    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 100.0;
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderFinished) forControlEvents:UIControlEventTouchUpInside];
    
    _mute = [[FUISwitch alloc] initWithFrame:CGRectMake(20, 86, 75, 25)];
    [_mute addTarget:self action:@selector(muteChanged:) forControlEvents:UIControlEventValueChanged];
    _mute.onColor = [UIColor whiteColor];
    _mute.offColor = [UIColor whiteColor];
    _mute.onBackgroundColor = [UIColor pumpkinColor];
    _mute.offBackgroundColor = [UIColor concreteColor];
    _mute.offLabel.font = [UIFont boldFlatFontOfSize:11];
    _mute.onLabel.font = [UIFont boldFlatFontOfSize:14];
    _mute.offLabel.text = @"UNMUTE";
    _mute.onLabel.text = @"MUTE";
    
    _source = [[FUIButton alloc] initWithFrame:CGRectMake(215, 84, 80, 30)];
    _source.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _source.shadowColor = [UIColor secondaryBackground];
    _source.buttonColor = [UIColor concreteColor];
    _source.shadowHeight = 3.0f;
    _source.cornerRadius = 4.0f;
    _source.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_source setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_source setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [_source addTarget:self action:@selector(sourceChanged) forControlEvents:UIControlEventTouchUpInside];
    
    [self toggle:NO animated:NO];
    [self addSubview:_dropdown];
    [self addSubview:_name];
    [self addSubview:_power];
    [self addSubview:_volume];
    [self addSubview:_slider];
    [self addSubview:_mute];
    [self addSubview:_source];
    return self;
}

- (void)setAudio:(RKAudio *)audio andOpen:(BOOL)open
{
    self.audio = audio;
    _name.text = self.audio.name;
    [self toggle:open animated:NO];
}

- (void)toggle:(BOOL)open animated:(BOOL)animate
{
    _open = open;
    [self updateControls:NO];
    _dropdown.transform = open? CGAffineTransformMakeRotation(3.14159/2):CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:animate? 0.3:0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.frame;
        frame.size.height = 44+80;
        self.frame = frame;
        _slider.hidden = !_open;
        _mute.hidden = !_open;
        _source.hidden = !_open;
    } completion:nil];
}

- (void)updateControls:(BOOL)animated
{
    [_power setOn:self.audio.on animated:animated];
    if(_open){
        [_slider setValue:self.audio.volume.floatValue animated:animated];
        [_mute setOn:self.audio.mute animated:YES];
        [_mute setEnabled:!self.audio.on];
        [_source setTitle:[NSString stringWithFormat:@"Source %@", self.audio.source] forState:UIControlStateNormal];
        [self sliderChanged];
        [self updateColors];
    }
}

- (void)powerChanged:(id)sender {
    [APIManager postRequest:@"/audio" withParams:@{@"id":self.audio.id.stringValue, @"toggle":@"power"} andCallback:^(BOOL success, NSDictionary *res){
        if(success){
            self.audio.on = !self.audio.on;
            self.audio.volume = [NSNumber numberWithInt:_power.on? self.audio.defaultVolume.intValue : 0];
            self.audio.mute = self.audio.mute && _power.on? NO:self.audio.mute;
            [self updateControls:YES];
        }
    } andIndeterminateHUDInView:nil];
}

- (void)muteChanged:(id)sender {
    self.audio.mute = !self.audio.mute;
    [APIManager postRequest:@"/audio" withParams:@{@"id":self.audio.id.stringValue, @"toggle":@"mute"} andIndeterminateHUDInView:nil];
}

- (void)sourceChanged
{
    int src = self.audio.source.intValue+1;
    if(src == 9) src = 1;
    self.audio.source = [NSNumber numberWithInt:src];
    [_source setTitle:[NSString stringWithFormat:@"Source %i", src] forState:UIControlStateNormal];
    _source.enabled = NO;
    [APIManager postRequest:@"/audio" withParams:@{@"id":self.audio.id.stringValue, @"source":self.audio.source.stringValue} andCallback:^(BOOL success, id res){
        _source.enabled = YES;
    } andIndeterminateHUDInView:nil];
}

- (void)sliderChanged
{
    _volume.text = [NSString stringWithFormat:@"%i", (int)_slider.value];
}
- (void)sliderFinished
{
    NSNumber *val = [NSNumber numberWithInt:(int)_slider.value];
    [self updateColors];
    [APIManager postRequest:@"/audio" withParams:@{@"id":self.audio.id.stringValue, @"volume":val.stringValue} andCallback:^(BOOL success, id res){
        self.audio.volume = val;
        self.audio.on = val.boolValue;
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
