//
//  RKAppliance.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/8/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKAppliance.h"

@implementation RKAppliance

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"left", @"right", @"leftOn", @"rightOn", @"watts", @"kwh", @"name", @"timestamp"]];
    return mapping;
}

@end
