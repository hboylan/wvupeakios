//
//  LeftViewController.m
//  BouletinBoard
//
//  Created by Hugh Boylan on 12/9/12.
//  Copyright (c) 2012 Bouletin. All rights reserved.
//
#import "AppDelegate.h"
#import "SideController.h"
#import "LoginController.h"
#import "LightController.h"
#import "FAWebServiceCache.h"

@implementation SideController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        _order = @[@"Lights", @"Security", @"Appliances", @"Speakers", @"Media", @"Health"];
        // Match System with text icon
        _systems = @{@"Lights":@"", @"Speakers":@"", @"Media":@"", @"Security":@"", @"Appliances":@"", @"Health":@""};
        _user = [APIManager cachedUser];
        _selected = [[SelectedCell alloc] init];
        _selected.section = 1;
        _selected.row = 0;
    }
    return self;
}

- (NSString*)getCurrentView
{
    if(_selected.section == 0)
        return @"Settings";
    return [_order objectAtIndex:_selected.row];
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate styleSecondaryTableView:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
        return 2;
    return [_systems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = self.tableView.backgroundColor;
    [cell setSelectedBackgroundView:[AppDelegate selectedCellBackground]];
    
    // Configure the cell...
    if(indexPath.section == 0)
        cell.textLabel.text = indexPath.row? @" Logout" : @" Settings";
    else if(indexPath.section == 1)
    {
        NSString *name = [_order objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [_systems objectForKey:name], name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL selected = indexPath.section == _selected.section && indexPath.row == _selected.row;
    cell.textLabel.font = [UIFont fontWithName:@"linecons" size:18];
    cell.textLabel.textColor = selected? [UIColor whiteColor]:[UIColor secondaryBackground];
    cell.selected = selected? YES : NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [((AppDelegate*)[[UIApplication sharedApplication] delegate]) isTablet]? 44:36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [AppDelegate secondaryHeaderHeight:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [AppDelegate secondaryHeaderSection:section setLabel:^NSString* {
        return section? [NSString stringWithFormat:@"Home Systems"] : _user.username;
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selected.section = indexPath.section;
    _selected.row = indexPath.row;
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    if(indexPath.section == 0)
        if(indexPath.row == 1){
            [APIManager postRequest:@"/logout" withParams:nil andIndeterminateHUDInView:nil];
            [FAWebServiceCache saveCacheWithIdentifier:@"user" data:nil];
            [app showLogin];
        }
        else [app changeCenter:@"Settings"];
    else [app changeCenter:indexPath.section? [_order objectAtIndex:indexPath.row] : nil];
    
    [self.tableView reloadData];
}

@end
