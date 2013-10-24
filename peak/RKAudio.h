//
//  RKAudio.h
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKAudio : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *volume;
@property (nonatomic, strong) NSNumber *defaultVolume;
@property (nonatomic, strong) NSNumber *source;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) BOOL mute;
@property (nonatomic) BOOL on;

+ (RKObjectMapping*)mapping;

@end
