//
//  QolsysCell.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/11/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "QolsysCell.h"

@implementation QolsysCell

- (id)initWithAppliance:(RKAppliance*)appliance
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QolsysCell"];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _appliance = appliance;
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor asbestosColor];
        self.textLabel.font = [UIFont boldFlatFontOfSize:16];
        self.textLabel.text = _appliance.name;
        
        _left = [[FUISwitch alloc] initWithFrame:CGRectMake(175, 8, 60, 27)];
        _left.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_left addTarget:self action:@selector(leftChanged) forControlEvents:UIControlEventValueChanged];
        _left.onColor = [UIColor whiteColor];
        _left.offColor = [UIColor whiteColor];
        _left.onBackgroundColor = [UIColor pumpkinColor];
        _left.offBackgroundColor = [UIColor concreteColor];
        _left.offLabel.font = [UIFont boldFlatFontOfSize:14];
        _left.onLabel.font = [UIFont boldFlatFontOfSize:14];
        _left.on = _appliance.leftOn;
        
        _right = [[FUISwitch alloc] initWithFrame:CGRectMake(240, 8, 60, 27)];
        _right.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_right addTarget:self action:@selector(rightChanged) forControlEvents:UIControlEventValueChanged];
        _right.onColor = [UIColor whiteColor];
        _right.offColor = [UIColor whiteColor];
        _right.onBackgroundColor = [UIColor pumpkinColor];
        _right.offBackgroundColor = [UIColor concreteColor];
        _right.offLabel.font = [UIFont boldFlatFontOfSize:14];
        _right.onLabel.font = [UIFont boldFlatFontOfSize:14];
        _right.on = _appliance.rightOn;
        
        [self addSubview:_left];
        self.accessoryView = _right;
    }
    return self;
}

- (void)leftChanged
{
    [APIManager postRequest:[NSString stringWithFormat:@"/appliances/%i", _appliance.id.intValue] withParams:@{@"state": _left.on? @"on":@"off", @"node":@"left"} andCallback:^(BOOL success, NSDictionary *json){} andIndeterminateHUDInView:nil];
}

- (void)rightChanged
{
    [APIManager postRequest:[NSString stringWithFormat:@"/appliances/%i", _appliance.id.intValue] withParams:@{@"state": _right.on? @"on":@"off", @"node":@"right"} andCallback:^(BOOL success, NSDictionary *json){} andIndeterminateHUDInView:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
