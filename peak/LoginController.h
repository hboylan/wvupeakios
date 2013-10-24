//
//  MasterViewController.h
//  peak
//
//  Created by Hugh Boylan on 8/3/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class DetailViewController;

@interface LoginController : UIViewController <UITextFieldDelegate> {
    NSMutableArray *_objects;
    UIImageView *_imgView;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) FUIButton *login;
- (IBAction)login:(id)sender;

@end
