//
//  RKAppliance.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/8/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKAppliance : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic) BOOL leftOn;
@property (nonatomic) BOOL rightOn;
@property (nonatomic) int watts;
@property (nonatomic) float kwh;
@property (nonatomic, strong) NSNumber *left;
@property (nonatomic, strong) NSNumber *right;

+ (RKObjectMapping*)mapping;

@end
