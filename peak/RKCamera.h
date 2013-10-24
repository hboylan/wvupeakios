//
//  RKCamera.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/8/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKCamera : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *host;

+ (RKObjectMapping*)mapping;
@end
