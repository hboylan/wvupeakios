//
//  RKArtist.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/15/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKArtist : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, strong) NSNumber *artistid;

+ (RKObjectMapping*)mapping;
@end
