//
//  ZoneController.m
//  peak
//
//  Created by Hugh Boylan on 8/6/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "LightController.h"
#import "AppDelegate.h"
#import "LightCell.h"
#import "SelectedCell.h"

@implementation LightController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [APIManager mappedRequest:@"/lights" withCallback:^(BOOL success, RKMappingResult *res) {
            _zones = success? [res array] : nil;
            if(_zones) [self getLights];
            [self.tableView reloadData];
        } andIndeterminateHUDInView:self.tableView];
        _openLights = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getLights
{
    NSError *err = [[NSError alloc] init];
    for (RKLights *zone in _zones){
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (id l in zone.lights) {
            RKLight *light = [RKLight new];
            [[[RKMappingOperation alloc] initWithSourceObject:l destinationObject:light mapping:[RKLight mapping]] performMapping:&err];
            [arr addObject:light];
        }
        zone.lights = arr;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate stylePrimaryTableView:self.tableView];
    [self setTitle:@"Lights"];
    
    self.navigationItem.leftBarButtonItem = [CustomBarBtn create];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Usage" style:UIBarButtonItemStylePlain target:self action:@selector(showUsage)];
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
        RKLights *zone = [_zones objectAtIndex:section];
        return zone.name;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _zones.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RKLights *zone = [_zones objectAtIndex:section];
    return zone.lights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell"];
    if(cell == nil) cell = [[LightCell alloc] init];
    [cell setLight:[((RKLights*)[_zones objectAtIndex:indexPath.section]).lights objectAtIndex:indexPath.row]
           andOpen:[SelectedCell cellOpen:_openLights atIndexPath:indexPath] >= 0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SelectedCell cellOpen:_openLights atIndexPath:indexPath] >= 0? 88:44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [AppDelegate primaryHeaderHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LightCell *cell = (LightCell*)[tableView cellForRowAtIndexPath:indexPath];
    int selectedIndex = [SelectedCell cellOpen:_openLights atIndexPath:indexPath];
    if(selectedIndex >= 0){//close
        [cell toggle:NO animated:YES];
        [_openLights removeObjectAtIndex:selectedIndex];
    }else{ //open
        [cell toggle:YES animated:YES];
        [_openLights addObject:[SelectedCell cellWithIndexPath:indexPath]];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

@end
