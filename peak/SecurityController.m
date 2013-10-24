//
//  SecurityController
//  peak
//
//  Created by Hugh Boylan on 8/27/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "SecurityController.h"
#import "AppDelegate.h"
#import "LockCell.h"
#import "CameraController.h"

@interface SecurityController ()

@end

@implementation SecurityController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [APIManager getRequest:@"/security" withParams:@{} andCallback:^(BOOL success, NSDictionary *json){
            //Security state
            _state = [RKSecurity new];
            RKMappingOperation *op = [[RKMappingOperation alloc] initWithSourceObject:[json objectForKey:@"state"] destinationObject:_state mapping:[RKSecurity mapping]];
            [op performMapping:nil];
            
            //Locks list
            _locks = [NSMutableArray new];
            for (id l in [json objectForKey:@"locks"]) {
                RKLock *lock = [RKLock new];
                RKMappingOperation *op = [[RKMappingOperation alloc] initWithSourceObject:l destinationObject:lock mapping:[RKLock mapping]];
                [op performMapping:nil];
                [_locks addObject:lock];
            }
            _cams = [NSMutableArray new];
            //Cameras list
            for (id c in [json objectForKey:@"cameras"]) {
                RKCamera *cam = [RKCamera new];
                RKMappingOperation *op = [[RKMappingOperation alloc] initWithSourceObject:c destinationObject:cam mapping:[RKCamera mapping]];
                [op performMapping:nil];
                [_cams addObject:cam];
            }
            _button.shadowColor = [UIColor secondaryBackground];
            [self updateSecurity];
            [self.tableView reloadData];
        } andIndeterminateHUDInView:self.tableView];
        _id = [APIManager cachedUser].id.intValue;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [AppDelegate stylePrimaryTableView:self.tableView];
    self.title = @"Security";
    self.navigationItem.leftBarButtonItem = [CustomBarBtn create];
    
    //Setup security cam btn
    UIBarButtonItem *cam = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(chooseCamera)];
    [cam configureFlatButtonWithColor:[UIColor clearColor] highlightedColor:[UIColor clearColor] cornerRadius:0];
    [cam setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = cam;
    
    //Setup security table header
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    _header.autoresizesSubviews = UIViewAutoresizingFlexibleWidth;
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _imgView.center = _header.center;
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _header.frame.size.width, 20)];
    _name.center = CGPointMake(_header.center.x, 10);
    _name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _name.backgroundColor = [UIColor clearColor];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.textColor = [UIColor asbestosColor];
    _name.font = [UIFont boldFlatFontOfSize:18];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _header.frame.size.width, 20)];
    _time.center = CGPointMake(_header.center.x, 20+_name.frame.size.height);
    _time.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _time.backgroundColor = [UIColor clearColor];
    _time.textAlignment = NSTextAlignmentCenter;
    _time.textColor = [UIColor asbestosColor];
    _time.font = [UIFont boldFlatFontOfSize:14];
    
    _button = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _button.center = CGPointMake(_header.center.x, _imgView.center.y+60);
    _button.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    _button.shadowColor = [UIColor clearColor];
    _button.buttonColor = [UIColor clearColor];
    _button.cornerRadius = 4.0f;
    _button.shadowHeight = 3.0f;
    _button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_button addTarget:self action:@selector(toggleSecurity) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [_header addSubview:_imgView];
    [_header addSubview:_name];
    [_header addSubview:_time];
    [_header addSubview:_button];
    self.tableView.tableHeaderView = _header;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
    _timer = nil;
    [super viewDidDisappear:animated];
}

- (void)chooseCamera
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Camera"
                                 delegate:self
                        cancelButtonTitle:nil
                   destructiveButtonTitle:nil
                        otherButtonTitles:nil];
    //Add cam names to btns
    for (RKCamera *cam in _cams) [sheet addButtonWithTitle:cam.name];
    [sheet addButtonWithTitle:@"Cancel"];
    [sheet setCancelButtonIndex:_cams.count];
    [sheet showInView:self.view];
}

- (void)updateSecurity
{
    _name.text = @"Home System";
    if([_state.state isEqualToString:@"armed"]){
        _time.text = _state.timestamp;
        [_imgView setImage:[UIImage imageNamed:@"lock.png"]];
        [_button setTitle:@"Disarm" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.buttonColor = [UIColor pumpkinColor];
        _button.enabled = YES;
    }else if([_state.state isEqualToString:@"arming"]){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(armTimeout) userInfo:nil repeats:YES];
        _time.text = [NSString stringWithFormat:@"Arming in... %i", _state.armTimeout.intValue];
        [_imgView setImage:[UIImage imageNamed:@"unlock.png"]];
        [_button setTitle:@"Arm" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor primaryBackground] forState:UIControlStateNormal];
        _button.buttonColor = [UIColor concreteColor];
        _button.enabled = NO;
    }else{
        _time.text = _state.timestamp;
        [_imgView setImage:[UIImage imageNamed:@"unlock.png"]];
        [_button setTitle:@"Arm" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor primaryBackground] forState:UIControlStateNormal];
        _button.buttonColor = [UIColor concreteColor];
        _button.enabled = YES;
    }
}

- (void)toggleSecurity
{
    BOOL armed = [_state.state isEqualToString:@"armed"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:armed? @"Disarm System":@"Arm System" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:armed? @"Disarm":@"Arm", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alert textFieldAtIndex:0] setTextAlignment:NSTextAlignmentCenter];
    [alert show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return [[alertView textFieldAtIndex:0] text].length == 4? YES : NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == _cams.count) return;
    CameraController *viewController = [[CameraController alloc] initWithCamera:[_cams objectAtIndex:buttonIndex]];
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}


//User has chosen to arm/disarm the system
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex) return;
    BOOL arming = [_state.state isEqualToString:@"disarmed"];
    NSString *pinkey = [AppDelegate hashFromPin:[[alertView textFieldAtIndex:0] text]];
    NSDictionary *params = @{@"id":@(_id), @"pinkey":pinkey, @"state":arming? @"arm":@"disarm"};
    
    [APIManager postRequest:@"/security" withParams:params andCallback:^(BOOL success, id res){
        if(!success) //Invalid pinkey
            [[[UIAlertView alloc] initWithTitle:@"Unauthorized" message:[[res object] valueForKey:@"error"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        else
        {
            _state.state = arming? @"arming":@"disarmed";
            [self updateSecurity];
            for(int i=0; i<_locks.count; i++)
                [(LockCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] enabled:_button.enabled];
        }
    } andIndeterminateHUDInView:nil];
}

- (void)armTimeout
{
    _state.armTimeout = [NSNumber numberWithInt:_state.armTimeout.intValue-1];
    _time.text = [NSString stringWithFormat:@"Arming in... %i", _state.armTimeout.intValue];
    if ([_state.armTimeout intValue] == 0) {
        [_timer invalidate];
        _timer = nil;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] reloadCenter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _locks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LockCell *cell = [[LockCell alloc] initWithLock:[_locks objectAtIndex:indexPath.row] andUser:_id];
    [cell enabled:_button.enabled];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
