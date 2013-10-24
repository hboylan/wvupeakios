//
//  NexiaCell.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/11/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "NexiaCell.h"

@implementation NexiaCell

- (id)initWithAppliance:(RKAppliance *)appliance
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NexiaCell"];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _appliance = appliance;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        line.backgroundColor = [UIColor secondaryBackground];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor asbestosColor];
        self.textLabel.font = [UIFont boldFlatFontOfSize:16];
        self.textLabel.text = _appliance.name;
        
        _switch = [[FUISwitch alloc] initWithFrame:CGRectMake(240, 8, 60, 25)];
        _switch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_switch addTarget:self action:@selector(powerChanged) forControlEvents:UIControlEventValueChanged];
        _switch.onColor = [UIColor whiteColor];
        _switch.offColor = [UIColor whiteColor];
        _switch.onBackgroundColor = [UIColor pumpkinColor];
        _switch.offBackgroundColor = [UIColor concreteColor];
        _switch.offLabel.font = [UIFont boldFlatFontOfSize:14];
        _switch.onLabel.font = [UIFont boldFlatFontOfSize:14];
        _switch.on = _appliance.leftOn;
        
        [self addSubview:line];
        self.accessoryView = _switch;
    }
    return self;
}

- (void)powerChanged
{
    [APIManager postRequest:[NSString stringWithFormat:@"/appliances/%i", _appliance.id.intValue] withParams:@{@"state": _switch.on? @"on":@"off", @"node":@"left"} andCallback:^(BOOL success, NSDictionary *json){} andIndeterminateHUDInView:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
