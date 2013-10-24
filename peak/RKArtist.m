//
//  RKArtist.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/15/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKArtist.h"

@implementation RKArtist
+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"songid", @"label", @"thumbnail"]];
    return mapping;
}
@end
