//
//  RKLights.h
//  peak
//
//  Created by Hugh Boylan on 8/16/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLights : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *lights;

+ (RKObjectMapping*)mapping;

@end
