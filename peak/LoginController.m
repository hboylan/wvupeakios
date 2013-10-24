//
//  MasterViewController.m
//  peak
//
//  Created by Hugh Boylan on 8/3/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "LoginController.h"
#import "FAWebServiceCache.h"
#import "SideController.h"

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor midnightBlueColor];
    
    BOOL tablet = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) isTablet];
    CGPoint anchor = CGPointMake(0.5, 0);
    CGFloat originX = self.view.frame.size.width/2;
    CGFloat originY = tablet? 20:0;
    CGFloat ctrlWidth = tablet? 300:200;
    CGFloat ctrlHeight = tablet? 40:30;
    
    _imgView = [[UIImageView alloc] initWithFrame:tablet? CGRectMake(0, 0, 400, 200):CGRectMake(0, 0, 240, 118)];
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _imgView.layer.anchorPoint = anchor;
    _imgView.center = CGPointMake(originX, originY);
    _imgView.image = [UIImage imageNamed:@"peak-logo.png"];

    originY = originY + _imgView.frame.size.height + 10;
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ctrlWidth, ctrlHeight)];
    self.username.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.username.layer.anchorPoint = anchor;
    self.username.center = CGPointMake(originX, originY);
    self.username.delegate = self;
    self.username.autocorrectionType = UITextAutocorrectionTypeNo;
    self.username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.username.returnKeyType = UIReturnKeyNext;
    self.username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.username.font = [UIFont flatFontOfSize:16];
    self.username.textColor = [UIColor asbestosColor];
    self.username.backgroundColor = [UIColor primaryBackground];
    self.username.placeholder = @"Username";
    
    originY = originY + self.username.frame.size.height + 1;
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ctrlWidth, ctrlHeight)];
    self.password.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.password.layer.anchorPoint = anchor;
    self.password.center = CGPointMake(originX, originY);
    self.password.delegate = self;
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    self.password.returnKeyType = UIReturnKeyGo;
    self.password.secureTextEntry = YES;
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.font = [UIFont flatFontOfSize:16];
    self.password.textColor = [UIColor asbestosColor];
    self.password.backgroundColor = [UIColor primaryBackground];
    self.password.placeholder = @"Password";
    
    originY = originY + self.password.frame.size.height + 10;
    self.login = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, ctrlWidth, ctrlHeight)];
    self.login.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.login.layer.anchorPoint = anchor;
    self.login.center = CGPointMake(originX, originY);
    self.login.shadowColor = [UIColor secondaryBackground];
    self.login.buttonColor = [UIColor concreteColor];
    self.login.cornerRadius = 4.0f;
    self.login.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.login setTitle:@"Login" forState:UIControlStateNormal];
    [self.login setTitleColor:[UIColor primaryBackground] forState:UIControlStateNormal];
    [self.login setTitleColor:[UIColor pumpkinColor] forState:UIControlStateSelected];
    [self.login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_imgView];
    [self.view addSubview:self.username];
    [self.view addSubview:self.password];
    [self.view addSubview:self.login];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.username)
        [self.password becomeFirstResponder];
    else if(textField == self.password)
        [self login:self];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
    NSURLRequest *request = [[[RKObjectManager sharedManager] HTTPClient] requestWithMethod:@"POST" path:@"/login" parameters:@{@"username":self.username.text, @"password":self.password.text}];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *req, NSHTTPURLResponse *res, NSDictionary *JSON) {
        //parse JSON data to UTF8 str
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSON? JSON:@{} options:0 error:nil];
        NSString *str = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        //save user obj to cache (should encrpyt
        [FAWebServiceCache saveCacheWithIdentifier:@"user" data:str];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showLoggedIn];
    } failure:^(NSURLRequest *req, NSHTTPURLResponse *res, NSError *err, id JSON){
        [[[UIAlertView alloc] initWithTitle:@"Login Error" message:[JSON objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }];
    
    [[[RKObjectManager sharedManager] HTTPClient] enqueueHTTPRequestOperation:operation];

    //clear password field
//    self.password.text = @"";
}

@end
