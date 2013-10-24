//
//  LockCell.h
//  peak
//
//  Created by Hugh Boylan on 8/28/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "RKLock.h"

@interface LockCell : UITableViewCell <UIAlertViewDelegate> {
    UIImageView *_imgView;
    UILabel *_name;
    UILabel *_time;
    FUIButton *_button;
    int _id;
}
@property (strong, nonatomic) RKLock *lock;
- (id)initWithLock:(RKLock*)lock andUser:(int)userId;
- (void)enabled:(BOOL)state;

@end
