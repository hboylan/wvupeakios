//
//  RKZones.m
//  peak
//
//  Created by Hugh Boylan on 8/6/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKZones.h"

@implementation RKZones

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"name"]];
    return mapping;
}

@end
