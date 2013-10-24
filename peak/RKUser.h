//
//  RKUser.h
//  peak
//
//  Created by Hugh Boylan on 8/3/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKUser : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy) NSString *email;

+ (RKObjectMapping*)mapping;

@end
