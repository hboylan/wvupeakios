//
//  RKUser.m
//  peak
//
//  Created by Hugh Boylan on 8/3/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "RKUser.h"

@implementation RKUser

+ (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromArray:@[@"id", @"username", @"realname", @"email", @"sessionID"]];
    return mapping;
}

@end
