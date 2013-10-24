//
//  RKSecurity.m
//  peak
//
//  Created by Hugh Boylan on 8/24/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKSecurity.h"

@implementation RKSecurity

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"state", @"timestamp", @"armTimeout"]];
    return mapping;
}

@end
