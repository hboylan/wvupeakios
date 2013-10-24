//
//  SideController.h
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "SelectedCell.h"

@interface SideController : UITableViewController {
    NSArray *_order;
    NSDictionary *_systems;
    RKUser *_user;
    SelectedCell *_selected;
}

- (NSString*)getCurrentView;

@end
