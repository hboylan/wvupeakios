//
//  RKVideo.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/18/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKVideo : NSObject
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSDictionary *resume;
+ (RKObjectMapping*)mapping;
@end
