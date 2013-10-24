//
//  RKLights.m
//  peak
//
//  Created by Hugh Boylan on 8/16/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKLights.h"

@implementation RKLights

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"name", @"lights"]];
    return mapping;
}

@end
