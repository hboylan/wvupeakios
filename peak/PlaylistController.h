//
//  PlaylistController.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/13/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedCell.h"
#import "RKPlayer.h"

@interface PlaylistController : UITableViewController <UIGestureRecognizerDelegate> {
    SelectedCell *_selected;
    RKPlayer *_player;
    BOOL *_editing;
}
- (id)initWithPlayer:(RKPlayer*)player;
- (void)update:(RKPlayer*)player;
@end
