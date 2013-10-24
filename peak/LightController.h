//
//  LightController.h
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"
#import "MBProgressHUD.h"

@interface LightController : UITableViewController <MBProgressHUDDelegate> {
    NSArray *_zones;
    NSMutableArray *_openLights;
}
@end
