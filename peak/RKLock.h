//
//  RKLock.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/7/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLock : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic) BOOL locked;

+ (RKObjectMapping*)mapping;

@end
