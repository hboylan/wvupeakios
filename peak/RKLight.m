//
//  RKLights.m
//  peak
//
//  Created by Hugh Boylan on 8/16/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKLight.h"

@implementation RKLight

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"name", @"level", @"defaultLevel", @"unit", @"on", @"active"]];
    return mapping;
}

@end
