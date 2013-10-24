//
//  SettingsController.m
//  peak
//
//  Created by Hugh Boylan on 8/23/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "SettingsController.h"

@interface SettingsController() {
    NSDictionary *_sections;
}
@end

@implementation SettingsController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _sections = [[NSDictionary alloc] initWithObjects:@[@[@"Username", @"Password", @"Pin"]] forKeys:@[@"User"]];
        _user = [APIManager cachedUser];
        _userVals = [[NSMutableArray alloc] initWithArray:@[_user.username, @"xxxxxxxx", @"xxxx"]];
        _fields = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate stylePrimaryTableView:self.tableView];
    self.title = @"Settings";
    self.navigationItem.leftBarButtonItem = [CustomBarBtn create];
    
    //Save settings btn
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    [saveBtn configureFlatButtonWithColor:[UIColor clearColor] highlightedColor:[UIColor clearColor] cornerRadius:4.0f];
    [saveBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)save:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Current password" message:@"to update user settings" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [AppDelegate primaryHeaderSection:section setLabel:^(){
        return [[_sections allKeys] objectAtIndex:section];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [AppDelegate primaryHeaderHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [[_sections allKeys] objectAtIndex:section];
    return [[_sections valueForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"SettingsCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    cell.textLabel.font = [UIFont flatFontOfSize:16];
    cell.textLabel.textColor = [UIColor asbestosColor];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    top.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    top.backgroundColor = [UIColor secondaryBackground];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, 185, 30)];
    if(indexPath.row == 1 || indexPath.row == 2) field.secureTextEntry = YES;
    if(indexPath.row == 2) field.secureTextEntry = YES;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.font = [UIFont flatFontOfSize:14];
    field.text = [_userVals objectAtIndex:indexPath.row];
    field.textColor = [UIColor wetAsphaltColor];
    [_fields addObject:field];
    
    [cell addSubview:top];
    [cell addSubview:field];

    NSString *key = [[_sections allKeys] objectAtIndex:indexPath.section];
    cell.textLabel.text = [[_sections valueForKey:key] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex) return;
    NSLog(@"save");
    return;
    NSString *passkey = [AppDelegate hashFromPin:[[alertView textFieldAtIndex:0] text]];
    NSString *username = ((UITextField*)[_fields objectAtIndex:0]).text;
    NSDictionary *params = @{@"currentPass":passkey, @"id":_user.id.stringValue, @"username":username, @"newPass":_passkey, @"pin":_pinkey};
    
    [APIManager postRequest:@"/user/settings" withParams:params andCallback:^(BOOL success, id res){
        
    } andIndeterminateHUDInView:nil];
}

#pragma mark - MBProgressHUD delegate

- (void)closeFields
{
    for (UITextField *field in _fields) [field resignFirstResponder];
}

@end
