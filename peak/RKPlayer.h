//
//  RKPlayer.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/12/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKPlayer : NSObject

@property (nonatomic) BOOL isSong;
@property (nonatomic, strong) NSNumber *playlistid;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) NSNumber *progress;
@property (nonatomic, strong) NSMutableArray *playlist;

+ (RKObjectMapping*)mapping;
@end
