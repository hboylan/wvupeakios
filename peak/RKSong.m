//
//  RKSong.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/11/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKSong.h"

@implementation RKSong
+ (RKObjectMapping*)mappingFromPlaylist:(BOOL)fromPlaylist
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    if(fromPlaylist)
        [mapping addAttributeMappingsFromDictionary:@{@"album":@"album", @"label":@"label", @"artist":@"artist", @"id":@"songid", @"duration":@"duration", @"thumbnail":@"thumbnail"}];
    else
        [mapping addAttributeMappingsFromArray:@[@"album", @"label", @"artist", @"songid", @"duration", @"thumbnail"]];
    return mapping;
}
@end
