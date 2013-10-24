//
//  RKAudio.m
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKAudio.h"

@implementation RKAudio

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"name", @"source", @"on", @"mute", @"volume", @"defaultVolume"]];
    return mapping;
}

@end
