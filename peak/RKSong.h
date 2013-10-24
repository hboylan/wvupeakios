//
//  RKSong.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/11/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKSong : NSObject

@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSArray *artist;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *current;
@property (nonatomic, strong) NSNumber *songid;

+ (RKObjectMapping*)mappingFromPlaylist:(BOOL)fromPlaylist;
@end
