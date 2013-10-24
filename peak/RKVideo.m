//
//  RKVideo.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/18/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKVideo.h"

@implementation RKVideo
+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"label", @"type", @"file", @"thumbnail", @"duration", @"resume"]];
    return mapping;
}
@end
