//
//  HealthController.h
//  peak
//
//  Created by Hugh Boylan on 8/24/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GraphPlotter.h"

@interface HealthController : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *_prog;
    FUISegmentedControl *_filterBar;
    GraphPlotter *_graph;
    UIStepper *_stepper;
    
    int *_page;
    NSString *_action;
}
@end
