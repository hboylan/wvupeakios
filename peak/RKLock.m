//
//  RKLock.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/7/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKLock.h"

@implementation RKLock

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"name", @"timestamp", @"locked"]];
    return mapping;
}

@end
