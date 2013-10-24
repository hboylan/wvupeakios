//
//  SelectedCell.h
//  peak
//
//  Created by Hugh Boylan on 8/23/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedCell : NSObject

@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger row;

+ (SelectedCell*)cellWithIndexPath:(NSIndexPath*)indexPath;
+ (int)cellOpen:(NSArray*)list atIndexPath:(NSIndexPath*)indexPath;

@end
