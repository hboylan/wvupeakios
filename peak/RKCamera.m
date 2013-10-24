//
//  RKCamera.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/8/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKCamera.h"

@implementation RKCamera

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"name", @"host"]];
    return mapping;
}

@end
