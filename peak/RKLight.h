//
//  RKLight.h
//  peak
//
//  Created by Hugh Boylan on 8/16/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLight : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *defaultLevel;
@property (nonatomic, strong) NSNumber *unit;
@property (nonatomic) BOOL on;
@property (nonatomic) BOOL active;

+ (RKObjectMapping*)mapping;

@end
