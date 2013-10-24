//
//  EnergyController.m
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "EnergyController.h"
#import "QolsysCell.h"
#import "NexiaCell.h"

@interface EnergyController ()

@end

@implementation EnergyController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [APIManager mappedRequest:@"/appliances" withCallback:^(BOOL success, RKMappingResult *res){
            _zones = [res array];
            [self.tableView reloadData];
        } andIndeterminateHUDInView:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppDelegate stylePrimaryTableView:self.tableView];
    self.title = @"Appliances";
    self.navigationItem.leftBarButtonItem = [CustomBarBtn create];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _zones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKAppliance *app = [_zones objectAtIndex:indexPath.row];
    
    return app.right? [[QolsysCell alloc] initWithAppliance:app]:[[NexiaCell alloc] initWithAppliance:app];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
