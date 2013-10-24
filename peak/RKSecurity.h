//
//  RKSecurity.h
//  peak
//
//  Created by Hugh Boylan on 8/24/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKSecurity : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, strong) NSNumber *armTimeout;
@property (nonatomic, strong) NSString *state;

+ (RKObjectMapping*)mapping;

@end
