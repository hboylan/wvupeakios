//
//  RKPlayer.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/12/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKPlayer.h"

@implementation RKPlayer

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"isSong", @"progress", @"playlistid", @"position", @"playlist"]];
    return mapping;
}

@end
