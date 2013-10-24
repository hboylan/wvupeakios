//
//  RKZones.h
//  peak
//
//  Created by Hugh Boylan on 8/6/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKZones : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;

+ (RKObjectMapping*)mapping;

@end
